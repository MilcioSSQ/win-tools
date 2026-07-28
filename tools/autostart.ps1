# autostart.ps1 - Interactive Autostart Cleaner
# Zeigt alle Autostart-Eintraege und laesst dich waehlen welche entfernt werden

Write-Host ""
Write-Host "  Autostart Cleaner" -ForegroundColor Cyan
Write-Host "  -------------------------------------------------"
Write-Host "  Scanning..." -ForegroundColor DarkGray

$entries = @()

# Registry Run keys
$regPaths = @(
    @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"; Scope = "User" },
    @{ Path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"; Scope = "System" }
)

foreach ($reg in $regPaths) {
    if (-not (Test-Path $reg.Path)) { continue }
    $item = Get-Item $reg.Path -ErrorAction SilentlyContinue
    foreach ($prop in $item.Property) {
        $val = (Get-ItemPropertyValue $reg.Path -Name $prop -ErrorAction SilentlyContinue)
        $entries += [PSCustomObject]@{
            Name   = $prop
            Value  = $val
            Source = "Registry ($($reg.Scope))"
            RegPath = $reg.Path
            Type   = "registry"
        }
    }
}

# Startup folder
$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
if (Test-Path $startupFolder) {
    Get-ChildItem $startupFolder -ErrorAction SilentlyContinue | ForEach-Object {
        $entries += [PSCustomObject]@{
            Name    = $_.Name
            Value   = $_.FullName
            Source  = "Startup Folder"
            RegPath = $_.FullName
            Type    = "file"
        }
    }
}

# Scheduled tasks that run at logon
Get-ScheduledTask -ErrorAction SilentlyContinue | ForEach-Object {
    $triggers = $_.Triggers | Where-Object { $_.CimClass.CimClassName -eq "MSFT_TaskLogonTrigger" }
    if ($triggers -and $_.State -ne "Disabled") {
        $entries += [PSCustomObject]@{
            Name    = $_.TaskName
            Value   = $_.TaskPath
            Source  = "Scheduled Task"
            RegPath = $_.TaskName
            Type    = "task"
        }
    }
}

if ($entries.Count -eq 0) {
    Write-Host "  No autostart entries found." -ForegroundColor Green
    return
}

# Display all entries with numbers
Write-Host ""
Write-Host "  Found $($entries.Count) autostart entries:" -ForegroundColor White
Write-Host "  -------------------------------------------------"

for ($i = 0; $i -lt $entries.Count; $i++) {
    $e = $entries[$i]
    $num = ($i + 1).ToString().PadLeft(2)
    Write-Host "  [$num] " -ForegroundColor Yellow -NoNewline
    Write-Host "$($e.Name)" -ForegroundColor White -NoNewline
    Write-Host "  ($($e.Source))" -ForegroundColor DarkGray
}

Write-Host "  -------------------------------------------------"
Write-Host ""
Write-Host "  Enter numbers to remove (comma separated, e.g. 1,3,5)" -ForegroundColor Cyan
Write-Host "  Enter 'all' to remove everything" -ForegroundColor Cyan
Write-Host "  Enter 0 to cancel" -ForegroundColor DarkGray
Write-Host ""
$input = Read-Host "  Selection"

if ($input -eq "0" -or [string]::IsNullOrWhiteSpace($input)) {
    Write-Host "  Cancelled." -ForegroundColor DarkGray
    return
}

# Parse selection
if ($input -eq "all") {
    $selected = 1..$entries.Count
} else {
    $selected = $input -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ }
}

$removed = 0
foreach ($num in $selected) {
    if ($num -lt 1 -or $num -gt $entries.Count) { continue }
    $e = $entries[$num - 1]

    switch ($e.Type) {
        "registry" {
            Remove-ItemProperty -Path $e.RegPath -Name $e.Name -Force -ErrorAction SilentlyContinue
            # Also remove from StartupApproved
            $approvedPath = $e.RegPath -replace "\\Run$", "\Explorer\StartupApproved\Run"
            if (Test-Path $approvedPath) {
                Remove-ItemProperty -Path $approvedPath -Name $e.Name -Force -ErrorAction SilentlyContinue
            }
            Write-Host "  [x] Removed: $($e.Name)" -ForegroundColor Green
            $removed++
        }
        "file" {
            Remove-Item $e.RegPath -Force -ErrorAction SilentlyContinue
            Write-Host "  [x] Removed: $($e.Name)" -ForegroundColor Green
            $removed++
        }
        "task" {
            Disable-ScheduledTask -TaskName $e.RegPath -ErrorAction SilentlyContinue | Out-Null
            Write-Host "  [x] Disabled: $($e.Name)" -ForegroundColor Green
            $removed++
        }
    }
}

Write-Host ""
Write-Host "  $removed entries removed/disabled!" -ForegroundColor Cyan
Write-Host "  Restart your PC for changes to take effect." -ForegroundColor DarkYellow
