function Connect-Exchange{
    if ($creds -eq $null)
    {
        $creds = Get-Credential
    }

    Import-Module ExchangeOnlineManagement
    Connect-ExchangeOnline -Credential $creds
}

$sender = Get-BlockedSenderAddress

foreach ($senderaddress in $sender.SenderAddress)
{

Remove-BlockedSenderAddress -SenderAddress $senderaddress

}

Get-BlockedSenderAddress