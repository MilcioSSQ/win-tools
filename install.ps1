<#
.SYNOPSIS
    One-line installer for win-tools by MilcioSSQ.
    Run:  irm https://raw.githubusercontent.com/MilcioSSQ/win-tools/main/install.ps1 | iex
#>

$ErrorActionPreference = 'Stop'

# ── Admin check & elevation ──────────────────────────────────────────────────
$principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host ""
    Write-Host "  win-tools needs Administrator privileges." -ForegroundColor Yellow
    Write-Host "  Elevating..." -ForegroundColor DarkGray
    # Save this script to a temp file, then relaunch elevated
    $tempScript = Join-Path $env:TEMP 'win-tools-install.ps1'
    $scriptUrl  = 'https://raw.githubusercontent.com/MilcioSSQ/win-tools/main/install.ps1'
    Invoke-RestMethod $scriptUrl -OutFile $tempScript
    Start-Process powershell.exe -Verb RunAs -ArgumentList `
        '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$tempScript`""
    exit
}

# ── Download & extract ───────────────────────────────────────────────────────
$repo    = 'MilcioSSQ/win-tools'
$branch  = 'main'
$zipUrl  = "https://github.com/$repo/archive/refs/heads/$branch.zip"
$zipFile = Join-Path $env:TEMP 'win-tools.zip'
$extract = Join-Path $env:TEMP 'win-tools-extract'

Write-Host ""
Write-Host "  win-tools" -ForegroundColor White -NoNewline
Write-Host "  by MilcioSSQ" -ForegroundColor DarkGray
Write-Host "  ─────────────────────────────────────────────────"
Write-Host "  Downloading latest version..." -ForegroundColor Cyan

# Clean up previous runs
if (Test-Path $extract) { Remove-Item $extract -Recurse -Force }

Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile -UseBasicParsing
Expand-Archive -Path $zipFile -DestinationPath $extract -Force
Remove-Item $zipFile -Force

# Find the extracted folder (GitHub zips have a top-level folder)
$folder = Get-ChildItem $extract | Where-Object { $_.PSIsContainer } | Select-Object -First 1

if (-not $folder) {
    Write-Host "  Download failed." -ForegroundColor Red
    Read-Host "  Enter to exit"
    exit 1
}

Write-Host "  Starting win-tools..." -ForegroundColor Green
Write-Host ""

# ── Launch the real script ───────────────────────────────────────────────────
$mainScript = Join-Path $folder.FullName 'win-tools.ps1'
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$mainScript"

# ── Cleanup ──────────────────────────────────────────────────────────────────
Remove-Item $extract -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item (Join-Path $env:TEMP 'win-tools-install.ps1') -Force -ErrorAction SilentlyContinue
