taskkill /f /im las-update-installer-2.0.1.exe
taskkill /f /im las-update-installer-2.1.6.exe
taskkill /f /im las-update-installer-2.2.6.exe
del /q/f/s %temp%\*
del /q/f/s C:\Windows\Temp\*
del /q/f/s C:\Windows\Prefetch
pause


