echo Esta configuracao remove qualquer IP configurado manualmente. Continuar?
pause
netsh winsock reset
netsh int ip reset
ipconfig /flushdns
ipconfig /release
ipconfig /renew