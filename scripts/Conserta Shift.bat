@echo off

taskkill /F /IM shiftapp.exe
taskkill /F /IM javaw.exe

cd /d "C:\Program Files (x86)\ShiftApp"

start "" "ShiftApp.exe"

exit