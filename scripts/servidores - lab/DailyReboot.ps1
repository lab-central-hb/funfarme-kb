# ==============================================================================
# DailyReboot.ps1
# Sends a 5-minute warning to all logged-in users, then a 1-minute warning,
# then reboots the server. Scheduled daily at 23:30.
# ==============================================================================

# ── 5-minute warning ───────────────────────────────────────────────────────────
msg * /TIME:30 "AVISO: O computador será reiniciado em 5 minutos para manutenção diária. Por favor, salve seu trabalho e encerre sua sessão."

Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Aviso de 5 minutos enviado. Aguardando 4 minutos..."
Start-Sleep -Seconds 240   # wait 4 minutes

# ── 1-minute warning ───────────────────────────────────────────────────────────
msg * /TIME:70 "AVISO FINAL: O computador será reiniciado em 1 minuto. Salve seu trabalho imediatamente."

Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Aviso de 1 minuto enviado. Aguardando 60 segundos..."
Start-Sleep -Seconds 60    # wait 1 final minute

# ── Reboot ─────────────────────────────────────────────────────────────────────
Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Iniciando reinicialização..."
shutdown /r /t 0 /f /c "Reinicialização diária de manutenção."
