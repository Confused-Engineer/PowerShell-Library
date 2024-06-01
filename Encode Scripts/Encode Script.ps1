$PS1Script = Read-Host -Prompt "Powershell Script Path"
$Base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes([System.IO.File]::ReadAllText($PS1Script.Replace('"',""))))
$Base64 | Out-File -FilePath "bytes.txt"