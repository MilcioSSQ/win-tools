#Requires -Version 5.1
$reg  = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize'
$apps = (Get-ItemPropertyValue $reg -Name AppsUseLightTheme  -ErrorAction SilentlyContinue) -eq 0
$sys  = (Get-ItemPropertyValue $reg -Name SystemUsesLightTheme -ErrorAction SilentlyContinue) -eq 0

$mode = if ($apps -and $sys) { 'Dark' } elseif (-not $apps -and -not $sys) { 'Light' } else { 'Mixed' }

Write-Host "`n  Dark Mode Toggle" -ForegroundColor Cyan
Write-Host "  ─────────────────────────────────────────────────"
Write-Host "  Current : $mode"
Write-Host ""
Write-Host "  [1] Dark    [2] Light    [0] Back"

switch (Read-Host "  Select") {
    '1' {
        Set-ItemProperty $reg -Name AppsUseLightTheme   -Value 0 -Type DWord
        Set-ItemProperty $reg -Name SystemUsesLightTheme -Value 0 -Type DWord
        Write-Host "  Dark mode enabled." -ForegroundColor Green
    }
    '2' {
        Set-ItemProperty $reg -Name AppsUseLightTheme   -Value 1 -Type DWord
        Set-ItemProperty $reg -Name SystemUsesLightTheme -Value 1 -Type DWord
        Write-Host "  Light mode enabled." -ForegroundColor Green
    }
}
