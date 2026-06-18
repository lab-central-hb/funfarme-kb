#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Windows 11 Gaming and Performance Optimizer
    For: Web Browsing | Light Programming | Gaming
    Version: 2.1 (ASCII-safe)

.PARAMETER Action
    apply   - Apply all selected optimizations (default)
    revert  - Restore all backed-up settings
    status  - Show current state of each tweak

.PARAMETER Profile
    safe        - Only safe, reversible tweaks (default)
    performance - Includes service and telemetry tweaks
    full        - All tweaks including CPU, MSI mode, timer resolution

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File ".\Win11-GameMode-Optimizer.ps1" -Action apply -Profile safe
    powershell -ExecutionPolicy Bypass -File ".\Win11-GameMode-Optimizer.ps1" -Action apply -Profile performance
    powershell -ExecutionPolicy Bypass -File ".\Win11-GameMode-Optimizer.ps1" -Action apply -Profile full
    powershell -ExecutionPolicy Bypass -File ".\Win11-GameMode-Optimizer.ps1" -Action revert
    powershell -ExecutionPolicy Bypass -File ".\Win11-GameMode-Optimizer.ps1" -Action status
#>

param(
    [ValidateSet("apply", "revert", "status")]
    [string]$Action = "apply",

    [ValidateSet("safe", "performance", "full")]
    [string]$Profile = "safe"
)

# ============================================================
#  CONFIGURATION
# ============================================================
$ScriptVersion  = "2.1"
$BackupRoot     = "$env:USERPROFILE\Win11Optimizer_Backup"
$BackupManifest = "$BackupRoot\manifest.json"
$LogFile        = "$BackupRoot\optimizer.log"
$Timestamp      = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# ============================================================
#  HELPERS
# ============================================================

function Write-Log {
    param([string]$Msg, [string]$Level = "INFO")
    $entry = "[{0}] [{1}] {2}" -f (Get-Date -Format "HH:mm:ss"), $Level, $Msg
    Add-Content -Path $LogFile -Value $entry -ErrorAction SilentlyContinue
    switch ($Level) {
        "OK"    { Write-Host "  [+] $Msg" -ForegroundColor Green }
        "WARN"  { Write-Host "  [!] $Msg" -ForegroundColor Yellow }
        "ERR"   { Write-Host "  [X] $Msg" -ForegroundColor Red }
        "HEAD"  { Write-Host "`n  === $Msg ===" -ForegroundColor Cyan }
        "SKIP"  { Write-Host "  [-] $Msg" -ForegroundColor DarkGray }
        default { Write-Host "  [*] $Msg" -ForegroundColor White }
    }
}

function Ensure-Path {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Backup-RegistryValue {
    param([string]$RegPath, [string]$Name)
    try {
        if (Test-Path $RegPath) {
            $val = Get-ItemProperty -Path $RegPath -Name $Name -ErrorAction SilentlyContinue
            if ($null -ne $val) {
                $type = (Get-Item $RegPath).GetValueKind($Name)
                return @{ Existed = $true; Value = $val.$Name; Type = $type.ToString() }
            }
        }
    } catch {}
    return @{ Existed = $false; Value = $null; Type = "None" }
}

function Set-RegValue {
    param(
        [string]$Path,
        [string]$Name,
        [object]$Value,
        [string]$Type = "DWord",
        [switch]$NoBackup,
        [string]$TweakId
    )
    try {
        if ((-not $NoBackup) -and $TweakId) {
            $backup = Backup-RegistryValue -RegPath $Path -Name $Name
            $script:Manifest.Tweaks[$TweakId].RegBackups += @{
                Path        = $Path
                Name        = $Name
                PrevExisted = $backup.Existed
                PrevValue   = $backup.Value
                PrevType    = $backup.Type
            }
        }
        if (-not (Test-Path $Path)) {
            New-Item -Path $Path -Force | Out-Null
        }
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force
        return $true
    } catch {
        Write-Log "Failed to set $Path\$Name : $_" "ERR"
        return $false
    }
}

function Backup-Service {
    param([string]$ServiceName, [string]$TweakId)
    try {
        $svc = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
        if ($svc) {
            $startType = (Get-WmiObject Win32_Service -Filter "Name='$ServiceName'").StartMode
            $script:Manifest.Tweaks[$TweakId].ServiceBackups += @{
                Name      = $ServiceName
                StartType = $startType
                Status    = $svc.Status.ToString()
            }
            return $true
        }
    } catch {}
    return $false
}

function Set-ServiceSafe {
    param([string]$ServiceName, [string]$StartupType, [string]$TweakId)
    if (Backup-Service -ServiceName $ServiceName -TweakId $TweakId) {
        try {
            Set-Service -Name $ServiceName -StartupType $StartupType -ErrorAction Stop
            if ($StartupType -eq "Disabled") {
                Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
            }
            Write-Log "Service '$ServiceName' -> $StartupType" "OK"
        } catch {
            Write-Log "Could not modify service '$ServiceName': $_" "WARN"
        }
    } else {
        Write-Log "Service '$ServiceName' not found, skipping." "SKIP"
    }
}

function Load-Manifest {
    if (Test-Path $BackupManifest) {
        try {
            $json = Get-Content $BackupManifest -Raw | ConvertFrom-Json
            $ht = @{ Version = $json.Version; AppliedAt = $json.AppliedAt; Tweaks = @{} }
            foreach ($prop in $json.Tweaks.PSObject.Properties) {
                $t = $prop.Value
                $ht.Tweaks[$prop.Name] = @{
                    Applied        = [bool]$t.Applied
                    RegBackups     = @($t.RegBackups)
                    ServiceBackups = @($t.ServiceBackups)
                    PowerBackup    = $t.PowerBackup
                    TaskBackups    = @($t.TaskBackups)
                }
            }
            return $ht
        } catch {
            Write-Log "Could not parse manifest: $_" "WARN"
        }
    }
    return @{ Version = $ScriptVersion; AppliedAt = $Timestamp; Tweaks = @{} }
}

function Save-Manifest {
    Ensure-Path $BackupRoot
    $script:Manifest | ConvertTo-Json -Depth 10 | Set-Content $BackupManifest -Force
}

function Init-Tweak {
    param([string]$Id)
    if (-not $script:Manifest.Tweaks.ContainsKey($Id)) {
        $script:Manifest.Tweaks[$Id] = @{
            Applied        = $false
            RegBackups     = @()
            ServiceBackups = @()
            PowerBackup    = $null
            TaskBackups    = @()
        }
    }
}

# ============================================================
#  BANNER
# ============================================================
function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "  +-------------------------------------------------------+" -ForegroundColor Cyan
    Write-Host "  |   Win11 Gaming and Performance Optimizer  v$ScriptVersion       |" -ForegroundColor Cyan
    Write-Host "  |   For: Gaming | Browsing | Light Dev                  |" -ForegroundColor Cyan
    Write-Host "  +-------------------------------------------------------+" -ForegroundColor Cyan
    Write-Host "  Action  : $Action"   -ForegroundColor White
    Write-Host "  Profile : $Profile"  -ForegroundColor White
    Write-Host "  Backup  : $BackupRoot" -ForegroundColor DarkGray
    Write-Host ""
}

# ============================================================
#  SAFE TWEAKS
# ============================================================

function Tweak-GameMode {
    $id = "GameMode"
    Init-Tweak $id
    Write-Log "Game Mode and GPU Scheduling" "HEAD"

    Set-RegValue "HKCU:\Software\Microsoft\GameBar" "AutoGameModeEnabled" 1 -TweakId $id
    Set-RegValue "HKCU:\Software\Microsoft\GameBar" "AllowAutoGameMode"   1 -TweakId $id

    # Hardware-Accelerated GPU Scheduling (requires modern GPU + driver)
    Set-RegValue "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" 2 -TweakId $id

    # Variable Refresh Rate hint
    $vrrPath = "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences"
    Set-RegValue $vrrPath "DirectXUserGlobalSettings" "VRROptimizeEnable=1;" "String" -TweakId $id

    # Disable Game DVR capture (keeps Game Mode; removes recording overhead)
    Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" "AppCaptureEnabled" 0 -TweakId $id
    Set-RegValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"       "AllowGameDVR"      0 -TweakId $id

    $script:Manifest.Tweaks[$id].Applied = $true
    Write-Log "Game Mode tweaks applied." "OK"
}

function Tweak-PowerPlan {
    $id = "PowerPlan"
    Init-Tweak $id
    Write-Log "Power Plan" "HEAD"

    $currentGuid = [regex]::Match((powercfg /getactivescheme), '\{(.+?)\}').Value
    $script:Manifest.Tweaks[$id].PowerBackup = $currentGuid

    $ultimate = "e9a42b02-d5df-448d-aa00-03f14749eb61"
    $existing  = powercfg /list | Select-String $ultimate
    if (-not $existing) {
        powercfg /duplicatescheme $ultimate 2>$null | Out-Null
    }
    powercfg /setactive $ultimate 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Log "Ultimate Performance unavailable, using High Performance." "WARN"
        powercfg /setactive SCHEME_MIN
    } else {
        Write-Log "Ultimate Performance power plan activated." "OK"
    }

    # Disable USB Selective Suspend
    powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
    powercfg /setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
    powercfg /setactive SCHEME_CURRENT | Out-Null

    $script:Manifest.Tweaks[$id].Applied = $true
}

function Tweak-VisualEffects {
    $id = "VisualEffects"
    Init-Tweak $id
    Write-Log "Visual Effects - Performance Mode" "HEAD"

    Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" 3 -TweakId $id

    $dtPath = "HKCU:\Control Panel\Desktop"
    Set-RegValue $dtPath "DragFullWindows" "0" "String" -TweakId $id
    Set-RegValue $dtPath "MenuShowDelay"   "0" "String" -TweakId $id

    # UserPreferencesMask: strip animations, keep font smoothing
    Set-RegValue $dtPath "UserPreferencesMask" ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) "Binary" -TweakId $id

    Set-RegValue "HKCU:\Control Panel\Desktop\WindowMetrics" "MinAnimate"    "0" "String" -TweakId $id
    Set-RegValue $dtPath                                      "FontSmoothing" "2" "String" -TweakId $id

    $script:Manifest.Tweaks[$id].Applied = $true
    Write-Log "Visual effects set to performance mode." "OK"
}

function Tweak-NetworkOptimize {
    $id = "Network"
    Init-Tweak $id
    Write-Log "Network Optimizations" "HEAD"

    # Disable Nagle's Algorithm on each TCP interface (reduces in-game ping)
    $tcpIfPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
    Get-ChildItem $tcpIfPath -ErrorAction SilentlyContinue | ForEach-Object {
        Set-RegValue $_.PSPath "TcpAckFrequency" 1 -TweakId $id
        Set-RegValue $_.PSPath "TCPNoDelay"      1 -TweakId $id
    }

    $globalTcp = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
    Set-RegValue $globalTcp "TcpAckFrequency" 1 -TweakId $id
    Set-RegValue $globalTcp "TCPNoDelay"      1 -TweakId $id

    # Expand DNS resolver cache
    $dnsParams = "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters"
    Set-RegValue $dnsParams "CacheHashTableBucketSize" 1     -TweakId $id
    Set-RegValue $dnsParams "CacheHashTableSize"       384   -TweakId $id
    Set-RegValue $dnsParams "MaxCacheEntryTtlLimit"    64000 -TweakId $id
    Set-RegValue $dnsParams "MaxSOACacheEntryTtlLimit" 300   -TweakId $id

    netsh int tcp set global autotuninglevel=normal 2>$null | Out-Null

    $script:Manifest.Tweaks[$id].Applied = $true
    Write-Log "Network latency tweaks applied." "OK"
}

function Tweak-MouseKeyboard {
    $id = "InputDevices"
    Init-Tweak $id
    Write-Log "Mouse and Input Responsiveness" "HEAD"

    Set-RegValue "HKCU:\Control Panel\Mouse" "MouseSpeed"      "0" "String" -TweakId $id
    Set-RegValue "HKCU:\Control Panel\Mouse" "MouseThreshold1" "0" "String" -TweakId $id
    Set-RegValue "HKCU:\Control Panel\Mouse" "MouseThreshold2" "0" "String" -TweakId $id

    Set-RegValue "HKCU:\Control Panel\Keyboard" "KeyboardDelay" "0"  "String" -TweakId $id
    Set-RegValue "HKCU:\Control Panel\Keyboard" "KeyboardSpeed" "31" "String" -TweakId $id

    $script:Manifest.Tweaks[$id].Applied = $true
    Write-Log "Input devices optimized." "OK"
}

function Tweak-MemoryManagement {
    $id = "Memory"
    Init-Tweak $id
    Write-Log "Memory Management" "HEAD"

    $mmPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"

    # Keep kernel in RAM, not pagefile (safe on 16 GB or more)
    Set-RegValue $mmPath "DisablePagingExecutive" 1 -TweakId $id

    # LargeSystemCache = 0 favors applications over file cache
    Set-RegValue $mmPath "LargeSystemCache"       0 -TweakId $id

    # Do not zero pagefile on shutdown (faster shutdowns)
    Set-RegValue $mmPath "ClearPageFileAtShutdown" 0 -TweakId $id

    $script:Manifest.Tweaks[$id].Applied = $true
    Write-Log "Memory management tweaks applied." "OK"
}

function Tweak-StorageOptimize {
    $id = "Storage"
    Init-Tweak $id
    Write-Log "Storage and File System" "HEAD"

    # Reduce unnecessary SSD writes
    fsutil behavior set disablelastaccess 1 2>$null | Out-Null
    fsutil behavior set disable8dot3      1 2>$null | Out-Null

    $fsPath = "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"
    Set-RegValue $fsPath "NtfsMemoryUsage"             2 -TweakId $id
    Set-RegValue $fsPath "NtfsDisableLastAccessUpdate" 1 -TweakId $id

    # Disable Prefetch and Superfetch (no benefit on NVMe)
    $pfPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters"
    Set-RegValue $pfPath "EnablePrefetcher" 0 -TweakId $id
    Set-RegValue $pfPath "EnableSuperfetch" 0 -TweakId $id

    $script:Manifest.Tweaks[$id].Applied = $true
    Write-Log "Storage tweaks applied." "OK"
}

function Tweak-Notifications {
    $id = "Notifications"
    Init-Tweak $id
    Write-Log "Notifications and Suggestions" "HEAD"

    $cdm = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    Set-RegValue $cdm "SubscribedContent-338389Enabled" 0 -TweakId $id
    Set-RegValue $cdm "SubscribedContent-353694Enabled" 0 -TweakId $id
    Set-RegValue $cdm "SoftLandingEnabled"               0 -TweakId $id
    Set-RegValue $cdm "SystemPaneSuggestionsEnabled"     0 -TweakId $id

    $script:Manifest.Tweaks[$id].Applied = $true
    Write-Log "Notifications reduced." "OK"
}

function Tweak-Telemetry {
    $id = "Telemetry"
    Init-Tweak $id
    Write-Log "Telemetry and Privacy" "HEAD"

    Set-RegValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0 -TweakId $id
    Set-RegValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" 0 -TweakId $id

    Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0 -TweakId $id

    $sysPol = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
    Set-RegValue $sysPol "PublishUserActivities" 0 -TweakId $id
    Set-RegValue $sysPol "EnableActivityFeed"    0 -TweakId $id
    Set-RegValue $sysPol "UploadUserActivities"  0 -TweakId $id

    Set-RegValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana"   0 -TweakId $id
    Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"   "CortanaConsent" 0 -TweakId $id

    Set-RegValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackProgs" 0 -TweakId $id

    Set-RegValue "HKCU:\Software\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" 0 -TweakId $id
    Set-RegValue "HKCU:\Software\Microsoft\Siuf\Rules" "PeriodInNanoSeconds"  0 -TweakId $id

    $script:Manifest.Tweaks[$id].Applied = $true
    Write-Log "Telemetry and privacy tweaks applied." "OK"
}

# ============================================================
#  PERFORMANCE TWEAKS
# ============================================================

function Tweak-ServicesPerformance {
    $id = "Services"
    Init-Tweak $id
    Write-Log "Background Services - Performance Profile" "HEAD"

    $safeToDisable = @(
        @{ Name = "DiagTrack";        Desc = "Connected User Experiences (Telemetry)" },
        @{ Name = "dmwappushservice"; Desc = "WAP Push Message Routing (Telemetry)" },
        @{ Name = "WSearch";          Desc = "Windows Search Indexer" },
        @{ Name = "SysMain";          Desc = "Superfetch / SysMain" },
        @{ Name = "MapsBroker";       Desc = "Downloaded Maps Manager" },
        @{ Name = "lfsvc";            Desc = "Geolocation Service" },
        @{ Name = "SharedAccess";     Desc = "Internet Connection Sharing" },
        @{ Name = "RemoteRegistry";   Desc = "Remote Registry" },
        @{ Name = "XblAuthManager";   Desc = "Xbox Live Auth Manager" },
        @{ Name = "XblGameSave";      Desc = "Xbox Live Game Save" },
        @{ Name = "XboxGipSvc";       Desc = "Xbox Accessory Management" },
        @{ Name = "XboxNetApiSvc";    Desc = "Xbox Live Networking" },
        @{ Name = "WerSvc";           Desc = "Windows Error Reporting" },
        @{ Name = "Fax";              Desc = "Fax Service" },
        @{ Name = "RetailDemo";       Desc = "Retail Demo Service" }
    )

    foreach ($svc in $safeToDisable) {
        Write-Log "Disabling: $($svc.Desc)" "INFO"
        Set-ServiceSafe -ServiceName $svc.Name -StartupType "Disabled" -TweakId $id
    }

    # Windows Update set to Manual so it still runs when you trigger it
    Set-ServiceSafe -ServiceName "wuauserv" -StartupType "Manual" -TweakId $id
    Set-ServiceSafe -ServiceName "UsoSvc"   -StartupType "Manual" -TweakId $id

    $script:Manifest.Tweaks[$id].Applied = $true
}

function Tweak-ScheduledTasks {
    $id = "ScheduledTasks"
    Init-Tweak $id
    Write-Log "Scheduled Tasks - Telemetry and Bloat" "HEAD"

    $tasksToDisable = @(
        "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
        "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
        "\Microsoft\Windows\Application Experience\StartupAppTask",
        "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
        "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
        "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
        "\Microsoft\Windows\Feedback\Siuf\DmClient",
        "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload",
        "\Microsoft\Windows\Windows Error Reporting\QueueReporting",
        "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
    )

    foreach ($task in $tasksToDisable) {
        try {
            $tFolder = Split-Path $task
            $tName   = Split-Path $task -Leaf
            $t = Get-ScheduledTask -TaskPath $tFolder -TaskName $tName -ErrorAction SilentlyContinue
            if ($t) {
                $script:Manifest.Tweaks[$id].TaskBackups += @{ Path = $task; State = $t.State.ToString() }
                Disable-ScheduledTask -TaskPath $tFolder -TaskName $tName -ErrorAction SilentlyContinue | Out-Null
                Write-Log "Disabled task: $tName" "OK"
            } else {
                Write-Log "Task not found: $tName" "SKIP"
            }
        } catch {
            Write-Log "Could not modify task $task : $_" "WARN"
        }
    }

    $script:Manifest.Tweaks[$id].Applied = $true
}

function Tweak-StartupPrograms {
    $id = "Startup"
    Init-Tweak $id
    Write-Log "Startup Programs - Microsoft Bloat" "HEAD"

    $regPaths = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    )

    $bloatEntries = @("OneDrive", "MicrosoftTeams", "Skype", "DiscordUpdate", "EpicGamesLauncher")

    foreach ($regPath in $regPaths) {
        foreach ($entry in $bloatEntries) {
            $val = Get-ItemProperty -Path $regPath -Name $entry -ErrorAction SilentlyContinue
            if ($val) {
                $script:Manifest.Tweaks[$id].RegBackups += @{
                    Path        = $regPath
                    Name        = $entry
                    PrevExisted = $true
                    PrevValue   = $val.$entry
                    PrevType    = "String"
                }
                Remove-ItemProperty -Path $regPath -Name $entry -Force -ErrorAction SilentlyContinue
                Write-Log "Removed startup entry: $entry" "OK"
            }
        }
    }

    $script:Manifest.Tweaks[$id].Applied = $true
    Write-Log "Tip: Open Task Manager > Startup for any remaining entries." "WARN"
}

# ============================================================
#  FULL / ADVANCED TWEAKS
# ============================================================

function Tweak-CPUPriority {
    $id = "CPUPriority"
    Init-Tweak $id
    Write-Log "CPU Scheduler Priority" "HEAD"

    # Win32PrioritySeparation = 38 (0x26)
    # Short variable quanta with 2:1 boost for foreground app
    Set-RegValue "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" 38 -TweakId $id

    $script:Manifest.Tweaks[$id].Applied = $true
    Write-Log "CPU scheduler tuned for foreground gaming priority." "OK"
}

function Tweak-TimerResolution {
    $id = "TimerResolution"
    Init-Tweak $id
    Write-Log "System Timer Resolution (0.5ms)" "HEAD"

    $timerScript = @'
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class TimerRes {
    [DllImport("ntdll.dll")]
    public static extern int NtSetTimerResolution(int DesiredResolution, bool SetResolution, out int CurrentResolution);
}
"@ -Language CSharp
$cur = 0
[TimerRes]::NtSetTimerResolution(5000, $true, [ref]$cur) | Out-Null
'@

    $timerScriptPath = "$BackupRoot\SetTimerRes.ps1"
    $timerScript | Set-Content $timerScriptPath -Encoding UTF8 -Force

    $taskAction   = New-ScheduledTaskAction -Execute "powershell.exe" `
                        -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$timerScriptPath`""
    $taskTrigger  = New-ScheduledTaskTrigger -AtLogOn
    $taskSettings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 1) -Priority 0

    Register-ScheduledTask -TaskName "Win11OptimizerTimerRes" `
        -Action $taskAction -Trigger $taskTrigger -Settings $taskSettings `
        -RunLevel Highest -Force -ErrorAction SilentlyContinue | Out-Null

    $script:Manifest.Tweaks[$id].Applied = $true
    Write-Log "0.5ms timer resolution scheduled at logon." "OK"
    Write-Log "Revert will unregister the scheduled task." "WARN"
}

function Tweak-MSIMode {
    $id = "MSIMode"
    Init-Tweak $id
    Write-Log "MSI Mode for GPU and NVMe" "HEAD"

    $pciDevices = Get-WmiObject Win32_PnPEntity -ErrorAction SilentlyContinue |
                  Where-Object { $_.Name -match "NVIDIA|AMD Radeon|Intel Arc|NVMe" }

    if ($pciDevices) {
        foreach ($dev in $pciDevices) {
            $basePath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($dev.DeviceID)\Device Parameters\Interrupt Management"
            $msiPath  = "$basePath\MessageSignaledInterruptProperties"
            if (Test-Path $basePath) {
                Set-RegValue $msiPath "MSISupported" 1 -TweakId $id
                Write-Log "MSI enabled for: $($dev.Name)" "OK"
            }
        }
    } else {
        Write-Log "No matching GPU/NVMe devices found via WMI." "WARN"
    }

    $script:Manifest.Tweaks[$id].Applied = $true
    Write-Log "MSI mode applied. Reboot required." "WARN"
}

# ============================================================
#  APPLY
# ============================================================
function Apply-Tweaks {
    Write-Log "Starting optimization -- Profile: $Profile" "HEAD"

    Tweak-GameMode
    Tweak-PowerPlan
    Tweak-VisualEffects
    Tweak-NetworkOptimize
    Tweak-MouseKeyboard
    Tweak-MemoryManagement
    Tweak-StorageOptimize
    Tweak-Notifications
    Tweak-Telemetry

    if ($Profile -in @("performance", "full")) {
        Tweak-ServicesPerformance
        Tweak-ScheduledTasks
        Tweak-StartupPrograms
    }

    if ($Profile -eq "full") {
        Tweak-CPUPriority
        Tweak-TimerResolution
        Tweak-MSIMode
    }

    $script:Manifest.AppliedAt = $Timestamp
    Save-Manifest

    Write-Host ""
    Write-Host "  +------------------------------------------------------+" -ForegroundColor Green
    Write-Host "  |  All tweaks applied successfully!                    |" -ForegroundColor Green
    Write-Host "  |  Backup: $BackupRoot" -ForegroundColor Green
    Write-Host "  |                                                      |" -ForegroundColor Green
    Write-Host "  |  >> REBOOT RECOMMENDED <<                            |" -ForegroundColor Yellow
    Write-Host "  |                                                      |" -ForegroundColor Green
    Write-Host "  |  To revert:                                          |" -ForegroundColor Cyan
    Write-Host "  |  .\Win11-GameMode-Optimizer.ps1 -Action revert       |" -ForegroundColor Cyan
    Write-Host "  +------------------------------------------------------+" -ForegroundColor Green
}

# ============================================================
#  REVERT
# ============================================================
function Revert-Tweaks {
    Write-Log "Starting REVERT -- restoring all backed-up settings" "HEAD"

    if (-not (Test-Path $BackupManifest)) {
        Write-Log "No backup manifest found at $BackupManifest. Nothing to revert." "ERR"
        return
    }

    foreach ($tweakId in $script:Manifest.Tweaks.Keys) {
        $tweak = $script:Manifest.Tweaks[$tweakId]
        if (-not $tweak.Applied) { continue }

        Write-Log "Reverting: $tweakId" "HEAD"

        foreach ($rb in $tweak.RegBackups) {
            try {
                if ($rb.PrevExisted) {
                    if (-not (Test-Path $rb.Path)) { New-Item -Path $rb.Path -Force | Out-Null }
                    Set-ItemProperty -Path $rb.Path -Name $rb.Name -Value $rb.PrevValue -Type $rb.PrevType -Force
                    Write-Log "Restored: $($rb.Name)" "OK"
                } else {
                    Remove-ItemProperty -Path $rb.Path -Name $rb.Name -Force -ErrorAction SilentlyContinue
                    Write-Log "Removed (was new): $($rb.Name)" "OK"
                }
            } catch {
                Write-Log "Failed to restore $($rb.Name): $_" "WARN"
            }
        }

        foreach ($sb in $tweak.ServiceBackups) {
            try {
                $startMap = @{
                    "Auto"      = "Automatic"
                    "Manual"    = "Manual"
                    "Disabled"  = "Disabled"
                    "Automatic" = "Automatic"
                }
                $mappedType = if ($startMap.ContainsKey($sb.StartType)) { $startMap[$sb.StartType] } else { "Manual" }
                Set-Service -Name $sb.Name -StartupType $mappedType -ErrorAction SilentlyContinue
                if ($sb.Status -eq "Running") {
                    Start-Service -Name $sb.Name -ErrorAction SilentlyContinue
                }
                Write-Log "Service restored: $($sb.Name) -> $mappedType" "OK"
            } catch {
                Write-Log "Could not restore service $($sb.Name): $_" "WARN"
            }
        }

        foreach ($tb in $tweak.TaskBackups) {
            try {
                if ($tb.State -eq "Ready") {
                    $tFolder = Split-Path $tb.Path
                    $tName   = Split-Path $tb.Path -Leaf
                    Enable-ScheduledTask -TaskPath $tFolder -TaskName $tName -ErrorAction SilentlyContinue | Out-Null
                    Write-Log "Re-enabled task: $tName" "OK"
                }
            } catch {}
        }

        if ($tweak.PowerBackup) {
            powercfg /setactive $tweak.PowerBackup 2>$null
            Write-Log "Power plan restored: $($tweak.PowerBackup)" "OK"
        }
    }

    Unregister-ScheduledTask -TaskName "Win11OptimizerTimerRes" -Confirm:$false -ErrorAction SilentlyContinue

    fsutil behavior set disablelastaccess 0 2>$null | Out-Null
    fsutil behavior set disable8dot3      0 2>$null | Out-Null

    foreach ($k in $script:Manifest.Tweaks.Keys) {
        $script:Manifest.Tweaks[$k].Applied = $false
    }
    Save-Manifest

    Write-Host ""
    Write-Host "  +------------------------------------------------------+" -ForegroundColor Yellow
    Write-Host "  |  Revert complete. All settings restored.             |" -ForegroundColor Yellow
    Write-Host "  |  >> REBOOT RECOMMENDED <<                            |" -ForegroundColor Yellow
    Write-Host "  +------------------------------------------------------+" -ForegroundColor Yellow
}

# ============================================================
#  STATUS
# ============================================================
function Show-Status {
    Write-Log "Current Tweak Status" "HEAD"

    if (-not (Test-Path $BackupManifest)) {
        Write-Log "No manifest found. No tweaks have been applied yet." "WARN"
        return
    }

    Write-Host ""
    Write-Host ("  {0,-25} {1,-10} {2}" -f "Tweak", "Applied", "Backed-Up Reg Entries") -ForegroundColor Cyan
    Write-Host ("  {0,-25} {1,-10} {2}" -f ("-" * 24), ("-" * 9), ("-" * 20)) -ForegroundColor DarkGray

    foreach ($tweakId in ($script:Manifest.Tweaks.Keys | Sort-Object)) {
        $t          = $script:Manifest.Tweaks[$tweakId]
        $appliedStr = if ($t.Applied) { "YES" } else { "no" }
        $color      = if ($t.Applied) { "Green" } else { "DarkGray" }
        $regCount   = $t.RegBackups.Count
        Write-Host ("  {0,-25} {1,-10} {2}" -f $tweakId, $appliedStr, $regCount) -ForegroundColor $color
    }

    Write-Host ""
    Write-Log "Backup location : $BackupRoot" "INFO"
    Write-Log "Applied at      : $($script:Manifest.AppliedAt)" "INFO"
}

# ============================================================
#  ENTRY POINT
# ============================================================
Show-Banner
Ensure-Path $BackupRoot
Write-Log "Script started -- Action=$Action  Profile=$Profile" "INFO"

$script:Manifest = Load-Manifest

switch ($Action) {
    "apply"  { Apply-Tweaks }
    "revert" { Revert-Tweaks }
    "status" { Show-Status }
}

Write-Host ""
Write-Log "Done. Log saved to: $LogFile" "INFO"
Write-Host ""
