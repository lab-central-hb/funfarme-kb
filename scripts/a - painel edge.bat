@echo off

timeout /t 3 >nul

start "" "msedge.exe" "http://srv-mv.hbase.local/mvpainel/"

timeout /t 3 >nul

powershell -Command ^
$wshell = New-Object -ComObject WScript.Shell; ^
Start-Sleep -Milliseconds 500; ^
$wshell.SendKeys('{LEFT}'); ^
Start-Sleep -Milliseconds 300; ^
$wshell.SendKeys('{ENTER}')

exit