#############################################################################################
#############################################################################################
##### Disk Cleaner by David Pierce
##### Revisions on 2/23/2023 by David Pierce
##### Revisions on 2/27/2023 by David Pierce
##### Revisions on 2/28/2023 by David Pierce
##### Revisions on 3/01/2023 by David Pierce
#############################################################################################
#############################################################################################

# If you're running this script in pure powershell and not through NABLE Automations, run the following command
# Set-ExecutionPolicy Unrestricted -Force
# After you run that then you can run this powershell script normally

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

Add-Type -AssemblyName System.Windows.Forms
[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

##################################    Create Log Directory   ################################
# Testing to see if this directory exists, if it doesn't exist, then make the path
# we will use it to put our log files (you'll get the irony later)

$LogPath = "C:\Temp"
If(!(test-path -PathType container $LogPath)){
      New-Item -ItemType Directory -Path $LogPath | Out-Null
    
}

##################################   Created Directory   ####################################





################################     Functions     #################################
# We have this so powershell can know the functions when called
# A function to convert Yes/No (Y/N) questions into true or false such that we can ask the user for y/n
Function MakeBoolean {
    param($Variable)
    If ($Variable -eq "Yes") {
        $True
    }
    elseif ($Variable -eq "No") {
        $False
    }
}

Function SetLogDays{
    param($HowManyDays)
    if(!($HowManyDays -match '^\d+$')){
        $HowManyDays = 7
        $HowManyDays
    }else{
        $HowManyDays
    }
    
}

Function GetDiskSpace {
    param($FreeSpace)    
    $FreeSpace = get-psdrive c | % { $_.free/($_.used + $_.free) } 
    $FreeSpace
}

Function RemoveSoftwareDistribution {

echo "Deleting Windows Update Files" >> C:\Temp\diskcleaner.log

# Specify the Folder that Windows Stores the downloads for update files

$winDist = "C:\Windows\SoftwareDistribution"

# This will stop windows update service, remove old and not-yet-installed update files, and start the service again

Get-Service -Name WUAUSERV | Stop-Service -ErrorAction SilentlyContinue
Remove-Item -Path $winDist -Recurse -Force -ErrorAction SilentlyContinue
Get-Service -Name WUAUSERV | Start-Service -ErrorAction SilentlyContinue

echo "Deletion Completed" >> C:\Temp\diskcleaner.log

}

Function RemoveTempFolderData {

echo "Deleteing Data from Temp Folders" >> C:\Temp\diskcleaner.log

# Specifying all the different windows temporary folders and then deleting the data within them, recursivly

$tempfolders = @(“C:\Windows\Temp\*”, “C:\Windows\Prefetch\*”, “C:\Users\*\Appdata\Local\Temp\*”,"C:\EFSTMPWP\*")
Remove-Item $tempfolders -force -recurse -ErrorAction SilentlyContinue

echo "Deletion Completed" >> C:\Temp\diskcleaner.log

}

Function RemoveLogsAndDumps {

# Now we are going to take a look at log file because some programs spit out GBs of them
# specify the paths we want to look for log files

$logpath = @("C:\Program Files\*","C:\Program Files (x86)\*","C:\ProgramData\*","C:\Users\*\*","C:\Temp\*")

# because log files may be important we only want to delete log files older than a certain time period, so we specify that we want to delete files older than X days

$Days = $DeleteOlderThan

# doing the math so powershell knows how long ago X days ago was

$CutoffDate = (Get-Date).AddDays(-$Days)

echo "Deleting Log and Dump files older than $Days Day(s)" >> C:\Temp\diskcleaner.log

# finds the log files in the directories we specify, filter out the log files based on date, removes what's left (it's later)

Get-ChildItem $logpath -recurse *.log -force -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -lt $CutoffDate } | Get-ChildItem -File -ErrorAction SilentlyContinue | Remove-Item -force -ErrorAction SilentlyContinue

echo "Deletion Completed" >> C:\Temp\diskcleaner.log

}

Function RunWindowsCleaner {

echo "Using Windows Built-in Cleaner to Delete Files" >> C:\Temp\diskcleaner.log

CreateSageSet1


cleanmgr /verylowdisk /sagerun:1

echo "Deletion Completed" >> C:\Temp\diskcleaner.log

}

Function CreateSageSet1 {
# Credit to Carl Webster for the code in this function
# Check Out the Github at https://github.com/CarlWebster/Set-SageSet-1-for-Disk-Cleanup for better details on how it works
#region script parameters
[CmdletBinding(SupportsShouldProcess = $False, ConfirmImpact = "None") ]

Param(
	[parameter(Mandatory=$False)] 
	[Switch]$Downloads=$False,

	[parameter(Mandatory=$False)] 
	[Switch]$Reset=$False

	)
#endregion

#webster@carlwebster.com
#@carlwebster on Twitter
#http://www.CarlWebster.com
#Created on September 4, 2017

#Version 1.0 released to the community on May 17, 2018
#Thanks to Michael B. Smith for the code review and suggestions
#
#V1.10
#	Add -Downloads switch parameter.
#		Win10 1809 added the DOwnloads folder to the list of folders that can be cleaned.
#		-Downloads is $False by default to exlude cleaning out the Downloads folder

Set-StrictMode -Version 2

#make sure the script is running from an elevated PowerShell session
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent() )

If($currentPrincipal.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator ))
{
	#Write-Host "This is an elevated PowerShell session"
}
Else
{
	Write-Host "$(Get-Date): This is NOT an elevated PowerShell session. Script will exit."
	Exit
}

$results = Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches

If(!$?)
{
	#error
	Write-Error "Unable to retrieve data from the registry"
}
ElseIf($? -and $null -eq $results)
{
	#nothing there
	Write-Host "Didn't find anything in HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches which is odd"
}
Else
{
	ForEach($result in $results)
	{
		If($Reset -eq $False)
		{
			#this is what is returned in $result.name:
			#HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\<some name>
			#change HKEY_LOCAL_MACHINE to HKLM:
			
			If($Downloads -eq $False -and $result.name -eq "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\DownloadsFolder")
			{
				#do nothing
			}
			Else
			{
				$tmp = 'HKLM:' + $result.Name.Substring( 18 )
				$tmp2 = $result.Name.SubString( $result.Name.LastIndexOf( '\' ) + 1 )
				#Write-Host "Setting $tmp2 to 2"
				$null = New-ItemProperty -Path $tmp -Name 'StateFlags0001' -Value 2 -PropertyType DWORD -Force -EA 0
				
				If(!$?)
				{
					Write-Warning "`tUnable to set $tmp2"
				}
			}
		}
		ElseIf($Reset -eq $True)
		{
			$tmp = 'HKLM:' + $result.Name.Substring( 18 )
			$tmp2 = $result.Name.SubString( $result.Name.LastIndexOf( '\' ) + 1 )
			Write-Host "Resetting $tmp2 to 0"
			$null = New-ItemProperty -Path $tmp -Name 'StateFlags0001' -Value 0 -PropertyType DWORD -Force -EA 0
			
			If(!$?)
			{
				Write-Warning "`tUnable to set $tmp2"
			}
		}
	}
	#Write-Host "Windows Built in Cleaner Configured Correctly"
}
Set-StrictMode -Off
}

Function SecureErase {

echo "Using cipher to securely erase deleted data for PII protection" >> C:\Temp\diskcleaner.log

# cipher is not recognized as a powershell command so we call Command Prompt to run cipher
# In short overwrites deleted data, this means deleted data SHOULD NOT be recoverable (Security), and tells windows that there is more free space avialable when finished (Bonus)
cmd /c cipher /w:C: | Out-File -FilePath C:\Temp\diskcleaner.log

echo "Deletion Completed" >> C:\Temp\diskcleaner.log

}

Function RunSFC {

echo "Using sfc to Repair Any Other Integraty Violation" >> C:\Temp\diskcleaner.log
# sfc /scannow will scan windows for corrupted data and fix it
# the script should not cause data corruption, but the command is free and might as well run it occasionally anyways... right?
sfc /scannow | Out-Null #>> C:\Temp\diskcleaner.log
echo "Repair Finished" >> C:\Temp\diskcleaner.log

}

Function RunDISMs {

echo "Using DISM to Repair Windows Image as Well as Clean the Image" >> C:\Temp\diskcleaner.log

# Use DISM to fix and clean the windows image
dism.exe /Online /Cleanup-Image /RestoreHealth | Out-Null #>> C:\Temp\diskcleaner.log

#echo "RestoreHealth: Complete" >> C:\Temp\diskcleaner.log

# Delete junk
dism.exe /Online /Cleanup-Image /StartComponentCleanup | Out-Null #>> C:\Temp\diskcleaner.log

#echo "StartComponentCleanup: Complete" >> C:\Temp\diskcleaner.log

# Delete superseded junk
dism.exe /Online /Cleanup-Image /SPSuperseded | Out-Null #>> C:\Temp\diskcleaner.log

#echo "SPSuperseded: Complete" >> C:\Temp\diskcleaner.log

}

##############################      End Functions     ###############################



################################     Declaring Variables     ################################
$EnableRemoveSoftwareDistribution = [System.Windows.Forms.MessageBox]::Show("This will remove old and not-yet-installed Windows Updates, `nnot-yet-installed updates will redownload automatically. Default is Yes" , "Remove Software Distrobution Folder?" , 4, 64)
$EnableRemoveSoftwareDistribution = MakeBoolean -Variable $EnableRemoveSoftwareDistribution

$EnableRemoveTempFolderData = [System.Windows.Forms.MessageBox]::Show("This will free temporary space not actively being used by application. Default is Yes" , "Enable the Remove of Temporary Folder Data" , 4, 64)
$EnableRemoveTempFolderData = MakeBoolean -Variable $EnableRemoveTempFolderData

$EnableRemoveLogsAndDumps = [System.Windows.Forms.MessageBox]::Show("Some applications take a lot of space creating these non-essential and non-critical files, if you select yes, `nyou will be prompted to input a number so log files made before X days ago can be deleted. Default is Yes" , "Enable The cleanup of log and dump files?" , 4, 64)
$EnableRemoveLogsAndDumps = MakeBoolean -Variable $EnableRemoveLogsAndDumps

if($EnableRemoveLogsAndDumps){
    $DeleteOlderThan = [Microsoft.VisualBasic.Interaction]::InputBox("Delete Log and Dump files older than how many days? The default is 7 days meaning any file made before 7 days ago will be deleted", "Delete Logs and Dumps")
    $DeleteOlderThan = SetLogDays -HowManyDays $DeleteOlderThan
}

$EnableWindowsCleaningManager = [System.Windows.Forms.MessageBox]::Show("This will clear the Recycling Bin. The default is No", "Enable Windows Cleaning Manager. " , 4, 64)
$EnableWindowsCleaningManager = MakeBoolean -Variable $EnableWindowsCleaningManager

$EnableSecureErase = [System.Windows.Forms.MessageBox]::Show("The process will take significantly longer, but will clear more data and make deleted data unrecoverable. The Default is No" , "Enable Secure Erase?" , 4, 64)
$EnableSecureErase = MakeBoolean -Variable $EnableSecureErase
##################################     End Declaration     ##################################

############################## Documenting Selected Variables ###############################

echo "##################################################################################" >> C:\Temp\diskcleaner.log

echo "`nRemove Software Distribution: $EnableRemoveSoftwareDistribution`nRemove Temp Folder: $EnableRemoveTempFolderData`nRemove Logs and Dumps: $EnableRemoveLogsAndDumps`nOlder Than How Many Days: $DeleteOlderThan`nEnable Windows Cleaning Manager: $EnableWindowsCleaningManager`nEnable Secure Erase: $EnableSecureErase?" >> C:\Temp\diskcleaner.log


###################################### End Documentation #####################################





###################################### Start Program ########################################

# Creating a log File to show when we started, including time and date in case it is relevant
# There will be a lot of 'echo' commands
# these are just for writing lines to the log file so if it ended unexpectedly it can help determine why as well as what was happening


# Calculating the amount of free space at the beginning of this process so we can know how effective we were able to clean by the end
$DiskSpaceBefore = GetDiskSpace -FreeSpace $DiskSpaceBefore
$TimeBefore = (Get-Date)

echo "`n##########     Start Clean $(Get-Date)     ##########" >> C:\Temp\diskcleaner.log

If($EnableRemoveSoftwareDistribution){
RemoveSoftwareDistribution
}else{
echo "Removing Windows Update Folder Disabled. Proceeding..." >> C:\Temp\diskcleaner.log
}

If($EnableRemoveTempFolderData){
RemoveTempFolderData
}else{
echo "Removing Temporary Folder Data is Disabled. Proceeding..." >> C:\Temp\diskcleaner.log
}

If($EnableRemoveLogsAndDumps){
RemoveLogsAndDumps
}else{
echo "Removing Log and Dump Files is Disabled. Proceeding..." >> C:\Temp\diskcleaner.log
}

If($EnableWindowsCleaningManager){
RunWindowsCleaner
}else{
echo "Windows Cleaning Manager is Disabled. Proceeding..." >> C:\Temp\diskcleaner.log
}

If($EnableSecureErase){
SecureErase
}else {
echo "Secure Erase Not Enabled. Proceeding..." >> C:\Temp\diskcleaner.log
}

#RunSFC

#RunDISMs

#RunSFC

echo "##########     End Clean $(Get-Date)     ##########" >> C:\Temp\diskcleaner.log

$TimeAfter = (Get-Date)
$TimeElapsed = NEW-TIMESPAN –Start $TimeBefore –End $TimeAfter
echo "`nTime Elapsed: $TimeElapsed" >> C:\Temp\diskcleaner.log

# Calculate free drive space at the end of program and then display the totals at the beginning, end, and difference
$DiskSpaceAfter = GetDiskSpace -FreeSpace $DiskSpaceAfter
$TotalFreed = $DiskSpaceAfter - $DiskSpaceBefore
$TotalFreedAsPercent = $TotalFreed | % tostring p
$DiskSpaceBeforeAsPercent = $DiskSpaceBefore | % tostring p
$DiskSpaceAfterAsPercent = $DiskSpaceAfter | % tostring p


echo "`nAmount of free space at start: $DiskSpaceBeforeAsPercent`nAmount of free space at end: $DiskSpaceAfterAsPercent`nAmount of freed space: $TotalFreedAsPercent`n" >> C:\Temp\diskcleaner.log


[System.Windows.Forms.MessageBox]::Show("Total Time Elapsed: $TimeElapsed`nAmount of free space at start: $DiskSpaceBeforeAsPercent`nAmount of free space at end: $DiskSpaceAfterAsPercent`nAmount of freed space: $TotalFreedAsPercent","Completed Successfully!")

exit 0
# State when we finished


#################################### End Program ###################################
