$Run_Selected = Read-Host "Enter Install, Repair, Uninstall, or Fix Tamper Protection. (i,r,u,f)"
$Site_Token = Read-Host "Enter the Site Token if Installing, Repairing, or Uninstalling"
$Passphrase = Read-Host "Enter the devices sentinel passphrase if fixing tamper protection"

New-Item -ItemType Directory -Path "C:\temp" -ErrorAction SilentlyContinue

Function Fix-TamperProtection
{
    $folders = Get-ChildItem -Path "C:\Program Files\SentinelOne"
    foreach ($folder_available in $folders.name)
    {
        if(Test-Path "C:\Program Files\SentinelOne\$folder_available\Sentinelctl.exe" -PathType Leaf)
        {
            $SentinelCTL_Path = "C:\Program Files\SentinelOne\$folder_available\Sentinelctl.exe"
            & $SentinelCTL_Path @("unprotect","-k $Passphrase")
            & $SentinelCTL_Path @("unload","-slamH")
            & $SentinelCTL_Path @("load","-slamH")
            & $SentinelCTL_Path @("protect")
        
        }
    }
}

Function Download-SentinelOne 
{
    if ((Get-WmiObject win32_operatingsystem | Select-Object osarchitecture).osarchitecture -eq "32-bit")
    {
        #PROVIDE YOUR OWN DOWNLOAD LINK IN THE URI 
        Invoke-WebRequest -Uri '' -OutFile 'C:\temp\SentinelTool.exe'
    }
    else
    {
        #PROVIDE YOUR OWN DOWNLOAD LINK IN THE URI 
        Invoke-WebRequest -Uri '' -OutFile 'C:\temp\SentinelTool.exe'
    }
}

switch ("$Run_Selected")
{
    'i'
    {
        Download-SentinelOne 
        & "C:\temp\SentinelTool.exe" @("--qn","-t $Site_Token")  
    }


    'r'
    {
        Download-SentinelOne 
        & "C:\temp\SentinelTool.exe" @("--qn","--dont_fail_on_config_preserving_failures","--dont_preserve_config_dir","--dont_preserve_agent_uid","-t $Site_Token")
    }

    'u'
    {
        Download-SentinelOne 
        & "C:\temp\SentinelTool.exe" @("--qn","-c","-k 1","-t $Site_Token")
    }

    'f'
    {
        Fix-TamperProtection
    }
}

