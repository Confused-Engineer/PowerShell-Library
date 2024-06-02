Set-TimeZone -Id "Eastern Standard Time"
Start-Process "w32tm.exe" -ArgumentList @("/unregister") -Wait -NoNewWindow
Start-Process "w32tm.exe" -ArgumentList @("/register") -Wait -NoNewWindow
Start-Service W32Time

Start-Process "w32tm.exe" -ArgumentList @("/resync") -Wait -NoNewWindow
Stop-Service W32Time