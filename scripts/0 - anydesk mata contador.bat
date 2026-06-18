@echo off
echo fechando sessao do anydesk...
taskkill /f /im AnyDesk.exe >nul 2>&1

if not exist "%APPDATA%\AnyDesk\old" mkdir "%APPDATA%\AnyDesk\old"
if not exist "%PROGRAMDATA%\AnyDesk\old" mkdir "%PROGRAMDATA%\AnyDesk\old"

move "%APPDATA%\AnyDesk\*.*" "%APPDATA%\AnyDesk\old\" >nul 2>&1
move "%PROGRAMDATA%\AnyDesk\*.*" "%PROGRAMDATA%\AnyDesk\old\" >nul 2>&1

echo || contador resetado com sucesso ||
pause