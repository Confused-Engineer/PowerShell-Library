Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()


function checkbox_test{
    
    # Set the size of your form
    $Form = New-Object System.Windows.Forms.Form
    $Form.width = 500
    $Form.height = 320
    $Form.Text = ”Add VPN Connection”
    $Form.ShowIcon = $false
    #$Form.BackColor = "White"
    $Form.FormBorderStyle = 'Fixed3D'
    $Form.MaximizeBox = $false
    $Form.ControlBox = $false
 
    # Set the font of the text to be used within the form
    $Font = New-Object System.Drawing.Font("Times New Roman",12)
    $Form.Font = $Font
 
    $label1 = New-Object System.Windows.Forms.Label
    $label1.Location = New-Object System.Drawing.Point(30,20)
    $label1.Size = New-Object System.Drawing.Size(400,20)
    $label1.Text = 'Please enter the VPN name:'
    $form.Controls.Add($label1)

    $textBox1 = New-Object System.Windows.Forms.TextBox
    $textBox1.Location = New-Object System.Drawing.Point(30,40)
    $textBox1.Size = New-Object System.Drawing.Size(360,20)
    $textBox1.Font = New-Object System.Drawing.Font("Lucida Console",12,[System.Drawing.FontStyle]::Regular)
    $form.Controls.Add($textBox1)


    $label2 = New-Object System.Windows.Forms.Label
    $label2.Location = New-Object System.Drawing.Point(30,70)
    $label2.Size = New-Object System.Drawing.Size(400,20)
    $label2.Text = 'Please enter the VPN Address:'
    $form.Controls.Add($label2)


    $textBox2 = New-Object System.Windows.Forms.TextBox
    $textBox2.Location = New-Object System.Drawing.Point(30,90)
    $textBox2.Size = New-Object System.Drawing.Size(360,20)
    $textBox2.Font = New-Object System.Drawing.Font("Lucida Console",12,[System.Drawing.FontStyle]::Regular)
    $form.Controls.Add($textBox2)


    $label3 = New-Object System.Windows.Forms.Label
    $label3.Location = New-Object System.Drawing.Point(30,120)
    $label3.Size = New-Object System.Drawing.Size(400,20)
    $label3.Text = 'Please enter the VPN Secret:'
    $form.Controls.Add($label3)

    $textBox3 = New-Object System.Windows.Forms.TextBox
    $textBox3.Location = New-Object System.Drawing.Point(30,140)
    $textBox3.Size = New-Object System.Drawing.Size(360,20)
    $textBox3.Font = New-Object System.Drawing.Font("Lucida Console",12,[System.Drawing.FontStyle]::Regular)
    $form.Controls.Add($textBox3)


    # create your checkbox 
    $checkbox1 = new-object System.Windows.Forms.checkbox
    $checkbox1.Location = new-object System.Drawing.Size(30,160)
    $checkbox1.Size = new-object System.Drawing.Size(250,50)
    $checkbox1.Text = "Confirm VPN Details"
    $checkbox1.Checked = $false
    $Form.Controls.Add($checkbox1)  
 
    # Add an OK button
    $PapButton = new-object System.Windows.Forms.Button
    $PapButton.Location = new-object System.Drawing.Size(20,220)
    $PapButton.Size = new-object System.Drawing.Size(100,40)
    $PapButton.Text = "CHAP2"
    $PapButton.Add_Click({add-VpnConnection -AllUserConnection -RememberCredential -Name ($textBox1.Text) -ServerAddress ($textBox2.Text) -TunnelType L2tp -EncryptionLevel Optional -L2tpPsk ($textBox3.Text) -AuthenticationMethod MSChapv2 -Force})
    $PapButton.Enabled = $false
    $form.Controls.Add($PapButton)

    # Add an OK button
    $ChapButton = new-object System.Windows.Forms.Button
    $ChapButton.Location = new-object System.Drawing.Size(130,220)
    $ChapButton.Size = new-object System.Drawing.Size(100,40)
    $ChapButton.Text = "PAP"
    $ChapButton.Add_Click({add-VpnConnection -AllUserConnection -RememberCredential -Name ($textBox1.Text) -ServerAddress ($textBox2.Text) -TunnelType L2tp -EncryptionLevel Optional -L2tpPsk ($textBox3.Text) -AuthenticationMethod Pap -Force})
    $ChapButton.Enabled = $false
    $form.Controls.Add($ChapButton)

    #Add a cancel button
    $RMVButton = new-object System.Windows.Forms.Button
    $RMVButton.Location = new-object System.Drawing.Size(240,220)
    $RMVButton.Size = new-object System.Drawing.Size(120,40)
    $RMVButton.Text = "RMV VPN"
    $RMVButton.Add_Click({(Get-VpnConnection -AllUserConnection | Remove-VpnConnection -Force)})
    $form.Controls.Add($RMVButton)
 
    #Add a cancel button
    $CancelButton = new-object System.Windows.Forms.Button
    $CancelButton.Location = new-object System.Drawing.Size(370,220)
    $CancelButton.Size = new-object System.Drawing.Size(100,40)
    $CancelButton.Text = "Close"
    $CancelButton.Add_Click({$Form.Close()})
    $form.Controls.Add($CancelButton)


    
    ###########  This is the important piece ##############
    #                                                     #
    # Do something when the state of the checkbox changes #
    #######################################################
    $checkbox1.Add_CheckStateChanged({$ChapButton.Enabled = $checkbox1.Checked
                                      $PapButton.Enabled = $checkbox1.Checked  })
 
    
    # Activate the form
    $Form.Add_Shown({$Form.Activate()})
    [void] $Form.ShowDialog() 
}
 
#Call the function
checkbox_test