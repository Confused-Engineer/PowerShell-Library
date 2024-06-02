Takeown /f $env:windir\winsxs\temp\PendingRenames /a
icacls $env:windir\winsxs\temp\PendingRenames /grant "NT AUTHORITY\SYSTEM:(RX)"
icacls $env:windir\winsxs\temp\PendingRenames /grant "NT Service\trustedinstaller:(F)"
icacls $env:windir\winsxs\temp\PendingRenames /grant "BUILTIN\Users:(RX)"

Takeown /f $env:windir\winsxs\filemaps\* /a
icacls $env:windir\winsxs\filemaps\*.* /grant "NT AUTHORITY\SYSTEM:(RX)"
icacls $env:windir\winsxs\filemaps\*.* /grant "NT Service\trustedinstaller:(F)"
icacls $env:windir\winsxs\filemaps\*.* /grant "BUILTIN\Users:(RX)"

Get-Service *crypt* | Restart-Service -Force
Get-Service *Winmgmt* | Restart-Service -Force
Get-Service -DisplayName "Volume Shadow Copy" | Restart-Service -Force
Get-Service *back* | Restart-Service -Force