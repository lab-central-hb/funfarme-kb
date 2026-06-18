@echo off
@setlocal enableextensions enabledelayedexpansion

echo               [92m########################################### [0m
echo               [92m#    Instalando \ Atualizando Navegador   # [0m 
echo               [92m#           Aguarde por Favor             # [0m
echo               [92m########################################### [0m
echo.

@echo ########## Matando as sessoes do navegador ##########

taskkill /IM chrome.exe /F
taskkill /IM chrome-custom.exe /F
taskkill /IM chrome.exe /F
taskkill /IM chrome_cent.exe /F
taskkill /IM chrome-custom.exe /F
taskkill /IM GoogleChromePortable.exe /F

taskkill /IM las-update-installer-2.2.6.exe /F
taskkill /IM las-printer-installer-2.1.6.exe /F
taskkill /IM las-bematech-installer-2.0.4-install.exe  /F

rem Remove o LAS e Arquivos Temporarios
@echo ########## Removendo Aplicativos MV LAS ##########
%LOCALAPPDATA%\mv\las\las-update-installer-2.2.6\las-update-installer-2.2.6-uninstall.exe -q
%LOCALAPPDATA%\mv\las\las-printer-installer-2.1.6\las-printer-installer-2.1.6-uninstall.exe -q
%LOCALAPPDATA%\mv\las\las-printer-installer-2.1.3\las-printer-installer-2.1.3-uninstall.exe -q

%LOCALAPPDATA%\mv\las\las-update-installer-2.0.1\las-update-installer-2.0.1-uninstall.exe -q
%LOCALAPPDATA%\mv\las\las-printer-installer-2.0.1\las-printer-installer-2.0.1-uninstall.exe -q
%LOCALAPPDATA%\mv\las\las-mv2000-installer-2.0.1\las-mv2000-installer-2.0.1-uninstall.exe -q
%LOCALAPPDATA%\mv\las\las-bematech-installer-2.0.4\las-bematech-installer-2.0.4-uninstall.exe -q
%LOCALAPPDATA%\mv\las\las-bematech-installer-2.0.1\las-bematech-installer-2.0.1-uninstall.exe -q

"C:\Program Files (x86)\mv\las\las-update-installer-2.2.6\las-update-installer-2.2.6-uninstall.exe" -q
"C:\Program Files (x86)\mv\las\las-update-installer-2.0.1\las-update-installer-2.0.1-uninstall.exe" -q
"C:\Program Files (x86)\mv\las\las-printer-installer-2.1.6\las-printer-installer-2.1.6-uninstall.exe" -q
"C:\Program Files (x86)\mv\las\las-printer-installer-2.1.3\las-printer-installer-2.1.3-uninstall.exe" -q
"C:\Program Files (x86)\mv\las\las-printer-installer-2.0.1\las-printer-installer-2.0.1-uninstall.exe" -q
"C:\Program Files (x86)\mv\las\las-mv2000-installer-2.0.1\las-mv2000-installer-2.0.1-uninstall.exe" -q
"C:\Program Files (x86)\mv\las\las-bematech-installer-2.0.4\las-bematech-installer-2.0.4-uninstall.exe" -q
"C:\Program Files (x86)\mv\las\las-bematech-installer-2.0.1\las-bematech-installer-2.0.1-uninstall.exe" -q

echo ########## Removendo Arquivos Temporarios ##########
rmdir %LOCALAPPDATA%\mv\las
rmdir  /S /Q "%LOCALAPPDATA%\mv\las"

del /q/f/s %temp%
rem del /q/f/s "c:\trabalho\navegador"
rmdir  /S /Q "c:\trabalho\navegador"
del /q/f/s %LOCALAPPDATA%\mv\las\logs
del /q/f/s %LOCALAPPDATA%\mv\las\temp
del /q/f/s "%ProgramFiles(x86)%\mv\las\logs"
del /q/f/s "%ProgramFiles(x86)%\mv\las\temp"

cls
echo               [92m########################################### [0m
echo               [92m#    Instalando \ Atualizando Navegador   # [0m 
echo               [92m#           Aguarde por Favor             # [0m
echo               [92m########################################### [0m
echo.

 echo ########## Sessoes de Navegador Removidas ##########
 echo ########## Arquivos Temporarios Removidos ##########
 echo ########## Aplicativos LAS Removido ##########
 
set "_product=SoulMV"
echo ########## Verificando e removendo instalacao do %_product% ##########
IF EXIST "%ProgramFiles%\MV\SoulMV" (			
			MsiExec.exe /X{DCB699F2-2E5B-4A51-B59E-A5DF84C308DE} /qb
			echo            %_product% #removido
		 ) ELSE (			
				echo            %_product% OK
			 )


set "_product=CentBrowser"
echo ########## Verificando e removendo instalacao do %_product% ##########
IF EXIST "%ProgramFiles(x86)%\CentBrowser\Application\5.0.1002.295\Installer\setup.exe" (			
			"%ProgramFiles(x86)%\CentBrowser\Application\5.0.1002.295\Installer\setup.exe" --uninstall --system-level --cb-auto-update"C:\Program Files (x86)\CentBrowser\Application\5.0.1002.295\Installer\setup.exe" --uninstall --system-level --cb-auto-update
			echo             %_product% #removido
		 ) ELSE (
			IF EXIST "%LOCALAPPDATA%\CentBrowser\Application\5.0.1002.295\Installer\setup.exe" (			 
			    "%LOCALAPPDATA%\CentBrowser\Application\5.0.1002.295\Installer\setup.exe" --uninstall --cb-auto-update --do-not-launch-chrome --force-uninstall
				echo            %_product% ##removido
			 ) ELSE (
				echo            %_product% OK
			 )
		 )


set "_product=HBService"
echo ########## Verificando %_product% ##########
@setlocal enableextensions enabledelayedexpansion
IF EXIST "C:\Trabalho\app_hb\HBService\hbService.exe" (	
 
  set _tag=hbServiceVersion
  set _version=0
  set _minversion=311
 
  
  for /f "tokens=1,2 delims=:" %%a in (
			  'powershell.exe -command "& Invoke-RestMethod -Uri \"http://127.0.0.1:9071/info\" -Method Get -Header @{ }"'
			) do (
				setlocal
				 set chave=%%a				 
				 rem remove os espaços em branco
				 call set chave=%%chave: =%%
				 rem remove a tabulacao
				 call set chave=%%chave:	=%%
		    		
				  if !chave! == !_tag!  ( 
					set _version=%%b
				  )
			 )

             set _version=!_version: =!
			 rem remove o ponto existente na versao
			 set _version=!_version:.=!
			  rem remove os espaços em branco
			 set _version=!_version: =!
			 set _minversion=!_minversion: =!
			 rem remove a tabulacao
			 set _version=!_version:	=!
  			
			if [!_version!] == [!_minversion!]  ( 
				echo            Versao do %_product% esta atualizada
			 ) ELSE (
			 	echo            Versao do %_product% esta desatualizada
				echo            Instalando %_product%
                \\172.17.0.56\mv2000\ti\Navegador\HBServiceSetup.exe /VERYSILENT
				echo            %_product% OK
			 )
) ELSE (
	echo  %_product% NAO INSTALADO
	echo            Instalando %_product%
    \\172.17.0.56\mv2000\ti\Navegador\HBServiceSetup.exe /VERYSILENT
	echo            %_product% OK
)

endlocal

set "_product=Navegador_HBMV"
echo ########## Instalando %_product% ##########
\\172.17.0.56\mv2000\ti\Navegador\Cent.exe
echo            %_product% OK


set "_product=Flash"
echo ########## Verificando instalacao do %_product% ##########
IF EXIST "%windir%\SysWOW64\Macromed\Flash" (

			IF EXIST "%windir%\SysWOW64\Macromed\Flash\FlashUtil32_32_0_0_363_pepper.exe" (
                echo            %_product% esta na versao correta
			) ELSE (						
					 IF EXIST "%windir%\SysWOW64\Macromed\Flash\manifest.json" (
						echo            Removendo instalacao do %_product%
						\\172.17.0.56\mv2000\ti\Navegador\uninstall_flash_player.exe -uninstall
						echo            Instalando %_product%
						c:\trabalho\Navegador\ppapi_32.0.0.363.exe -install
					  ) ELSE (
						echo            Instalando %_product%
						c:\trabalho\Navegador\ppapi_32.0.0.363.exe -install
					   )
			       )			
		 ) ELSE (		
		 IF EXIST "%windir%\System32\Macromed\Flash\FlashUtil32_32_0_0_363_pepper.exe" (
            echo            Flash esta na versão correta			
		 ) 
		 ELSE (
				IF EXIST "%windir%\System32\Macromed\Flash\manifest.json" (
						echo            Removendo instalacao do %_product%
						\\172.17.0.56\mv2000\ti\Navegador\uninstall_flash_player.exe -uninstall
						echo            Instalando %_product%
						c:\trabalho\Navegador\ppapi_32.0.0.363.exe -install
					  ) ELSE (
						echo            Instalando %_product%
						c:\trabalho\Navegador\ppapi_32.0.0.363.exe -install
					   )
		 )
     )


echo ########## Aplicando Registros ##########
AT > nul
ver > nul
echo. > nul

CD C:\Trabalho\Navegador
Reg import chaves.reg
IF %ERRORLEVEL% NEQ 0 (
    echo            [101;93m #$#$#$# INSTALACAO SENDO EXECUTADA SEM PERMISSAO DE ADMINISTRADOR #$#$#$# [0m
	echo            [101;93m #$#$#$# APLICAR OS REGISTROS MANUALMENTE "C:\Trabalho\Navegador\chaves.reg" #$#$#$# [0m 	
)
AT > nul
ver > nul
echo. > nul

set "_product=MV_LAS"
echo ########## Instalando %_product% ##########
\\172.17.0.56\mv2000\ti\Navegador\las-update-installer-2.2.6-full.exe -q
echo            %_product% OK
	
AT > nul
ver > nul
echo. > nul

echo ########## Copiando Atalhos ##########
xcopy "c:\Trabalho\Navegador\Soul MV.lnk" "C:\Documents and Settings\All Users\Desktop" /i /y
xcopy "c:\Trabalho\Navegador\Soul MV.lnk" "C:\Users\Public\Desktop" /i /y

IF %ERRORLEVEL% NEQ 0 (
    echo            [101;93m #$#$#$# INSTALACAO SENDO EXECUTADA SEM PERMISSAO DE ADMINISTRADOR #$#$#$# [0m
	echo            [101;93m #$#$#$# COPIAR ATALHO MANUALMENTE "c:\Trabalho\Navegador\Soul MV.lnk" #$#$#$# [0m 	
)

echo.
echo.
echo.

echo               [32m########################################### [0m
echo               [32m########################################### [0m
echo               [32m            Instalacao Finalizada           [0m 
echo               [32m########################################### [0m
echo               [32m########################################### [0m

timeout 5

exit