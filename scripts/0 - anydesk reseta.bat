@echo off
title reseta anydesk
echo parando servicos do anydesk...
taskkill /f /im AnyDesk.exe >nul 2>&1
net stop AnyDesk >nul 2>&1

echo deletando configuracoes do usuario...
rmdir /s /q "%APPDATA%\AnyDesk" >nul 2>&1
rmdir /s /q "%PROGRAMDATA%\AnyDesk" >nul 2>&1

echo reiniciando servicos do anydesk....
net start AnyDesk >nul 2>&1
start "" "%PROGRAMFILES(x86)%\AnyDesk\AnyDesk.exe"

echo || reset completo com sucesso ||
pause