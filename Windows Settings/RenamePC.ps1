Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

function checkbox_test{




    
    # Set the size of your form
    $Form = New-Object System.Windows.Forms.Form
    $Form.width = 450
    $Form.height = 200
    $Form.Text = ”Rename PC”
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
    $label1.Text = 'Please enter the new PC name:'
    $form.Controls.Add($label1)

    $textBox1 = New-Object System.Windows.Forms.TextBox
    $textBox1.Location = New-Object System.Drawing.Point(30,40)
    $textBox1.Size = New-Object System.Drawing.Size(360,20)
    $textBox1.Font = New-Object System.Drawing.Font("Lucida Console",12,[System.Drawing.FontStyle]::Regular)
    $form.Controls.Add($textBox1)


    


    # create your checkbox 
    $checkbox1 = new-object System.Windows.Forms.checkbox
    $checkbox1.Location = new-object System.Drawing.Size(30,50)
    $checkbox1.Size = new-object System.Drawing.Size(250,50)
    $checkbox1.Text = "Confirm Name"
    $checkbox1.Checked = $false
    $Form.Controls.Add($checkbox1)  
 
    # Add an OK button
    $OKButton = new-object System.Windows.Forms.Button
    $OKButton.Location = new-object System.Drawing.Size(100,100)
    $OKButton.Size = new-object System.Drawing.Size(100,40)
    $OKButton.Text = "OK"
    $OKButton.Add_Click({Rename-Computer -NewName ($textBox1.Text)})
    $OKButton.Enabled = $false
    $form.Controls.Add($OKButton)

 
    #Add a cancel button
    $CancelButton = new-object System.Windows.Forms.Button
    $CancelButton.Location = new-object System.Drawing.Size(220,100)
    $CancelButton.Size = new-object System.Drawing.Size(100,40)
    $CancelButton.Text = "Close"
    $CancelButton.Add_Click({$Form.Close()})
    $form.Controls.Add($CancelButton)


    
    ###########  This is the important piece ##############
    #                                                     #
    # Do something when the state of the checkbox changes #
    #######################################################
    $checkbox1.Add_CheckStateChanged({$OKButton.Enabled = $checkbox1.Checked })
 
    
    # Activate the form
    $Form.Add_Shown({$Form.Activate()})
    [void] $Form.ShowDialog() 
}
 
#Call the function
checkbox_test