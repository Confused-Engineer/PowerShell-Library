'*'*80

#Used Read-Host instead of Params just because most people run this while connected to machine

$PathsToCheck = Read-Host "`nEnter drive letters or directories to check permissions (Comma seperated)`nExample: C:\,D:\Shared Folder"
$NamesAndGroups = Read-Host "`nEnter the names of the accounts and groups you want to check permissions (Comma Seperated)`nExample: User1,Group2"
$Domain = Read-Host "Enter the name of the domain"
$Depth = Read-Host "Enter a positive integer for how many sub folders from the root folder should be inspected`nExample: Depth of 3 will look at Rootfolder\Subfolder1\Subfolder2\Subfolder3"
$ExportPath = Read-Host "Where to Export CSV, Example: C:\Users\Yourself\Desktop"

# Have to turn inputs into arrays for parsing later, hence why inputs need formatting, with the exception of the Accounts variable

	

$PathsToCheckArray = $PathsToCheck.Split(",")
$NamesAndGroupsArray = $NamesAndGroups.Split(",")
$Accounts = $NamesAndGroupsArray | ForEach-Object {"$Domain\$_"}

'*'*80

# this was for debugging, I just wanted to see that the variables were formatted as desired; it is non-functional

$PathsToCheck
$PathsToCheckArray
$NamesAndGroups
$NamesAndGroupsArray
$Accounts

'*'*80

# this is a (not so) surpise tool that will help us later....

if (Get-Module -ListAvailable -Name "NTFSSecurity") {
    Import-Module NTFSSecurity
} 
else {
    Install-Module NTFSSecurity -AllowClobber -Force
    Import-Module NTFSSecurity
}

if (Test-Path -Path $ExportPath) {
    Write-Host "Folder already exists."
} else {
    New-Item -ItemType Directory -Path $ExportPath
}


# the real schmeat of this

foreach ($Account in $Accounts)
{

    # Tree gets the directories files to analyze, NTFS gets permissions of the user specified directies, with the for each loop getting permissions of all the subdirectories and files

    $Tree = Get-ChildItem -Path $PathsToCheckArray -Directory -Depth $Depth
    $NTFS = Get-NTFSAccess -Path $PathsToCheckArray -Account $Account

    $NTFS+= foreach ($dir in $Tree)
        {
        Get-NTFSAccess -Path $dir.FullName -Account $Account  
        #  optional you could use -ExcludeExplicit or -ExcludeInherited parameter depending your need.
        }

    <# 
        Index gets the index/position of where we are in the foreach loop, and matches it to the user Specified NamesAndGroups 
        I needed this to prevent CSV files from being overwritten and if we just used $Account then it would be domain\user or domain\group.
        This would cause Export csv to think you are exporting to a directory that doesnt exist. 
    #>

    $index = ($Accounts.IndexOf($Account))
    $NameofAccount = $NamesAndGroupsArray[$index]
    $NTFS | Export-Csv -Path "$ExportPath\$NameofAccount Access.csv" -Delimiter ";" -Encoding UTF8  -NoTypeInformation
}

