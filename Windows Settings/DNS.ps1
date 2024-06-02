Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

function checkbox_test{




    
    # Set the size of your form
    $Form = New-Object System.Windows.Forms.Form
    $Form.width = 500
    $Form.height = 270
    $Form.Text = ”Set DNS Settings”
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
    $label1.Text = 'Please enter the Primary Address:'
    $form.Controls.Add($label1)

    $textBox1 = New-Object System.Windows.Forms.TextBox
    $textBox1.Location = New-Object System.Drawing.Point(30,40)
    $textBox1.Size = New-Object System.Drawing.Size(360,20)
    $textBox1.Font = New-Object System.Drawing.Font("Lucida Console",12,[System.Drawing.FontStyle]::Regular)
    $form.Controls.Add($textBox1)


    $label2 = New-Object System.Windows.Forms.Label
    $label2.Location = New-Object System.Drawing.Point(30,70)
    $label2.Size = New-Object System.Drawing.Size(400,20)
    $label2.Text = 'Please enter the Secondary Address:'
    $form.Controls.Add($label2)


    $textBox2 = New-Object System.Windows.Forms.TextBox
    $textBox2.Location = New-Object System.Drawing.Point(30,90)
    $textBox2.Size = New-Object System.Drawing.Size(360,20)
    $textBox2.Font = New-Object System.Drawing.Font("Lucida Console",12,[System.Drawing.FontStyle]::Regular)
    $form.Controls.Add($textBox2)


    # create your checkbox 
    $checkbox1 = new-object System.Windows.Forms.checkbox
    $checkbox1.Location = new-object System.Drawing.Size(30,110)
    $checkbox1.Size = new-object System.Drawing.Size(250,50)
    $checkbox1.Text = "Confirm DNS Details"
    $checkbox1.Checked = $false
    $Form.Controls.Add($checkbox1)  
 
    # Add an OK button
    $PapButton = new-object System.Windows.Forms.Button
    $PapButton.Location = new-object System.Drawing.Size(20,160)
    $PapButton.Size = new-object System.Drawing.Size(100,40)
    $PapButton.Text = "Ethernet"
    $PapButton.Add_Click({Set-DnsClientServerAddress "Ethernet" -ServerAddresses ($textBox1.Text,$textBox2.Text)})
    $PapButton.Enabled = $false
    $form.Controls.Add($PapButton)

    # Add an OK button
    $ChapButton = new-object System.Windows.Forms.Button
    $ChapButton.Location = new-object System.Drawing.Size(130,160)
    $ChapButton.Size = new-object System.Drawing.Size(100,40)
    $ChapButton.Text = "Wi-Fi"
    $ChapButton.Add_Click({Set-DnsClientServerAddress "Wi-Fi" -ServerAddresses ($textBox1.Text,$textBox2.Text)})
    $ChapButton.Enabled = $false
    $form.Controls.Add($ChapButton)

    #Add a cancel button
    $RMVButton = new-object System.Windows.Forms.Button
    $RMVButton.Location = new-object System.Drawing.Size(240,160)
    $RMVButton.Size = new-object System.Drawing.Size(120,40)
    $RMVButton.Text = "RST DNS"
    $RMVButton.Add_Click({(Set-DnsClientServerAddress "*" -ResetServerAddresses)})
    $form.Controls.Add($RMVButton)
 
    #Add a cancel button
    $CancelButton = new-object System.Windows.Forms.Button
    $CancelButton.Location = new-object System.Drawing.Size(370,160)
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