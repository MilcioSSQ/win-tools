#Requires -Version 5.1
$bloat = @(
    '*MicrosoftSolitaireCollection*', '*Microsoft.BingNews*', '*Microsoft.BingWeather*',
    '*Microsoft.Getstarted*', '*Microsoft.MicrosoftOfficeHub*', '*Microsoft.SkypeApp*',
    '*Microsoft.MixedReality.Portal*', '*Microsoft.Microsoft3DViewer*', '*Microsoft.MSPaint*',
    '*Microsoft.People*', '*Microsoft.WindowsFeedbackHub*', '*Microsoft.WindowsMaps*',
    '*Microsoft.GetHelp*', '*Clipchamp.Clipchamp*', '*Microsoft.549981C3F5F10*',
    '*MicrosoftTeams*', '*BytedancePte.Ltd.TikTok*', '*Disney*', '*king.com*',
    '*Netflix*', '*Facebook*', '*Instagram*', '*Twitter*'
)

Write-Host "`n  Bloatware Remover" -ForegroundColor Cyan
Write-Host "  ─────────────────────────────────────────────────"

$found = foreach ($p in $bloat) {
    Get-AppxPackage -AllUsers -Name $p -ErrorAction SilentlyContinue
}
$found = @($found | Sort-Object Name -Unique)

if (-not $found) { Write-Host "  Nothing to remove — already clean." -ForegroundColor Green; return }

$found | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Yellow }
Write-Host ""
if ((Read-Host "  Remove all? [JA]") -cne 'JA') { return }

foreach ($pkg in $found) {
    try {
        Remove-AppxPackage -Package $pkg.PackageFullName -AllUsers -ErrorAction Stop
        Write-Host "  removed  $($pkg.Name)" -ForegroundColor Green
    } catch { Write-Host "  failed   $($pkg.Name)" -ForegroundColor Red }
}

Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue |
    Where-Object { $b = $_.DisplayName; $bloat | Where-Object { $b -like $_ } } |
    ForEach-Object {
        Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue | Out-Null
    }

Write-Host "`n  Done." -ForegroundColor Green
