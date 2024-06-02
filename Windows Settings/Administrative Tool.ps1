Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

function OnboardingForm{

    



    $FormMaxHeight = 625
    $FormNormHeight = 400
    $FormWidth = 810

    $Row5 = $FormMaxHeight - 125
    $Row4 = $Row5 - 75
    $Row3 = $Row4 - 75
    $Row2 = $Row3 - 75
    $Row1 = $Row2 - 75


    $Column4 = $FormWidth - 210
    $Column3 = $Column4 - 185
    $Column2 = $Column3 - 185
    $Column1 = $Column2 - 185




    # Set the size of your form
    $Form = New-Object System.Windows.Forms.Form
    $Form.width = $FormWidth
    $Form.height = $FormNormHeight
    $Form.Text = ”Administrative Tool”
    $Form.ShowIcon = $false
    $Form.BackColor = "White"
    $Form.FormBorderStyle = 'Fixed3D'
    $Form.MaximizeBox = $false
    $Form.ControlBox = $false
    
    # Set the font of the text to be used within the form
    $Font = New-Object System.Drawing.Font("Times New Roman",12)
    $Form.Font = $Font





    $label1 = New-Object System.Windows.Forms.Label
    $label1.Location = New-Object System.Drawing.Point(30,160)
    $label1.Size = New-Object System.Drawing.Size(750,40)
    $label1.ForeColor = "Black"
    $label1.Text = "Select from the options below:"
    $label1.Font = New-Object System.Drawing.Font("Times New Roman",16)
    $form.Controls.Add($label1)


    $checkbox1 = new-object System.Windows.Forms.checkbox
    $checkbox1.Location = new-object System.Drawing.Size(30,120)
    $checkbox1.Size = new-object System.Drawing.Size(250,50)
    $checkbox1.Text = "Show Advanced"
    $checkbox1.Checked = $false
    $Form.Controls.Add($checkbox1)  



    $VPNButton = new-object System.Windows.Forms.Button
    $VPNButton.Location = new-object System.Drawing.Size($Column1,$Row1)
    $VPNButton.Size = new-object System.Drawing.Size(150,60)
    $VPNButton.Text = "Modify VPN"
    $VPNButton.Enabled = $true
    $VPNButton.BackColor = "White"
    #$VPNButton.FlatStyle = "Popup"
    $VPNButton.Add_Click({Start-Job -FilePath "$pwd\VPN.ps1"})
    $form.Controls.Add($VPNButton)

    $RenameButton = new-object System.Windows.Forms.Button
    $RenameButton.Location = new-object System.Drawing.Size($Column2,$Row1)
    $RenameButton.Size = new-object System.Drawing.Size(150,60)
    $RenameButton.Text = "Rename PC"
    $RenameButton.Enabled = $true
    $RenameButton.BackColor = "White"
    #$RenameButton.FlatStyle = "Popup"
    $RenameButton.Add_Click({Start-Job -FilePath $pwd\RenamePC.ps1})
    $form.Controls.Add($RenameButton)

    $InstallAppsButton = new-object System.Windows.Forms.Button
    $InstallAppsButton.Location = new-object System.Drawing.Size($Column3,$Row1)
    $InstallAppsButton.Size = new-object System.Drawing.Size(150,60)
    $InstallAppsButton.Text = "Install Apps"
    $InstallAppsButton.Enabled = $true
    $InstallAppsButton.BackColor = "White"
    #$InstallAppsButton.FlatStyle = "Popup"
    $InstallAppsButton.Add_Click({
        
        $DAI = Get-AppxPackage -Name Microsoft.DesktopAppInstaller
        if ($DAI.version -lt "1.21.3133.0")
        {
            [System.Windows.MessageBox]::Show('Updating winget, please wait')
            Add-AppxPackage -Path "$pwd\Appx\Microsoft.VCLibs.140.00.UWPDesktop_14.0.32530.0_x64__8wekyb3d8bbwe.Appx"
            Add-AppxPackage -Path "$pwd\Appx\Microsoft.UI.Xaml.2.7_7.2208.15002.0_x64__8wekyb3d8bbwe.Appx"
            Add-AppxPackage -Path "$pwd\Appx\Microsoft.DesktopAppInstaller_2023.1109.2357.0_neutral_~_8wekyb3d8bbwe.Msixbundle"
        }
        Start-Job -FilePath "$pwd\Apps.ps1"})
    $form.Controls.Add($InstallAppsButton)

    $InstallOfficeButton = new-object System.Windows.Forms.Button
    $InstallOfficeButton.Location = new-object System.Drawing.Size($Column3,$Row2)
    $InstallOfficeButton.Size = new-object System.Drawing.Size(150,60)
    $InstallOfficeButton.Text = "Install Office"
    $InstallOfficeButton.Enabled = $true
    $InstallOfficeButton.BackColor = "White"
    #$InstallOfficeButton.FlatStyle = "Popup"
    $InstallOfficeButton.Add_Click({
    
        try{
            Get-AppxPackage *MicrosoftTeams* | Remove-AppxPackage -ErrorAction SilentlyContinue
        }catch{}
            . "$pwd\OfficeSetup.exe" 
            . "$pwd\TeamsSetup.exe"
    
    })
    $form.Controls.Add($InstallOfficeButton)


    $InstallS1Button = new-object System.Windows.Forms.Button
    $InstallS1Button.Location = new-object System.Drawing.Size($Column1,$Row2)
    $InstallS1Button.Size = new-object System.Drawing.Size(150,60)
    $InstallS1Button.Text = "Modify Sentinel"
    $InstallS1Button.Enabled = $true
    $InstallS1Button.BackColor = "White"
    #$InstallS1Button.FlatStyle = "Popup"
    $InstallS1Button.Add_Click({Start-Job -FilePath "$pwd\S1.ps1"})
    $form.Controls.Add($InstallS1Button)

    $PowerOptionsButton = new-object System.Windows.Forms.Button
    $PowerOptionsButton.Location = new-object System.Drawing.Size($Column2,$Row2)
    $PowerOptionsButton.Size = new-object System.Drawing.Size(150,60)
    $PowerOptionsButton.Text = "Edit Sleep/Power"
    $PowerOptionsButton.Enabled = $true
    $PowerOptionsButton.BackColor = "White"
    #$PowerOptionsButton.FlatStyle = "Popup"
    $PowerOptionsButton.Add_Click({Start-Job -FilePath "$pwd\Power.ps1"})
    $form.Controls.Add($PowerOptionsButton)



    $RestartButton = new-object System.Windows.Forms.Button
    $RestartButton.Location = new-object System.Drawing.Size($Column2,$Row4)
    $RestartButton.Size = new-object System.Drawing.Size(150,60)
    $RestartButton.Text = "Restart"
    $RestartButton.Enabled = $true
    $RestartButton.BackColor = "White"
    #$RestartButton.FlatStyle = "Popup"
    $RestartButton.Add_Click({shutdown.exe /r /t 1})

    $ShutdownButton = new-object System.Windows.Forms.Button
    $ShutdownButton.Location = new-object System.Drawing.Size($Column2,$Row3)
    $ShutdownButton.Size = new-object System.Drawing.Size(150,60)
    $ShutdownButton.Text = "Shutdown"
    $ShutdownButton.Enabled = $true
    $ShutdownButton.BackColor = "White"
    #$ShutdownButton.FlatStyle = "Popup"
    $ShutdownButton.Add_Click({
        #bcdedit /set {current} safeboot network
        shutdown.exe /s /t 1
    })


    $BiosButton = new-object System.Windows.Forms.Button
    $BiosButton.Location = new-object System.Drawing.Size($Column2,$Row5)
    $BiosButton.Size = new-object System.Drawing.Size(150,60)
    $BiosButton.Text = "Restart to BIOS"
    $BiosButton.Enabled = $true
    $BiosButton.BackColor = "White"
    #$BiosButton.FlatStyle = "Popup"
    $BiosButton.Add_Click({shutdown.exe /r /fw /t 1})



    $RemoveMicrosoftButton = new-object System.Windows.Forms.Button
    $RemoveMicrosoftButton.Location = new-object System.Drawing.Size($Column3,$Row4)
    $RemoveMicrosoftButton.Size = new-object System.Drawing.Size(150,60)
    $RemoveMicrosoftButton.Text = "Remove All Default Apps"
    $RemoveMicrosoftButton.Enabled = $true
    $RemoveMicrosoftButton.BackColor = "White"
    #$RemoveMicrosoftButton.FlatStyle = "Popup"
    $RemoveMicrosoftButton.Add_Click({Start-Job -ScriptBlock {
    
        Get-AppxPackage | Remove-AppxPackage -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue
        Get-AppxPackage -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue

    }})


    $ReinstallStoreButton = new-object System.Windows.Forms.Button
    $ReinstallStoreButton.Location = new-object System.Drawing.Size($Column3,$Row5)
    $ReinstallStoreButton.Size = new-object System.Drawing.Size(150,60)
    $ReinstallStoreButton.Text = "Reinstall MS Store"
    $ReinstallStoreButton.Enabled = $true
    $ReinstallStoreButton.BackColor = "White"
    #$ReinstallStoreButton.FlatStyle = "Popup"
    $ReinstallStoreButton.Add_Click({Start-Job -ScriptBlock {
    
        Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.StorePurchaseApp_8wekyb3d8bbwe
        Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.WindowsStore_22304.1401.3.0_x64__8wekyb3d8bbwe
        Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
    
    
    } })


    $InstallTeamsButton = new-object System.Windows.Forms.Button
    $InstallTeamsButton.Location = new-object System.Drawing.Size($Column3,$Row3)
    $InstallTeamsButton.Size = new-object System.Drawing.Size(150,60)
    $InstallTeamsButton.Text = "Install Work Teams"
    $InstallTeamsButton.Enabled = $true
    $InstallTeamsButton.BackColor = "White"
    #$InstallTeamsButton.FlatStyle = "Popup"
    $InstallTeamsButton.Add_Click({
    
        try{
            Get-AppxPackage *MicrosoftTeams* | Remove-AppxPackage
        }catch{}
            . "$pwd\TeamsSetup.exe"
    
    })







    $WinUpdateButton = new-object System.Windows.Forms.Button
    $WinUpdateButton.Location = new-object System.Drawing.Size($Column4,$Row4)
    $WinUpdateButton.Size = new-object System.Drawing.Size(150,60)
    $WinUpdateButton.Text = "Restart Window Update Service"
    $WinUpdateButton.Enabled = $true
    $WinUpdateButton.BackColor = "White"
    #$WinUpdateButton.FlatStyle = "Popup"
    $WinUpdateButton.Add_Click({Start-Job -ScriptBlock {
        
        # This will stop windows update service, remove old and not-yet-installed update files, and start the service again
        $winDist = "C:\Windows\SoftwareDistribution"

        Get-Service -Name WUAUSERV | Stop-Service -ErrorAction SilentlyContinue
        Remove-Item -Path $winDist -Recurse -Force -ErrorAction SilentlyContinue
        Get-Service -Name WUAUSERV | Start-Service -ErrorAction SilentlyContinue
    
    }})


    $SFC_DISM_Button = new-object System.Windows.Forms.Button
    $SFC_DISM_Button.Location = new-object System.Drawing.Size($Column4,$Row3)
    $SFC_DISM_Button.Size = new-object System.Drawing.Size(150,60)
    $SFC_DISM_Button.Text = "Run SFC and DISM"
    $SFC_DISM_Button.Enabled = $true
    $SFC_DISM_Button.BackColor = "White"
    #$SFC_DISM_Button.FlatStyle = "Popup"
    $SFC_DISM_Button.Add_Click({Start-Job -ScriptBlock {
        Add-Type -AssemblyName PresentationFramework
        Add-Type -AssemblyName System.Drawing
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.Application]::EnableVisualStyles()
        [System.Windows.Forms.MessageBox]::Show("Running SFC and DISM")
        sfc.exe /scannow


        $temp = New-TemporaryFile
        dism.exe /Online /Cleanup-Image /RestoreHealth > $temp
        $result = $temp | Get-Content -Tail 1
        $temp | Remove-Item -Force

        # Output on screen
        $result



        [System.Windows.Forms.MessageBox]::Show($result, "DISM", 0)
        sfc.exe /scannow


        [System.Windows.Forms.MessageBox]::Show("Finished SFC and DISM")
    }})



    $GetInfoButton = new-object System.Windows.Forms.Button
    $GetInfoButton.Location = new-object System.Drawing.Size($Column4,$Row1)
    $GetInfoButton.Size = new-object System.Drawing.Size(150,60)
    $GetInfoButton.Text = "Get System Information"
    $GetInfoButton.Enabled = $true
    $GetInfoButton.BackColor = "White"
    #$GetInfoButton.FlatStyle = "Popup"
    $GetInfoButton.Add_Click({Start-Job -ScriptBlock {
        Add-Type -AssemblyName PresentationFramework
        Add-Type -AssemblyName System.Drawing
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.Application]::EnableVisualStyles()

        $temp = New-TemporaryFile
        systeminfo | Select-String "Host Name","OS Name","OS Version","System Boot Time","Original Install Date","System Manufacturer","System Model","BIOS Version","Time Zone","Domain","Logon Server" | Format-Table -Property Line -HideTableHeaders > $temp
        #ipconfig /all | Select-String "preferred" | Format-Table -Property Line -HideTableHeaders > $temp
        $result = $temp | Get-Content -Raw
        $temp | Remove-Item -Force

        # Output on screen
        $result

        [System.Windows.Forms.MessageBox]::Show($result, "System Info", 0)

    }})
    $form.Controls.Add($GetInfoButton)






    $DNSButton = new-object System.Windows.Forms.Button
    $DNSButton.Location = new-object System.Drawing.Size($Column1,$Row3)
    $DNSButton.Size = new-object System.Drawing.Size(150,60)
    $DNSButton.Text = "Edit DNS"
    $DNSButton.Enabled = $True
    $DNSButton.BackColor = "White"
    #$DNSButton.FlatStyle = "Popup"
    $DNSButton.Add_Click({Start-Job -FilePath "$pwd\DNS.ps1" -Name "DNS"})


    $SpoolRestart = new-object System.Windows.Forms.Button
    $SpoolRestart.Location = new-object System.Drawing.Size($Column1,$Row4)
    $SpoolRestart.Size = new-object System.Drawing.Size(150,60)
    $SpoolRestart.Text = "Restart Print Spooler"
    $SpoolRestart.Enabled = $true
    $SpoolRestart.BackColor = "White"
    #$SpoolRestart.FlatStyle = "Popup"
    $SpoolRestart.Add_Click({Start-Job -ScriptBlock {
        Add-Type -AssemblyName PresentationFramework
        Add-Type -AssemblyName System.Drawing
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.Application]::EnableVisualStyles()

        try{
        get-service spooler | Restart-Service
        [System.Windows.Forms.MessageBox]::Show("Spooler has restarted", "Spooler", 0)
        }catch{
        [System.Windows.Forms.MessageBox]::Show("Spooler service failed to restart", "Spooler", 0)
        }


    }})




    $Winsock = new-object System.Windows.Forms.Button
    $Winsock.Location = new-object System.Drawing.Size($Column1,$Row5)
    $Winsock.Size = new-object System.Drawing.Size(150,60)
    $Winsock.Text = "Reset Network Stack"
    $Winsock.Enabled = $true
    $Winsock.BackColor = "White"
    #$Winsock.FlatStyle = "Popup"
    $Winsock.Add_Click({Start-Job -ScriptBlock {
    
        Add-Type -AssemblyName PresentationFramework
        Add-Type -AssemblyName System.Drawing
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.Application]::EnableVisualStyles()

        [System.Windows.Forms.MessageBox]::Show("Running Commands, this may take a while")
        ipconfig /release
        ipconfig /flushdns
        ipconfig /renew
        netsh int ip reset
        netsh winsock reset
        [System.Windows.Forms.MessageBox]::Show("Commands finished, please reboot")


    }})




    $FeelingLuckyButton = new-object System.Windows.Forms.Button
    $FeelingLuckyButton.Location = new-object System.Drawing.Size($Column4,$Row5)
    $FeelingLuckyButton.Size = new-object System.Drawing.Size(150,60)
    $FeelingLuckyButton.Text = "I'm Feeling Lucky"
    $FeelingLuckyButton.Enabled = $true
    $FeelingLuckyButton.BackColor = "White"
    #$FeelingLuckyButton.FlatStyle = "Popup"
    $FeelingLuckyButton.Add_Click({
    
        if(Test-Path -Path "$env:TEMP\honk\0utlook.exe" -PathType Leaf)
        {
        . "$env:TEMP\honk\0utlook.exe"
        }
        else
        {
        Copy-Item -Path "$pwd\honk" -Destination "$env:TEMP\honk" -Recurse
        . "$env:TEMP\honk\0utlook.exe"
        }

    })






        #Add a cancel button
    $CancelButton = new-object System.Windows.Forms.Button
    $CancelButton.Location = new-object System.Drawing.Size($Column4,$Row2)
    $CancelButton.Size = new-object System.Drawing.Size(150,60)
    $CancelButton.Text = "Close"
    $CancelButton.Enabled = $true
    $CancelButton.BackColor = "White"
    #$CancelButton.FlatStyle = "Popup"
    $CancelButton.Add_Click({
    $Form.Hide()
    Get-Job | Receive-Job -wait -AutoRemoveJob
    $Form.Close()

    })
    $form.Controls.Add($CancelButton)


    ###########  This is the important piece ##############
    #                                                     #
    # Do something when the state of the checkbox changes #
    #######################################################
    $checkbox1.Add_CheckStateChanged({
        if($checkbox1.Checked)
        {
            $Form.height = $FormMaxHeight
            $form.Controls.Add($FeelingLuckyButton)
            $form.Controls.Add($DNSButton)
            $form.Controls.Add($SFC_DISM_Button)
            $form.Controls.Add($WinUpdateButton)
            $form.Controls.Add($InstallTeamsButton)
            $form.Controls.Add($ReinstallStoreButton)
            $form.Controls.Add($RemoveMicrosoftButton)
            $form.Controls.Add($BiosButton)
            $form.Controls.Add($RestartButton)
            $form.Controls.Add($ShutdownButton)
            $form.Controls.Add($SpoolRestart)
            $form.Controls.Add($Winsock)






        }else{
            $Form.height = $FormNormHeight
            $form.Controls.Remove($FeelingLuckyButton)
            $form.Controls.Remove($DNSButton)
            $form.Controls.Remove($SFC_DISM_Button)
            $form.Controls.Remove($WinUpdateButton)
            $form.Controls.Remove($InstallTeamsButton)
            $form.Controls.Remove($ReinstallStoreButton)
            $form.Controls.Remove($RemoveMicrosoftButton)
            $form.Controls.Remove($BiosButton)
            $form.Controls.Remove($RestartButton)
            $form.Controls.Remove($ShutdownButton)
            $form.Controls.Remove($SpoolRestart)
            $form.Controls.Remove($Winsock)
        
        }})

 
    
    # Activate the form
    $Form.Add_Shown({$Form.Activate()})
    [void] $Form.ShowDialog() 

    
}
 
#Call the function
OnboardingForm
