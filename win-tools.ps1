#Requires -Version 5.1

# Fix: $PSScriptRoot ist leer nach Admin-Elevation
if (-not $PSScriptRoot) {
    $root = Split-Path -Parent (Resolve-Path $MyInvocation.MyCommand.Path)
} else {
    $root = $PSScriptRoot
}

$principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$($root)\win-tools.ps1`""
    exit
}

function Invoke-Tool($name) {
    $path = Join-Path $root "tools\$name.ps1"
    if (Test-Path $path) { & $path } else { Write-Host "  not found: $path" -ForegroundColor Red }
    Read-Host "`n  Enter to return"
}

while ($true) {
    Clear-Host
    Write-Host ""
    Write-Host "  win-tools  by MilcioSSQ" -ForegroundColor White
    Write-Host "  github.com/MilcioSSQ/win-tools" -ForegroundColor DarkGray
    Write-Host "  -------------------------------------------------"
    Write-Host "  [1]  Bloatware remover" -ForegroundColor Cyan
    Write-Host "  [2]  Autostart cleaner" -ForegroundColor Cyan
    Write-Host "  [3]  Temp and cache cleaner" -ForegroundColor Cyan
    Write-Host "  [4]  Mouse jiggle" -ForegroundColor Cyan
    Write-Host "  [5]  Gaming tweaks" -ForegroundColor Cyan
    Write-Host "  [6]  Defender scan" -ForegroundColor Cyan
    Write-Host "  [7]  Network info" -ForegroundColor Cyan
    Write-Host "  [8]  System info" -ForegroundColor Cyan
    Write-Host "  [9]  Power plan switcher" -ForegroundColor Cyan
    Write-Host "  [10] Dark mode toggle" -ForegroundColor Cyan
    Write-Host "  [0]  Exit" -ForegroundColor DarkGray
    Write-Host "  -------------------------------------------------"
    switch (Read-Host "  Select") {
        '1'  { Invoke-Tool 'bloatware' }
        '2'  { Invoke-Tool 'autostart' }
        '3'  { Invoke-Tool 'cleaner' }
        '4'  { Invoke-Tool 'jiggle' }
        '5'  { Invoke-Tool 'gaming' }
        '6'  { Invoke-Tool 'defender' }
        '7'  { Invoke-Tool 'network' }
        '8'  { Invoke-Tool 'sysinfo' }
        '9'  { Invoke-Tool 'powerplan' }
        '10' { Invoke-Tool 'darkmode' }
        '0'  { exit }
    }
}
