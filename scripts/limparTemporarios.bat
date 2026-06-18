::
:: Atualizado em: 05/12/16 por Anderson Freitas
::
:: Script de limpeza de arquivos temporários em TODOS usuários do Windows.
::
:: Itens removidos:
::
:: Cookies - Local Settings Temp - AppData Temp - AppData Internet Temp - MS Edge
:: Windows Error Report (WER) Logs - C: Temp, Windows Temp - Firefox Temp (perfil todo) - Chrome Temp (pasta Cache) - Opera (pasta cache - Vivaldi (pasta Cache)
::
::
:: Contato: contato@tigos.com.br
::

@ECHO OFF

:START
cls
%homedrive%
cd %USERPROFILE%
cd..
set profiles=%cd%

for /f "tokens=* delims= " %%u in ('dir /b/ad') do (

cls
title Deletando %%u COOKIES. . .
if exist "%profiles%\%%u\cookies" echo Deletando....
if exist "%profiles%\%%u\cookies" cd "%profiles%\%%u\cookies"
if exist "%profiles%\%%u\cookies" del *.* /F /S /Q /A: R /A: H /A: A

cls
title Deletando %%u Temp Files. . .
if exist "%profiles%\%%u\Local Settings\Temp" echo Deletando....
if exist "%profiles%\%%u\Local Settings\Temp" cd "%profiles%\%%u\Local Settings\Temp"
if exist "%profiles%\%%u\Local Settings\Temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\Local Settings\Temp" rmdir /s /q "%profiles%\%%u\Local Settings\Temp"

cls
title Deletando %%u Temp Files. . .
if exist "%profiles%\%%u\AppData\Local\Temp" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Temp" cd "%profiles%\%%u\AppData\Local\Temp"
if exist "%profiles%\%%u\AppData\Local\Temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Temp" rmdir /s /q "%profiles%\%%u\AppData\Local\Temp"

cls
title Deletando %%u Temporary Internet Files. . .
if exist "%profiles%\%%u\Local Settings\Temporary Internet Files" echo Deletando....
if exist "%profiles%\%%u\Local Settings\Temporary Internet Files" cd "%profiles%\%%u\Local Settings\Temporary Internet Files"
if exist "%profiles%\%%u\Local Settings\Temporary Internet Files" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\Local Settings\Temporary Internet Files" rmdir /s /q "%profiles%\%%u\Local Settings\Temporary Internet Files"

cls
title Deletando %%u Temporary Internet Files. . .
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files" cd "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files"
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files" rmdir /s /q "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files"

cls
title Deletando %%u WER Files. . .
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\WER\ReportArchive" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\WER\ReportArchive" cd "%profiles%\%%u\AppData\Local\Microsoft\Windows\WER\ReportArchive"
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\WER\ReportArchive" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\WER\ReportArchive" rmdir /s /q "%profiles%\%%u\AppData\Local\Microsoft\Windows\WER\ReportArchive"


cls
title Deletando %Systemroot%\Temp
if exist "%Systemroot%\Temp" echo Deletando....
if exist "%Systemroot%\Temp" cd "%Systemroot%\Temp"
if exist "%Systemroot%\Temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%Systemroot%\Temp" rmdir /s /q "%Systemroot%\Temp"

cls
title Deletando %SYSTEMDRIVE%\Temp
if exist "%SYSTEMDRIVE%\Temp" echo Deletando....
if exist "%SYSTEMDRIVE%\Temp" cd "%SYSTEMDRIVE%\Temp"
if exist "%SYSTEMDRIVE%\Temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%SYSTEMDRIVE%\Temp" rmdir /s /q "%Systemroot%\Temp"

cls
title Deletando %%u FIREFOX TEMP. . .
if exist "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles" cd "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles"
if exist "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles" rmdir /s /q "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles"

cls
title Deletando %%u CHROME TEMP. . .
if exist "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache" cd "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache"
if exist "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache" rmdir /s /q "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache"

cls
title Deletando %%u EDGE TEMP. . .
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache" cd "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache"
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache" rmdir /s /q "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache"

cls
title Deletando %%u EDGE COOKIES. . .
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies" cd "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies"
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies" rmdir /s /q "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies"

cls
title Deletando %%u RDP TEMP. . .
if exist "%profiles%\%%u\AppData\Local\Microsoft\Terminal Server Client\Cache" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Microsoft\Terminal Server Client\Cache" cd "%profiles%\%%u\AppData\Local\Microsoft\Terminal Server Client\Cache"
if exist "%profiles%\%%u\AppData\Local\Microsoft\Terminal Server Client\Cache" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Microsoft\Terminal Server Client\Cache" rmdir /s /q "%profiles%\%%u\AppData\Local\Microsoft\Terminal Server Client\Cache"

cls
title Deletando %%u OPERA TEMP. . .
if exist "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Cache" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Cache" cd "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Cache"
if exist "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Caches" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Cache" rmdir /s /q "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Cache"


cls
title Deletando %%u VIVALDI TEMP. . .
if exist "%profiles%\%%u\AppData\Local\Vivaldi\User Data\Default\Cache" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Vivaldi\User Data\Default\Cache" cd "%profiles%\%%u\AppData\Local\Vivaldi\User Data\Default\Cache"
if exist "%profiles%\%%u\AppData\Local\Vivaldi\User Data\Default\Cache" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Vivaldi\User Data\Default\Cache" rmdir /s /q "%profiles%\%%u\AppData\Local\Vivaldi\User Data\Default\Cache"


cls
title Deletando %%u LAS Temp Files. . .
if exist "%profiles%\%%u\AppData\Local\mv\las\logs" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\mv\las\logs" cd "%profiles%\%%u\AppData\Local\mv\las\logs"
if exist "%profiles%\%%u\AppData\Local\mv\las\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\mv\las\logs" rmdir /s /q "%profiles%\%%u\AppData\Local\mv\las\logs"

if exist "%profiles%\%%u\AppData\Local\mv\las\temp" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\mv\las\temp" cd "%profiles%\%%u\AppData\Local\mv\las\temp"
if exist "%profiles%\%%u\AppData\Local\mv\las\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\mv\las\temp" rmdir /s /q "%profiles%\%%u\AppData\Local\mv\las\temp"


cls
title Deletando %%u apache-httpd LOG and TEMP Files. . .
if exist "C:\MV\soulmv_prd\serves\apache-httpd\logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\apache-httpd\logs" cd "C:\MV\soulmv_prd\serves\apache-httpd\logs"
if exist "C:\MV\soulmv_prd\serves\apache-httpd\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\apache-httpd\logs" rmdir /s /q "C:\MV\soulmv_prd\serves\apache-httpd\logs"

cls
title Deletando %%u apache-httpd LOG and TEMP Files. . .
if exist "C:\MV\soulmv_prd\serves\ApacheMVReport\logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\ApacheMVReport\logs" cd "C:\MV\soulmv_prd\serves\ApacheMVReport\logs"
if exist "C:\MV\soulmv_prd\serves\ApacheMVReport\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\ApacheMVReport\logs" rmdir /s /q "C:\MV\soulmv_prd\serves\ApacheMVReport\logs"

cls
title Deletando %%u LaudosWeb LOG and TEMP Files. . .
if exist "C:\MV\soulmv_prd\serves\apache-tomcat-7.0.47-LaudosWeb\logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\apache-tomcat-7.0.47-LaudosWeb\logs" cd "C:\MV\soulmv_prd\serves\apache-tomcat-7.0.47-LaudosWeb\logs"
if exist "C:\MV\soulmv_prd\serves\apache-tomcat-7.0.47-LaudosWeb\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\apache-tomcat-7.0.47-LaudosWeb\logs" rmdir /s /q "C:\MV\soulmv_prd\serves\apache-tomcat-7.0.47-LaudosWeb\logs"

if exist "C:\MV\soulmv_prd\serves\apache-tomcat-7.0.47-LaudosWeb\temp" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\apache-tomcat-7.0.47-LaudosWeb\temp" cd "C:\MV\soulmv_prd\serves\apache-tomcat-7.0.47-LaudosWeb\temp"
if exist "C:\MV\soulmv_prd\serves\apache-tomcat-7.0.47-LaudosWeb\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\apache-tomcat-7.0.47-LaudosWeb\temp" rmdir /s /q "C:\MV\soulmv_prd\serves\apache-tomcat-7.0.47-LaudosWeb\temp"

cls
title Deletando %%u tomcat-7.0.52-x64_8040 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\logs" cd "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\logs"
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\logs" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\logs"

if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\temp" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\temp" cd "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\temp"
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\temp" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\temp"

if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\mv-logs" cd "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\mv-logs"
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\mv-logs" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8040\mv-logs"

cls
title Deletando %%u tomcat-7.0.52-x64_8060 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\logs" cd "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\logs"
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\logs" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\logs"

if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\temp" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\temp" cd "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\temp"
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\temp" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\temp"

if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\mv-logs" cd "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\mv-logs"
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\mv-logs" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-7.0.52-x64_8060\mv-logs"


cls
title Deletando %%u tomcat-mvautenticador-cas-8500 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\logs" cd "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\logs"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\logs" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\logs"

if exist "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\temp" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\temp" cd "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\temp"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\temp" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\temp"

if exist "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\mv-logs" cd "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\mv-logs"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\mv-logs" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvautenticador-cas-8500\mv-logs"


cls
title Deletando %%u tomcat-mvpep-8240 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\logs" cd "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\logs"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\logs" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\logs"

if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\temp" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\temp" cd "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\temp"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\temp" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\temp"

if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\mv-logs" cd "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\mv-logs"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\mv-logs" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvpep-8240\mv-logs"

cls
title Deletando %%u tomcat-mvpep-8241 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\logs" cd "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\logs"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\logs" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\logs"

if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\temp" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\temp" cd "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\temp"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\temp" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\temp"

if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\mv-logs" cd "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\mv-logs"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\mv-logs" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvpep-8241\mv-logs"


cls
title Deletando %%u tomcat-mvpep-8242 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\logs" cd "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\logs"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\logs" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\logs"

if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\temp" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\temp" cd "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\temp"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\temp" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\temp"

if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\mv-logs" cd "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\mv-logs"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\mv-logs" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvpep-8242\mv-logs"

cls
title Deletando %%u tomcat-mvpep-8243 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\logs" cd "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\logs"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\logs" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\logs"

if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\temp" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\temp" cd "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\temp"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\temp" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\temp"

if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\mv-logs" cd "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\mv-logs"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\mv-logs" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvpep-8243\mv-logs"

cls
title Deletando %%u tomcat-mvpep-8246 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\logs" cd "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\logs"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\logs" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\logs"

if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\temp" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\temp" cd "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\temp"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\temp" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\temp"

if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\mv-logs" cd "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\mv-logs"
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\mv-logs" rmdir /s /q "C:\MV\soulmv_prd\serves\tomcat-mvpep-8246\mv-logs"



cls
title Deletando %%u apache-httpd LOG and TEMP Files. . .
if exist "C:\MV\soulmv_trn\serves\apache-httpd\logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\apache-httpd\logs" cd "C:\MV\soulmv_trn\serves\apache-httpd\logs"
if exist "C:\MV\soulmv_trn\serves\apache-httpd\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\apache-httpd\logs" rmdir /s /q "C:\MV\soulmv_trn\serves\apache-httpd\logs"

cls
title Deletando %%u apache-httpd LOG and TEMP Files. . .
if exist "C:\MV\soulmv_trn\serves\ApacheMVReport\logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\ApacheMVReport\logs" cd "C:\MV\soulmv_trn\serves\ApacheMVReport\logs"
if exist "C:\MV\soulmv_trn\serves\ApacheMVReport\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\ApacheMVReport\logs" rmdir /s /q "C:\MV\soulmv_trn\serves\ApacheMVReport\logs"

cls
title Deletando %%u LaudosWeb LOG and TEMP Files. . .
if exist "C:\MV\soulmv_trn\serves\apache-tomcat-7.0.47-LaudosWeb\logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\apache-tomcat-7.0.47-LaudosWeb\logs" cd "C:\MV\soulmv_trn\serves\apache-tomcat-7.0.47-LaudosWeb\logs"
if exist "C:\MV\soulmv_trn\serves\apache-tomcat-7.0.47-LaudosWeb\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\apache-tomcat-7.0.47-LaudosWeb\logs" rmdir /s /q "C:\MV\soulmv_trn\serves\apache-tomcat-7.0.47-LaudosWeb\logs"

if exist "C:\MV\soulmv_trn\serves\apache-tomcat-7.0.47-LaudosWeb\temp" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\apache-tomcat-7.0.47-LaudosWeb\temp" cd "C:\MV\soulmv_trn\serves\apache-tomcat-7.0.47-LaudosWeb\temp"
if exist "C:\MV\soulmv_trn\serves\apache-tomcat-7.0.47-LaudosWeb\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\apache-tomcat-7.0.47-LaudosWeb\temp" rmdir /s /q "C:\MV\soulmv_trn\serves\apache-tomcat-7.0.47-LaudosWeb\temp"

cls
title Deletando %%u tomcat-7.0.52-x64_8040 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\logs" cd "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\logs"
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\logs" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\logs"

if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\temp" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\temp" cd "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\temp"
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\temp" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\temp"

if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\mv-logs" cd "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\mv-logs"
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\mv-logs" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8040\mv-logs"

cls
title Deletando %%u tomcat-7.0.52-x64_8060 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\logs" cd "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\logs"
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\logs" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\logs"

if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\temp" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\temp" cd "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\temp"
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\temp" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\temp"

if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\mv-logs" cd "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\mv-logs"
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\mv-logs" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-7.0.52-x64_8060\mv-logs"


cls
title Deletando %%u tomcat-mvautenticador-cas-8500 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\logs" cd "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\logs"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\logs" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\logs"

if exist "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\temp" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\temp" cd "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\temp"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\temp" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\temp"

if exist "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\mv-logs" cd "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\mv-logs"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\mv-logs" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvautenticador-cas-8500\mv-logs"


cls
title Deletando %%u tomcat-mvpep-8240 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\logs" cd "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\logs"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\logs" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\logs"

if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\temp" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\temp" cd "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\temp"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\temp" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\temp"

if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\mv-logs" cd "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\mv-logs"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\mv-logs" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvpep-8240\mv-logs"

cls
title Deletando %%u tomcat-mvpep-8241 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\logs" cd "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\logs"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\logs" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\logs"

if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\temp" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\temp" cd "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\temp"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\temp" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\temp"

if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\mv-logs" cd "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\mv-logs"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\mv-logs" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvpep-8241\mv-logs"


cls
title Deletando %%u tomcat-mvpep-8242 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\logs" cd "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\logs"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\logs" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\logs"

if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\temp" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\temp" cd "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\temp"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\temp" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\temp"

if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\mv-logs" cd "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\mv-logs"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\mv-logs" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvpep-8242\mv-logs"

cls
title Deletando %%u tomcat-mvpep-8243 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\logs" cd "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\logs"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\logs" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\logs"

if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\temp" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\temp" cd "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\temp"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\temp" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\temp"

if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\mv-logs" cd "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\mv-logs"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\mv-logs" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvpep-8243\mv-logs"

cls
title Deletando %%u tomcat-mvpep-8246 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\logs" cd "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\logs"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\logs" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\logs"

if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\temp" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\temp" cd "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\temp"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\temp" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\temp"

if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\mv-logs" cd "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\mv-logs"
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\mv-logs" rmdir /s /q "C:\MV\soulmv_trn\serves\tomcat-mvpep-8246\mv-logs"


cls
title Deletando %%u apache-httpd LOG and TEMP Files. . .
if exist "C:\MV\soulmv_sml\serves\apache-httpd\logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\apache-httpd\logs" cd "C:\MV\soulmv_sml\serves\apache-httpd\logs"
if exist "C:\MV\soulmv_sml\serves\apache-httpd\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\apache-httpd\logs" rmdir /s /q "C:\MV\soulmv_sml\serves\apache-httpd\logs"

cls
title Deletando %%u apache-httpd LOG and TEMP Files. . .
if exist "C:\MV\soulmv_sml\serves\ApacheMVReport\logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\ApacheMVReport\logs" cd "C:\MV\soulmv_sml\serves\ApacheMVReport\logs"
if exist "C:\MV\soulmv_sml\serves\ApacheMVReport\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\ApacheMVReport\logs" rmdir /s /q "C:\MV\soulmv_sml\serves\ApacheMVReport\logs"

cls
title Deletando %%u LaudosWeb LOG and TEMP Files. . .
if exist "C:\MV\soulmv_sml\serves\apache-tomcat-7.0.47-LaudosWeb\logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\apache-tomcat-7.0.47-LaudosWeb\logs" cd "C:\MV\soulmv_sml\serves\apache-tomcat-7.0.47-LaudosWeb\logs"
if exist "C:\MV\soulmv_sml\serves\apache-tomcat-7.0.47-LaudosWeb\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\apache-tomcat-7.0.47-LaudosWeb\logs" rmdir /s /q "C:\MV\soulmv_sml\serves\apache-tomcat-7.0.47-LaudosWeb\logs"

if exist "C:\MV\soulmv_sml\serves\apache-tomcat-7.0.47-LaudosWeb\temp" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\apache-tomcat-7.0.47-LaudosWeb\temp" cd "C:\MV\soulmv_sml\serves\apache-tomcat-7.0.47-LaudosWeb\temp"
if exist "C:\MV\soulmv_sml\serves\apache-tomcat-7.0.47-LaudosWeb\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\apache-tomcat-7.0.47-LaudosWeb\temp" rmdir /s /q "C:\MV\soulmv_sml\serves\apache-tomcat-7.0.47-LaudosWeb\temp"

cls
title Deletando %%u tomcat-7.0.52-x64_8040 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\logs" cd "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\logs"
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\logs" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\logs"

if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\temp" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\temp" cd "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\temp"
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\temp" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\temp"

if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\mv-logs" cd "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\mv-logs"
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\mv-logs" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8040\mv-logs"

cls
title Deletando %%u tomcat-7.0.52-x64_8060 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\logs" cd "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\logs"
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\logs" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\logs"

if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\temp" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\temp" cd "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\temp"
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\temp" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\temp"

if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\mv-logs" cd "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\mv-logs"
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\mv-logs" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-7.0.52-x64_8060\mv-logs"


cls
title Deletando %%u tomcat-mvautenticador-cas-8500 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\logs" cd "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\logs"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\logs" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\logs"

if exist "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\temp" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\temp" cd "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\temp"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\temp" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\temp"

if exist "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\mv-logs" cd "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\mv-logs"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\mv-logs" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvautenticador-cas-8500\mv-logs"


cls
title Deletando %%u tomcat-mvpep-8240 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\logs" cd "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\logs"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\logs" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\logs"

if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\temp" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\temp" cd "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\temp"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\temp" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\temp"

if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\mv-logs" cd "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\mv-logs"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\mv-logs" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvpep-8240\mv-logs"

cls
title Deletando %%u tomcat-mvpep-8241 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\logs" cd "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\logs"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\logs" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\logs"

if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\temp" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\temp" cd "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\temp"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\temp" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\temp"

if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\mv-logs" cd "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\mv-logs"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\mv-logs" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvpep-8241\mv-logs"


cls
title Deletando %%u tomcat-mvpep-8242 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\logs" cd "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\logs"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\logs" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\logs"

if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\temp" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\temp" cd "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\temp"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\temp" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\temp"

if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\mv-logs" cd "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\mv-logs"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\mv-logs" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvpep-8242\mv-logs"

cls
title Deletando %%u tomcat-mvpep-8243 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\logs" cd "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\logs"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\logs" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\logs"

if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\temp" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\temp" cd "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\temp"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\temp" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\temp"

if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\mv-logs" cd "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\mv-logs"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\mv-logs" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvpep-8243\mv-logs"

cls
title Deletando %%u tomcat-mvpep-8246 LOG and TEMP Files. . .
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\logs" cd "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\logs"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\logs" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\logs"

if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\temp" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\temp" cd "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\temp"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\temp" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\temp"

if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\mv-logs" echo Deletando....
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\mv-logs" cd "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\mv-logs"
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\mv-logs" del *.* /F /S /Q /A: R /A: H /A: A
if exist "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\mv-logs" rmdir /s /q "C:\MV\soulmv_sml\serves\tomcat-mvpep-8246\mv-logs"


)

cls
goto END


:END
exit