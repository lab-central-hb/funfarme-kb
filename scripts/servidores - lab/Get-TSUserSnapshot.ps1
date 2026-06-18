# ==============================================================================
# Get-TSUserSnapshot.ps1
# Collects a snapshot of all logged-in Terminal Server users every time it runs.
# Captures: username, session state, login time, idle time, RAM usage (MB).
# Saves to a monthly CSV file: TSUserSnapshots_2026-05.csv
# Each snapshot block is clearly separated inside the file.
# ==============================================================================

# ── Configuration ──────────────────────────────────────────────────────────────
$ScriptDir  = "C:\scripts"   # <-- UPDATE if your script lives elsewhere
$CsvDir     = $ScriptDir           # CSVs saved in the same folder as the script
$Timestamp  = Get-Date
$MonthStamp = $Timestamp.ToString("yyyy-MM")          # e.g. 2026-05
$CsvPath    = Join-Path $CsvDir "TSUserSnapshots_$MonthStamp.csv"

# ── Parse quser output ─────────────────────────────────────────────────────────
function Get-QUserSessions {
    $raw = quser 2>$null
    if (-not $raw) { return @() }

    $sessions = @()
    foreach ($line in $raw | Select-Object -Skip 1) {
        if ($line.Trim() -eq "") { continue }

        $username    = $line.Substring(1,  20).Trim().TrimStart('>')
        $sessionName = $line.Substring(23, 19).Trim()
        $id          = $line.Substring(42,  4).Trim()
        $state       = $line.Substring(46,  8).Trim()
        $idleTime    = $line.Substring(54, 11).Trim()
        $logonTime   = $line.Substring(65).Trim()

        $sessions += [PSCustomObject]@{
            Username  = $username
            SessionID = $id
            State     = $state
            IdleTime  = $idleTime
            LogonTime = $logonTime
        }
    }
    return $sessions
}

# ── Get RAM usage per user ─────────────────────────────────────────────────────
function Get-RamByUser {
    $map = @{}
    Get-Process -IncludeUserName -ErrorAction SilentlyContinue |
        Where-Object { $_.UserName } |
        ForEach-Object {
            $user = $_.UserName.Split('\')[-1].ToLower()
            if (-not $map.ContainsKey($user)) { $map[$user] = 0 }
            $map[$user] += $_.WorkingSet64
        }
    return $map
}

# ── Build snapshot rows ────────────────────────────────────────────────────────
$sessions      = Get-QUserSessions
$ramMap        = Get-RamByUser
$snapshotLabel = $Timestamp.ToString("yyyy-MM-dd HH:mm:ss")
$rows          = @()

foreach ($s in $sessions) {
    $userLower = $s.Username.ToLower()
    $ramMB     = if ($ramMap.ContainsKey($userLower)) {
                     [math]::Round($ramMap[$userLower] / 1MB, 1)
                 } else { 0 }

    $rows += [PSCustomObject]@{
        Snapshot_Time = $snapshotLabel
        Username      = $s.Username
        SessionID     = $s.SessionID
        State         = $s.State
        LogonTime     = $s.LogonTime
        IdleTime      = $s.IdleTime
        RAM_MB        = $ramMB
    }
}

if ($rows.Count -eq 0) {
    $rows += [PSCustomObject]@{
        Snapshot_Time = $snapshotLabel
        Username      = "(none)"
        SessionID     = ""
        State         = ""
        LogonTime     = ""
        IdleTime      = ""
        RAM_MB        = 0
    }
}

# ── Append to monthly CSV ──────────────────────────────────────────────────────
$fileExists = Test-Path $CsvPath

# Write header only if the file is new
if (-not $fileExists) {
    $rows | Export-Csv -Path $CsvPath -NoTypeInformation -Encoding UTF8
} else {
    # Append a blank separator line for visual clarity between snapshots,
    # then append the data rows without repeating the header
    Add-Content -Path $CsvPath -Value "" -Encoding UTF8
    $rows | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1 |
        Add-Content -Path $CsvPath -Encoding UTF8
}

Write-Host "[$snapshotLabel] Snapshot appended — $($rows.Count) session(s) -> $CsvPath"
