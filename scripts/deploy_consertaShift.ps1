# ================================
# CONFIGURACAO
# ================================

$SourceFile = "\\nti-102856\d$\santana\scripts\Conserta Shift.bat"
$DestinationSubPath = "c$\Users\Public\Desktop"

# Computadores
$Computers = @(
    "NTI-84449","NTI-84451","NTI-84443","NTI-84431","NTI-84455",
    "NTI-73543","NTI-84452","NTI-84485","NTI-85024","NTI-70619"
    # (rest of your list here, ideally sorted or imported)
)

# ================================
# FUNCOES
# ================================

function Write-Log {
    param (
        [string]$Computer,
        [string]$Message,
        [string]$Color = "White"
    )

    Write-Host "[$Computer] $Message" -ForegroundColor $Color
}

function Get-DestinationPath {
    param ([string]$Computer)

    return "\\$Computer\$DestinationSubPath"
}

function Copy-FileToComputer {
    param (
        [string]$Computer,
        [string]$SourceFile
    )

    $DestinationPath = Get-DestinationPath -Computer $Computer
    $FileName = Split-Path $SourceFile -Leaf
    $FullDestinationFile = Join-Path $DestinationPath $FileName

    Write-Log $Computer "Processando..." "Cyan"

    if (-not (Test-Path $DestinationPath)) {
        Write-Log $Computer "Destino nao acessivel" "Yellow"
        return
    }

    try {
        Copy-Item -Path $SourceFile -Destination $DestinationPath -Force -ErrorAction Stop

        if (Test-Path $FullDestinationFile) {
            Write-Log $Computer "Arquivo copiado e verificado" "Green"
        }
        else {
            Write-Log $Computer "Falha na verificacao. Tentativa de copia realizada" "Yellow"
        }
    }
    catch {
        Write-Log $Computer "ERRO copiar arquivo: $_" "Red"
    }
}

# ================================
# EXECUCAO
# ================================

foreach ($Computer in $Computers) {
    Copy-FileToComputer -Computer $Computer -SourceFile $SourceFile
}