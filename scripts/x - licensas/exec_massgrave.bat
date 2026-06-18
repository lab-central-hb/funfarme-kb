@echo off
set "scriptPath=%~dp0massgrave.ps1"
powershell -ExecutionPolicy Bypass -NoProfile -File "%scriptPath%"
exit