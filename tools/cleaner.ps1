#Requires -Version 5.1
$targets = @(
    $env:TEMP,
    'C:\Windows\Temp',
    'C:\Windows\Prefetch',
    "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
    "$env:LOCALAPPDATA\pip\cache",
    "$env:APPDATA\npm-cache"
)

Write-Host "`n  Temp & Cache Cleaner" -ForegroundColor Cyan
Write-Host "  ─────────────────────────────────────────────────"

$total = 0
foreach ($path in $targets) {
    if (-not (Test-Path $path)) { continue }
    $size = (Get-ChildItem $path -Recurse -Force -ErrorAction SilentlyContinue |
             Measure-Object Length -Sum -ErrorAction SilentlyContinue).Sum
    if ($size -gt 0) {
        Write-Host ("  {0,-45} {1,8:N1} MB" -f $path, ($size / 1MB)) -ForegroundColor Yellow
        $total += $size
    }
}

Write-Host ("  ─────────────────────────────────────────────────")
Write-Host ("  Total freeable: {0:N1} MB" -f ($total / 1MB)) -ForegroundColor White
Write-Host ""

if ((Read-Host "  Clean all? [JA]") -cne 'JA') { return }

$freed = 0
foreach ($path in $targets) {
    if (-not (Test-Path $path)) { continue }
    $before = (Get-ChildItem $path -Recurse -Force -ErrorAction SilentlyContinue |
               Measure-Object Length -Sum -ErrorAction SilentlyContinue).Sum
    Get-ChildItem $path -Force -ErrorAction SilentlyContinue |
        ForEach-Object { Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }
    $after = (Get-ChildItem $path -Recurse -Force -ErrorAction SilentlyContinue |
              Measure-Object Length -Sum -ErrorAction SilentlyContinue).Sum
    $freed += ($before - $after)
}

Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Host ("  Freed {0:N1} MB" -f ($freed / 1MB)) -ForegroundColor Green
