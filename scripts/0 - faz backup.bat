@echo off
setlocal

echo Digite o nome de usuario para fazer backup:
set /p ACTIVE_USERNAME="Usuario: "

set "ACTIVE_PROFILE=C:\Users\%ACTIVE_USERNAME%"
set "DEST=\\nti-102856\d$\backups\%ACTIVE_USERNAME%"

echo.
echo Criando backup para o usuario: %ACTIVE_USERNAME%
echo Perfil ativo: %ACTIVE_PROFILE%
echo Destino: %DEST%
echo.

mkdir %DEST% 2>nul

echo Coletando impressoras e unidades mapeadas...
powershell -ExecutionPolicy Bypass -NoProfile -File "\\nti-102856\d$\santana\funfarme-kb\scripts\x - coleta info pc\info_backup.ps1" -DestFolder %DEST%

echo Copiando Area de Trabalho...
robocopy "%ACTIVE_PROFILE%\Desktop" %DEST%\Desktop /E

echo Copiando Documentos...
robocopy "%ACTIVE_PROFILE%\Documents" %DEST%\Documents /E

echo Copiando Imagens...
robocopy "%ACTIVE_PROFILE%\Pictures" %DEST%\Pictures /E

echo Copiando Downloads...
robocopy "%ACTIVE_PROFILE%\Downloads" %DEST%\Downloads /E

echo.
echo Backup concluido com sucesso!
pause