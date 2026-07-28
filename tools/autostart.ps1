# ============================================
# Autostart NUCLEAR Cleanup
# Entfernt UWP Autostart-Registrierungen HART
# Als Administrator ausfuehren!
# ============================================

Write-Host "=== Autostart NUCLEAR Cleanup ===" -ForegroundColor Cyan
Write-Host ""

$count = 0

# --- UWP Apps: Startup Task State auf 1 (disabled) setzen ---
Write-Host "[1/3] UWP Startup Tasks hart deaktivieren..." -ForegroundColor Yellow

$uwpPatterns = @(
    "*Xbox*",
    "*YourPhone*", "*PhoneLink*", "*SmartphoneLink*",
    "*CrossDevice*", "*MobileDevices*",
    "*PowerAutomate*",
    "*MSI*Center*",
    "*Terminal*"
)

$appDataPath = "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData"
if (Test-Path $appDataPath) {
    Get-ChildItem $appDataPath -ErrorAction SilentlyContinue | ForEach-Object {
        $familyName = $_.PSChildName
        $startupPath = Join-Path $_.PSPath "StartupTasks"
        if (Test-Path $startupPath) {
            $matched = $false
            foreach ($pattern in $uwpPatterns) {
                if ($familyName -like $pattern) { $matched = $true; break }
            }
            if ($matched) {
                Get-ChildItem $startupPath -ErrorAction SilentlyContinue | ForEach-Object {
                    $currentState = (Get-ItemProperty $_.PSPath -Name "State" -ErrorAction SilentlyContinue).State
                    if ($currentState -ne 1) {
                        Set-ItemProperty -Path $_.PSPath -Name "State" -Value 1 -Force -ErrorAction SilentlyContinue
                    }
                    # UserEnabledStartupOnce auf 0 setzen damit Windows es nicht reaktiviert
                    Set-ItemProperty -Path $_.PSPath -Name "UserEnabledStartupOnce" -Value 0 -Force -ErrorAction SilentlyContinue
                    Write-Host "  [x] $familyName -> disabled" -ForegroundColor Green
                    $script:count++
                }
            }
        }
    }
}

# --- Registry Run + StartupApproved komplett saeubern ---
Write-Host "[2/3] Registry Autostart-Eintraege entfernen..." -ForegroundColor Yellow

$keywords = @(
    "Smartphone", "YourPhone", "PhoneLink",
    "MobileDevices", "CrossDevice",
    "MSI", "MSICenter",
    "msedge", "Edge",
    "OneDrive",
    "Roblox",
    "Xbox", "GameBar",
    "PowerAutomate",
    "Have",
    "browser_assistant",
    "EpicGames"
)

$allKeys = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder"
)

foreach ($key in $allKeys) {
    if (-not (Test-Path $key)) { continue }
    $item = Get-Item $key -ErrorAction SilentlyContinue
    if (-not $item) { continue }
    foreach ($prop in $item.Property) {
        $val = try { (Get-ItemPropertyValue $key -Name $prop -ErrorAction SilentlyContinue) } catch { "" }
        foreach ($kw in $keywords) {
            if ($prop -like "*$kw*" -or "$val" -like "*$kw*") {
                Remove-ItemProperty -Path $key -Name $prop -Force -ErrorAction SilentlyContinue
                Write-Host "  [x] $key -> $prop" -ForegroundColor Green
                $count++
                break
            }
        }
    }
}

# --- Scheduled Tasks ---
Write-Host "[3/3] Scheduled Tasks deaktivieren..." -ForegroundColor Yellow
$taskKW = @("Xbox", "OneDrive", "Edge", "MobileDevices", "YourPhone", "PhoneLink", "PowerAutomate", "Roblox", "EpicGames", "MSI", "BrowserAssistant", "CrossDevice")
Get-ScheduledTask -ErrorAction SilentlyContinue | ForEach-Object {
    foreach ($kw in $taskKW) {
        if ($_.TaskName -like "*$kw*" -or $_.TaskPath -like "*$kw*") {
            Disable-ScheduledTask -TaskName $_.TaskName -TaskPath $_.TaskPath -ErrorAction SilentlyContinue | Out-Null
            Write-Host "  [x] Task: $($_.TaskName)" -ForegroundColor Green
            $count++
            break
        }
    }
}

Write-Host ""
Write-Host "$count Eintraege bearbeitet!" -ForegroundColor Cyan
Write-Host ""
Write-Host "WICHTIG: PC jetzt neustarten!" -ForegroundColor Red
Write-Host ""
Write-Host "Falls Eintraege nach dem Neustart wieder auftauchen:" -ForegroundColor DarkYellow
Write-Host "  -> Die App selbst deinstallieren (Einstellungen > Apps)" -ForegroundColor DarkYellow
Write-Host "  -> Windows registriert UWP-Autostart neu solange die App installiert ist" -ForegroundColor DarkYellow
Read-Host "Enter druecken zum Beenden"
