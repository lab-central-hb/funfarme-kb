@echo off

NET SESSION >nul 2>&1
if %errorlevel% neq 0 (
    echo Solicitando privilégios de administrador...
    goto UACPrompt
) else (
    goto :continuar
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:continuar

rmdir /s /q C:\orant\

MD C:\orant
MD C:\orant\bin
xcopy "\\172.17.0.56\mv2000\NTI-Suporte\orant" "C:\orant\bin" /C /Y /I
echo %PATH% | find /I "C:\orant\bin" > nul

setx ORACLE_HOME "C:\orant\bin" /M
setx TNS_ADMIN "C:\orant\bin" /M
setx NLS_CHARACTER "WE8ISO8859P1" /M
setx NLS_LANG "AMERICAN_AMERICA.WE8ISO8859P1" /M

timeout /t 1 >nul

xcopy "\\172.17.0.56\mv2000\NTI-Suporte\Atualizar HBis\hosts" "C:\Windows\System32\drivers\etc" /C /Y /I

timeout /t 1 >nul

echo ########## Aplicando Registros ##########

"\\172.17.0.56\mv2000\NTI-Suporte\Atualizar HBis\Path.reg"
"\\172.17.0.56\mv2000\NTI-Suporte\Atualizar HBis\oracle_home.reg"
"\\172.17.0.56\mv2000\NTI-Suporte\Atualizar HBis\tns_admin.reg"
"\\172.17.0.56\mv2000\NTI-Suporte\Atualizar HBis\nls_character.reg"
"\\172.17.0.56\mv2000\NTI-Suporte\Atualizar HBis\nls_lang.reg"

pause