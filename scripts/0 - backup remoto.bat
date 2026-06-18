@echo off
setlocal
echo !!! PARA COLETAR IMPRESSORAS E PONTOS MAPEADOS, EXECUTAR LOCALMENTE !!!
echo !!! O SCRIPT "0 - faz backup.bar" !!!

echo Digite o nome de usuario para fazer backup:
set /p USERNAME="Usuario: "
set /p NTI="NTI: "

set "ACTIVE_PROFILE=\\nti-%NTI%\c$\Users\%USERNAME%"
set "DEST=\\nti-102856\d$\backups\%USERNAME%"

echo.
echo Criando backup para o usuario: %USERNAME%
echo Perfil ativo: %ACTIVE_PROFILE%
echo Destino: %DEST%
echo.

mkdir %DEST% 2>nul

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