Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()



$List = @(
    "Disable-Fast-Startup",
    "Never-Sleep",
    "Enable-High-Performance")

$Title = "Power Configuration"
$Subtitle = "Select Power Options From List Below"



$form = New-Object System.Windows.Forms.Form -Property @{
    StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    Size          = New-Object Drawing.Size 300, 200
    Text          = "$Title"
    Topmost       = $true

}

    $Form.FormBorderStyle = 'Fixed3D'
    $Form.MaximizeBox = $false
    $Form.ControlBox = $false

$okButton = New-Object System.Windows.Forms.Button -Property @{
    Location     = New-Object Drawing.Point 75, 120
    Size         = New-Object Drawing.Size 75, 23
    Text         = 'OK'
    DialogResult = [Windows.Forms.DialogResult]::OK
}
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)



$cancelButton = New-Object System.Windows.Forms.Button -Property @{
    Location     = New-Object Drawing.Point 150, 120
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
    Size = New-Object System.Drawing.Size(260,20)
    SelectionMode = 'MultiExtended'
    Font = New-Object System.Drawing.Font("Lucida Console",10,[System.Drawing.FontStyle]::Regular)

}



foreach ($item in $List){
        [void] $listBox.Items.Add($item)
}



$listBox.Height = 70
$form.Controls.Add($listBox)
$form.Topmost = $true


$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{

    $PowerAnswers = $listBox.SelectedItems
        if($PowerAnswers -contains "Enable-High-Performance"){

            powercfg -SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

        }

        if($PowerAnswers -contains "Disable-Fast-Startup"){
            powercfg /h off
        }

        if($PowerAnswers -contains "Never-Sleep"){
            powercfg.exe -x -disk-timeout-ac 0
            powercfg.exe -x -disk-timeout-dc 0
            powercfg.exe -x -standby-timeout-ac 0
            powercfg.exe -x -standby-timeout-dc 0
            powercfg.exe -x -hibernate-timeout-ac 0
            powercfg.exe -x -hibernate-timeout-dc 0
        }
}