#Requires -Version 5.1
$keep = @('nvidia','amd','radeon','realtek','nahimic','audio','lghub','logitech',
          'razer','synapse','steelseries','corsair','synaptics','elan',
          'defender','antimalware','msi.center','armoury')

$hives = @(
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run',
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run'
)
$startup = @(
    [Environment]::GetFolderPath('Startup'),
    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
)
$backup = Join-Path $env:LOCALAPPDATA 'win-tools-autostart.json'

function Is-Protected($name, $val) {
    foreach ($k in $keep) { if ($name -match $k -or $val -match $k) { return $true } }
    return $false
}

function Get-Entries {
    $list = [System.Collections.Generic.List[object]]::new()
    foreach ($h in $hives) {
        if (-not (Test-Path $h)) { continue }
        (Get-ItemProperty $h).PSObject.Properties |
            Where-Object { $_.Name -notmatch '^PS' -and $_.Name -ne '(default)' } |
            ForEach-Object { $list.Add([pscustomobject]@{ type='reg'; hive=$h; name=$_.Name; value=[string]$_.Value }) }
    }
    foreach ($f in $startup) {
        Get-ChildItem $f -File -ErrorAction SilentlyContinue |
            Where-Object Name -ne 'desktop.ini' |
            ForEach-Object { $list.Add([pscustomobject]@{ type='file'; path=$_.FullName; name=$_.Name }) }
    }
    $list
}

Write-Host "`n  Autostart Cleaner" -ForegroundColor Cyan
Write-Host "  ─────────────────────────────────────────────────"

$entries = Get-Entries
if (-not $entries) { Write-Host "  No startup entries found." -ForegroundColor Green; return }

$disable = $entries | Where-Object { -not (Is-Protected $_.name ($_.value + $_.path)) }
$protect  = $entries | Where-Object {      Is-Protected $_.name ($_.value + $_.path)  }

Write-Host "  Will disable:" -ForegroundColor Yellow
$disable | ForEach-Object { Write-Host "    - $($_.name)" -ForegroundColor Yellow }
Write-Host "  Protected (kept):" -ForegroundColor DarkGray
$protect  | ForEach-Object { Write-Host "    = $($_.name)" -ForegroundColor DarkGray }

if (-not $disable) { Write-Host "`n  Nothing to disable." -ForegroundColor Green; return }
if ((Read-Host "`n  Disable yellow list? [JA]") -cne 'JA') { return }

$saved = @()
$dir   = Join-Path $env:LOCALAPPDATA 'win-tools-disabled-startup'
New-Item $dir -ItemType Directory -Force | Out-Null

foreach ($e in $disable) {
    try {
        if ($e.type -eq 'reg') {
            $saved += [pscustomobject]@{ type='reg'; hive=$e.hive; name=$e.name; value=$e.value }
            Remove-ItemProperty $e.hive -Name $e.name -ErrorAction Stop
        } else {
            $dest = Join-Path $dir ([IO.Path]::GetFileName($e.path))
            Move-Item $e.path $dest -Force -ErrorAction Stop
            $saved += [pscustomobject]@{ type='file'; original=$e.path; movedTo=$dest }
        }
        Write-Host "  disabled  $($e.name)" -ForegroundColor Green
    } catch { Write-Host "  failed    $($e.name)" -ForegroundColor Red }
}

$saved | ConvertTo-Json -Depth 4 | Set-Content $backup -Encoding UTF8
Write-Host "`n  Done. Backup: $backup" -ForegroundColor Green
Write-Host "  Run with -Restore to undo." -ForegroundColor DarkGray
