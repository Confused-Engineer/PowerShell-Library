<#
    .SYNOPSIS
    This tool uses a program offered by microsoft to clear RAM without a reboot or user interaction


    .DESCRIPTION
    RAMMap.exe is downloaded from https://live.sysinternals.com/RAMMap.exe which is owned and operated by Microsoft and offers command line options to clear RAM.
    By downloading it to a directory and running it as administrator we are able to clear out RAM without any user interaction or interuptions.

#>

#Variables

$WebFile = 'https://live.sysinternals.com/RAMMap.exe'
$LocalFile = 'C:\temp\RAMMap.exe'
$ArgList = @("-Ew","-Es","-Em","-Et","-E0")

$RegPath = "HKCU:\Software\Sysinternals\RAMMap"
$RegItem = "EulaAccepted"
$RegValue = 1


#Make Temp folder if it doesnt exist

New-Item -ItemType Directory -Path "C:\temp" -ErrorAction SilentlyContinue

#download needed program

Invoke-WebRequest -Uri $WebFile -OutFile $LocalFile

#Add registry value so the EULA does not pop up for user, needed the sleep so the registry can close before RAMMap tries to check it (I think)
if(((Get-ItemProperty -Path $RegPath -Name $RegItem -ErrorAction SilentlyContinue).$RegItem) -ne $RegValue)  {

    New-Item -Path $RegPath -Force | Out-Null
    New-ItemProperty -Path $RegPath -Name $RegItem -Value $RegValue -PropertyType DWORD -Force | Out-Null

}

Start-Sleep -Seconds 1


#Start each and then sleep for X seconds to avoid "rpocess being used by another program" error
foreach ($Arg in $ArgList){
    & "$LocalFile" @("$Arg")
    Start-Sleep 20
}


#commented out but this is what is needed to show command line arguments
#& "$LocalFile" @("--help")