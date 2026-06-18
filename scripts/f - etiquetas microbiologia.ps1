#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Reset e reconfiguracao da impressora ETIQUETAS
    1. Para o servico Spooler
    2. Limpa a fila de impressao (System32\spool\PRINTERS)
    3. Inicia o servico Spooler
    4. Remove a impressora ETIQUETAS
    5. Readiciona a impressora ETIQUETAS na porta \\nti-9999\etiquetas

.EXEMPLO
    powershell -ExecutionPolicy Bypass -File ".\Reset-Impressora-Etiquetas.ps1"
#>

$impressoraNome = "ETIQUETAS"
$impressoraPorta = "\\nti-84435\etiquetas"
$spoolDir = "$env:SystemRoot\System32\spool\PRINTERS"

function Log {
    param([string]$Msg, [string]$Nivel = "INFO")
    $hora = Get-Date -Format "HH:mm:ss"
    switch ($Nivel) {
        "OK"    { Write-Host "[$hora] [+] $Msg" -ForegroundColor Green }
        "ERRO"  { Write-Host "[$hora] [X] $Msg" -ForegroundColor Red }
        "AVISO" { Write-Host "[$hora] [!] $Msg" -ForegroundColor Yellow }
        default { Write-Host "[$hora] [*] $Msg" -ForegroundColor White }
    }
}

Write-Host ""
Write-Host "  +--------------------------------------------------+" -ForegroundColor Cyan
Write-Host "  |   Reset de Impressora - ETIQUETAS                |" -ForegroundColor Cyan
Write-Host "  +--------------------------------------------------+" -ForegroundColor Cyan
Write-Host ""

# --------------------------------------------------------
# 1. Parar o Spooler
# --------------------------------------------------------
Log "Parando o servico Spooler..."
try {
    Stop-Service -Name "Spooler" -Force -ErrorAction Stop
    Start-Sleep -Seconds 2
    Log "Spooler parado." "OK"
} catch {
    Log "Falha ao parar o Spooler: $_" "ERRO"
    exit 1
}

# --------------------------------------------------------
# 2. Limpar fila de impressao
# --------------------------------------------------------
Log "Limpando arquivos em: $spoolDir"
try {
    $arquivos = Get-ChildItem -Path $spoolDir -File -ErrorAction SilentlyContinue
    if ($arquivos.Count -eq 0) {
        Log "Nenhum arquivo na fila." "AVISO"
    } else {
        Remove-Item -Path "$spoolDir\*" -Force -ErrorAction Stop
        Log "$($arquivos.Count) arquivo(s) removido(s) da fila." "OK"
    }
} catch {
    Log "Erro ao limpar a fila: $_" "ERRO"
    # Continua mesmo assim para tentar iniciar o spooler
}

# --------------------------------------------------------
# 3. Iniciar o Spooler
# --------------------------------------------------------
Log "Iniciando o servico Spooler..."
try {
    Start-Service -Name "Spooler" -ErrorAction Stop
    Start-Sleep -Seconds 2
    Log "Spooler iniciado." "OK"
} catch {
    Log "Falha ao iniciar o Spooler: $_" "ERRO"
    exit 1
}

# --------------------------------------------------------
# 4. Remover impressora ETIQUETAS
# --------------------------------------------------------
Log "Verificando se a impressora '$impressoraNome' existe..."
$existe = Get-Printer -Name $impressoraNome -ErrorAction SilentlyContinue
if ($existe) {
    try {
        Remove-Printer -Name $impressoraNome -ErrorAction Stop
        Start-Sleep -Seconds 1
        Log "Impressora '$impressoraNome' removida." "OK"
    } catch {
        Log "Erro ao remover impressora: $_" "ERRO"
        exit 1
    }
} else {
    Log "Impressora '$impressoraNome' nao encontrada, nada a remover." "AVISO"
}

# --------------------------------------------------------
# 5. Garantir que a porta existe
# --------------------------------------------------------
Log "Verificando porta '$impressoraPorta'..."
$portaExiste = Get-PrinterPort -Name $impressoraPorta -ErrorAction SilentlyContinue
if (-not $portaExiste) {
    Log "Porta nao encontrada. Criando..." "AVISO"
    try {
        Add-PrinterPort -Name $impressoraPorta -ErrorAction Stop
        Log "Porta '$impressoraPorta' criada." "OK"
    } catch {
        Log "Erro ao criar porta: $_" "ERRO"
        exit 1
    }
} else {
    Log "Porta '$impressoraPorta' ja existe." "OK"
}

# --------------------------------------------------------
# 6. Detectar driver disponivel
# --------------------------------------------------------
$driverPadrao = "Generic / Text Only"
$driverDetectado = Get-PrinterDriver -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match "Zebra|ZDesigner|Argox|TSC|Bematech|Datamax|Honeywell" } |
    Select-Object -First 1

if ($driverDetectado) {
    $driverUsado = $driverDetectado.Name
    Log "Driver detectado: '$driverUsado'" "OK"
} else {
    $driverUsado = $driverPadrao
    Log "Nenhum driver de etiqueta encontrado. Usando: '$driverUsado'" "AVISO"
    Log "Se necessario, edite a variavel driverUsado no script." "AVISO"
}

# --------------------------------------------------------
# 7. Adicionar impressora ETIQUETAS
# --------------------------------------------------------
Log "Adicionando impressora '$impressoraNome' na porta '$impressoraPorta'..."
try {
    Add-Printer -Name $impressoraNome -PortName $impressoraPorta -DriverName $driverUsado -ErrorAction Stop
    Log "Impressora '$impressoraNome' adicionada com sucesso!" "OK"
} catch {
    Log "Erro ao adicionar impressora: $_" "ERRO"
    Log "Verifique se o driver '$driverUsado' esta instalado neste computador." "AVISO"
    exit 1
}

# --------------------------------------------------------
# Resumo final
# --------------------------------------------------------
Write-Host ""
Write-Host "  +--------------------------------------------------+" -ForegroundColor Green
Write-Host "  |  Concluido com sucesso!                          |" -ForegroundColor Green
Write-Host "  |  Impressora : $impressoraNome" -ForegroundColor Green
Write-Host "  |  Porta      : $impressoraPorta" -ForegroundColor Green
Write-Host "  |  Driver     : $driverUsado" -ForegroundColor Green
Write-Host "  +--------------------------------------------------+" -ForegroundColor Green
Write-Host ""
