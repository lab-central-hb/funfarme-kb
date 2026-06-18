param(
    [string]$DestFolder
)

if (!(Test-Path $DestFolder)) {
    New-Item -ItemType Directory -Path $DestFolder -Force | Out-Null
}

$OutputFile = Join-Path $DestFolder "info_backup.txt"

$printers = Get-Printer | Select-Object Name, DriverName, PortName, Type, Shared

$drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.DisplayRoot } |
          Select-Object Name, DisplayRoot, @{Name="Used(GB)";Expression={[math]::Round($_.Used/1GB,2)}},
                        @{Name="Free(GB)";Expression={[math]::Round($_.Free/1GB,2)}}

"===== IMPRESSORAS INSTALADAS =====" | Out-File $OutputFile
$printers | Format-Table -AutoSize | Out-String | Out-File $OutputFile -Append

"`n===== PONTOS DE REDE MAPEADOS =====" | Out-File $OutputFile -Append
$drives | Format-Table -AutoSize | Out-String | Out-File $OutputFile -Append
