#Requires -Version 5.1
$plans = @{
    'Balanced'        = '381b4222-f694-41f0-9685-ff5bb260df2e'
    'High performance'= '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
    'Power saver'     = 'a1841308-3541-4fab-bc81-f71556f20b4a'
}

Write-Host "`n  Power Plan Switcher" -ForegroundColor Cyan
Write-Host "  ─────────────────────────────────────────────────"

$current = [regex]::Match((powercfg /getactivescheme), '[0-9a-fA-F-]{36}').Value
$curName = $plans.GetEnumerator() | Where-Object Value -eq $current | Select-Object -ExpandProperty Key

Write-Host "  Active : $curName" -ForegroundColor White
Write-Host ""

$i = 1
$ordered = $plans.GetEnumerator() | Sort-Object Key
$ordered | ForEach-Object { Write-Host "  [$i] $($_.Key)"; $i++ }
Write-Host "  [0] Back"

$sel = Read-Host "`n  Select"
if ($sel -eq '0') { return }

$target = @($ordered)[[int]$sel - 1]
if (-not $target) { Write-Host "  Invalid selection." -ForegroundColor Red; return }

powercfg /setactive $target.Value 2>$null
Write-Host "  Switched to: $($target.Key)" -ForegroundColor Green
