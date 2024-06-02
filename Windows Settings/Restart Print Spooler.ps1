Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

get-service *spool* | restart-service

[System.Windows.MessageBox]::Show("Print Spooler Restarted","Spooler",0,0)