<#
    .SYNOPSIS
    Connect to exchange online, output mail permissions as a CSV.

    .DESCRIPTION
    Connect to exchange online, output mail permissions as a CSV.
    Does this by using exchange online to get the list of all emails, then views the permissions of each email, saves it all in one object and then saves it to a CSV

    .PARAMETER Name
    CSVout

    .OUTPUTS
    CSV file names and stores as specified by parameter 

    .EXAMPLE
    .\MailboxPermissions.ps1
    Saves CSV to "C:\temp\MailPerm.csv"

    .EXAMPLE
    .\MailboxPermissions.ps1 -CVSout "C:\exporthere\permissions.csv"
    Saves to "C:\exporthere\permissions.csv"

    .EXAMPLE
    .\MailboxPermissions.ps1 -CVSout "C:\temp\"
    ERROR

#>

param(
    [string]$CSVout = "C:\temp\MailPerm.csv"
)

$EmailList = @()
$Result = @()

if(($CSVout[-4..-1]-join '') -ne ".csv"){
    Write-Host "CSV File not specified. Input Should present as follows C:\Existing_directory(s)\file.csv"
    Exit 3
}

try{

    $EmailList = Get-Mailbox -ResultSize Unlimited
}catch [System.Management.Automation.CommandNotFoundException]{

    Import-Module ExchangeOnlineManagement
    Connect-ExchangeOnline
    $EmailList = Get-Mailbox -ResultSize Unlimited

}catch [Microsoft.Identity.Client.MsalClientException]{

    Write-Host "Exit Code 1"
    Exit 1
}catch{

    Write-Host "Unknown Error Occured:`nExit Code 2"
    Exit 2

}

if($EmailList.Count -eq $null){
    Write-Host "You likely do not have the needed permissions`nExit Code 4"
    Exit 4
}

$TotalEmails = $EmailList.Count
$Start = 1

foreach ($Email in $EmailList)
{
    Write-Progress -Activity "Gathering Permissions" -Status "$Start out of $TotalEmails Complete" -PercentComplete (($Start/$TotalEmails)*100)
    Get-MailboxPermission -Identity $Email.Name -ResultSize Unlimited | ForEach-Object {
            $Mailbox = $_
            $Result += New-Object PSObject -property @{
                Email = $Email.Name
                ID = $Mailbox.Identity
                Users = $Mailbox.User
                Access = $Mailbox.AccessRights
        }}
    $Start++
}

$Result | Export-CSV $CSVout -NoTypeInformation -Encoding UTF8