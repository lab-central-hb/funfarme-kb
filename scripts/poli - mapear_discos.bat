@echo off
setlocal enabledelayedexpansion

echo ##############################################################################
echo #                                                                            #
echo # para configurar um novo mapeamento, abra o codigo e copie a linha abaixo   #
echo # call :mapear_drive LETRA "\\aquisicaoX\sala X mX"                          #
echo # trocando LETRA e X pela letra e numeros necessarios                        #
echo # e cole junto com as outras chamadas de funcoes                             #
echo # que comecam na linha 48 do codigo                                          #
echo #                                                                            #
echo ##############################################################################

echo Tentando deletar todas as letras ligadas aos discos...
call :remove_drives

echo.
echo Mapeando todos os discos...
call :executa_mapeamentos

echo.
echo Processo concluido!
pause
exit /b

:remove_drives
set /a sucessos=0
set /a falhas=0

for %%d in (a b f g h i j k l m n o p q s t u v w x y z) do (
    net use %%d: /d /y >nul 2>&1
    if !errorlevel! equ 0 (
        echo [OK] Drive %%d: desmapeado com sucesso
        set /a sucessos+=1
    ) else (
        echo [INFO] Drive %%d: nao estava mapeado ou ja foi removido
    )
)

echo.
echo Resumo: Drives desmapeados ou ja estavam livres
exit /b

:executa_mapeamentos
set /a sucessos=0
set /a falhas=0

call :mapear_drive A "\\aquisicao1\sala 1 m1"
call :mapear_drive B "\\aquisicao1\sala 1 m1 2"
call :mapear_drive F "\\aquisicao2\sala 2 m2 9"
call :mapear_drive G "\\aquisicao2\sala 2 m2 10"
call :mapear_drive H "\\aquisicao3\sala 3 m3 5"
call :mapear_drive I "\\aquisicao3\sala 3 m3 6"
call :mapear_drive J "\\aquisicao4\sala 4 m4 3"
call :mapear_drive K "\\aquisicao4\sala 4 m4 4"
call :mapear_drive L "\\aquisicao5\sala 5 m5"
call :mapear_drive M "\\aquisicao5\sala 5 m5 2"
call :mapear_drive N "\\aquisicao6\sala 6 m6"
call :mapear_drive O "\\aquisicao6\sala 6 m6 2"
:: call :mapear_drive LETRA "\\aquisicaoX\salaX mX"

echo.
echo Resumo: !sucessos! drives mapeados com sucesso, !falhas! falhas
exit /b

:mapear_drive
set "drive_letra=%~1"
set "drive_caminho=%~2"
echo Mapeando drive %drive_letra%:...
net use %drive_letra%: "%drive_caminho%" >nul 2>&1
if !errorlevel! equ 0 (
    echo [OK] Drive %drive_letra%: mapeado com sucesso
    set /a sucessos+=1
) else (
    echo [ERRO] Falha ao mapear drive %drive_letra%:, conferir com recepcao se %drive_caminho% esta conectado corretamente
    echo -
    set /a falhas+=1
)
exit /b
