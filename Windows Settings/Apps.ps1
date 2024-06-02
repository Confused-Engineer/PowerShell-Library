Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()



$List = @{
    "Firefox" = "Mozilla.Firefox";
    "Chrome" = "google.chrome";
    "7zip" = "7zip.7zip";
    "Treesize" = "JAMSoftware.TreeSize.Free";
    "Acrobate Reader DC" = "Adobe.Acrobat.Reader.64-bit";
    "Advanced IP Scanner" ="Famatech.AdvancedIPScanner";
    "Java" = "Oracle.JavaRuntimeEnvironment";
    "Putty" = "PuTTY.PuTTY";
    "QNAP" = "QNAP.QfinderPro";
    "Synology" = "Synology.Assistant";
    "Yubikey Manager" = "Yubico.YubikeyManager"
    }


$Title = "App Installer"
$Subtitle = "Select Apps to Install"




Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationCore,PresentationFramework

$form = New-Object System.Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 350, 300
    Text          = "$Title"
    Topmost       = $true
}

    $Form.FormBorderStyle = 'Fixed3D'
    $Form.MaximizeBox = $false
    $Form.ControlBox = $false

$okButton = New-Object System.Windows.Forms.Button -Property @{
    Location     = New-Object Drawing.Point 75, 220
    Size         = New-Object Drawing.Size 75, 23
    Text         = 'OK'
    DialogResult = [Windows.Forms.DialogResult]::OK
}
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)



$cancelButton = New-Object System.Windows.Forms.Button -Property @{
    Location     = New-Object Drawing.Point 200, 220
    Size         = New-Object Drawing.Size 75, 23
    Text         = 'Cancel'
    DialogResult = [Windows.Forms.DialogResult]::Cancel
}
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)




$label = New-Object System.Windows.Forms.Label -Property @{
    Location     = New-Object System.Drawing.Point(10,20)
    Size         = New-Object System.Drawing.Size(280,20)
    Text         = "$Subtitle"
}
$form.Controls.Add($label)



$listbox = New-Object System.Windows.Forms.Listbox -Property @{
    Location = New-Object System.Drawing.Point(10,40)
    Size = New-Object System.Drawing.Size(315,120)
    SelectionMode = 'MultiExtended'
    Font = New-Object System.Drawing.Font("Lucida Console",11,[System.Drawing.FontStyle]::Regular)

}



foreach ($item in $List.Keys){
        [void] $listBox.Items.Add($item)
}



$listBox.Height = 170
$form.Controls.Add($listBox)
$form.Topmost = $true


$result = $form.ShowDialog()

Function Add-Apps {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [array]$AppToInst
    )
    <#start-process powershell
    $wshell = New-Object -ComObject wscript.shell;
    $wshell.AppActivate('Windows PowerShell')
    Sleep 1
    $wshell.SendKeys('winget search 7zip {ENTER} Y {ENTER} exit {ENTER}')
    Start-Sleep 15#>
    winget search 7zip.7zip
    $AppToInst | ForEach-Object {
        Start-Job -ScriptBlock {winget install $using:PSItem -h --accept-package-agreements --accept-source-agreements} -Name $PSItem
    }
}

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{

    $AppList = $listbox.SelectedItems -join ', '
    $Confirmation = [System.Windows.MessageBox]::Show($AppList,"Apps to Install",1,0)
    if ($Confirmation -eq "OK")
    {
        $x = $List[$listbox.SelectedItems]
        Add-Apps -AppToInst $x
        Get-Job | Wait-Job  
    }

}