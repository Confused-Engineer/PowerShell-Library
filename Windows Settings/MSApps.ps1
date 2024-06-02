$List = @(
    "Mozilla.Firefox",
    "google.chrome",
    "7zip.7zip",
    "JAMSoftware.TreeSize.Free",
    "Adobe.Acrobat.Reader.64-bit",
    "Famatech.AdvancedIPScanner",
    "Oracle.JavaRuntimeEnvironment",
    "PuTTY.PuTTY","QNAP.QfinderPro",
    "Synology.Assistant",
    "Yubico.YubikeyManager")

$Title = "App Installer"
$Subtitle = "Select Apps to Install"

try{winget -v}catch{Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe | Out-Null}


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

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



foreach ($item in $List){
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

    $AppToInst | ForEach-Object {
        Start-Job -ScriptBlock {winget install $using:PSItem -h --accept-package-agreements --accept-source-agreements} -Name $PSItem
    }
}

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{

    $x = $listBox.SelectedItems
    Add-Apps -AppToInst $x
    Get-Job | Wait-Job
}