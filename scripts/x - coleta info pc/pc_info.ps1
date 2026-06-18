# pc_info.ps1
# coleta informacoes do pc e envia para \\nti-102856\d$\santana\funfarme-kb\docs\inventario\

$NTI = $env:COMPUTERNAME
$CPUArray = (Get-WmiObject Win32_Processor).Name
$CPU = if ($CPUArray -is [array]) { ($CPUArray -join ", ") } else { $CPUArray }
$Placamae = Get-WmiObject Win32_BaseBoard | Select-Object -First 1 Manufacturer, Product
$PlacaMae = "$($Placamae.Manufacturer) $($Placamae.Product)"
$GPU = (Get-WmiObject Win32_VideoController | Select-Object -ExpandProperty Name) -join ", "
$MAC = (Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.MACAddress -and $_.IPEnabled } | Select-Object -ExpandProperty MACAddress) -join ", "
$IP = ((Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -ne $null }).IPAddress | Where-Object { $_ -notmatch ":" }) -join ", "
$OS = (Get-WmiObject Win32_OperatingSystem).Caption
$RAM = [math]::Round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
$Local = Read-Host -Prompt "Informe o local do PC"
$Patrimonio = Read-Host -Prompt "Informe o patrimonio"
$Entidade = Read-Host -Prompt "Informe a entidade(HB, HCM, ...)"

# pega hd ou ssd
$DiscosInfo = Get-WmiObject Win32_DiskDrive | ForEach-Object {
    $sizeGB = [math]::Round($_.Size / 1GB, 2)
    "$($_.Model) - ${sizeGB} GB"
}
$Discos = $DiscosInfo -join "`n                 "

$info = @"
===============================
   INFORMACOES DO SISTEMA
===============================

NTI              : $NTI
Patrimonio       : $Patrimonio
CPU              : $CPU
Local            : $Local
Entidade         : $Entidade
Placa-mae        : $($Placamae.Manufacturer) $($Placamae.Product)
GPU              : $GPU
Memoria RAM      : ${RAM} GB
Discos Rigidos   : $Discos
Endereco MAC     : $MAC
Endereco IP      : $IP
Edicao Windows   : $OS


"@

$Path = "\\nti-102856\d$\santana\funfarme-kb\docs\inventario\$NTI.txt"
$info | Out-File -Encoding UTF8 $Path

# Funcao para converter hashtable em JSON (compativel com PowerShell 2.0)
function ConvertTo-JsonCompat {
    param($Hashtable)
    
    $json = "{"
    $first = $true
    foreach ($key in $Hashtable.Keys) {
        if (-not $first) { $json += "," }
        $first = $false
        
        $value = $Hashtable[$key]
        $json += "`"$key`":"
        
        if ($value -is [string]) {
            $escaped = $value -replace '\\', '\\' -replace '"', '\"' -replace "`n", '\n' -replace "`r", '\r' -replace "`t", '\t'
            $json += "`"$escaped`""
        } elseif ($value -is [int] -or $value -is [double] -or $value -is [decimal]) {
            $json += "$value"
        } else {
            $escaped = $value.ToString() -replace '\\', '\\' -replace '"', '\"' -replace "`n", '\n' -replace "`r", '\r' -replace "`t", '\t'
            $json += "`"$escaped`""
        }
    }
    $json += "}"
    return $json
}

$jsonData = @{
    "NTI" = $NTI
    "CPU" = $CPU
    "Placamae" = $PlacaMae
    "GPU" = $GPU
    "RAM" = $RAM
    "Discos" = $Discos
    "MAC" = $MAC
    "IP" = $IP
    "OS" = $OS
    "Local" = $Local
    "Patrimonio" = $Patrimonio
    "Entidade" = $Entidade
}

# Tenta usar ConvertTo-Json se disponivel (PowerShell 3.0+), senao usa funcao compativel
if (Get-Command ConvertTo-Json -ErrorAction SilentlyContinue) {
    $jsonData = $jsonData | ConvertTo-Json -Depth 10 -Compress
} else {
    $jsonData = ConvertTo-JsonCompat -Hashtable $jsonData
}

# Salva JSON no diretorio compartilhado para processamento
$jsonFolder = "\\nti-102856\d$\santana\funfarme-kb\scripts\x - coleta info pc\jsonData"
if (-not (Test-Path $jsonFolder)) {
    New-Item -ItemType Directory -Path $jsonFolder -Force | Out-Null
}

# Compativel com PowerShell 2.0
$timestamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
$jsonFileName = "$NTI`_$timestamp.json"
$jsonPath = Join-Path $jsonFolder $jsonFileName

# Usa UTF8NoBOM para evitar BOM que causa erro no Python
[System.IO.File]::WriteAllText($jsonPath, $jsonData, [System.Text.UTF8Encoding]::new($false))

Write-Host "Informacoes salvas em: $Path"
Write-Host "JSON salvo em: $jsonPath (aguardando processamento)"
