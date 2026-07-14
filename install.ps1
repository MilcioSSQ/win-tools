<#
.SYNOPSIS
    One-line installer for win-tools by MilcioSSQ.
    Run:  irm https://raw.githubusercontent.com/MilcioSSQ/win-tools/main/install.ps1 | iex
#>

$ErrorActionPreference = 'Stop'

# ── Download & extract (works without admin) ─────────────────────────────────
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

if (Test-Path $extract) { Remove-Item $extract -Recurse -Force }

Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile -UseBasicParsing
Expand-Archive -Path $zipFile -DestinationPath $extract -Force
Remove-Item $zipFile -Force

$folder = Get-ChildItem $extract | Where-Object { $_.PSIsContainer } | Select-Object -First 1

if (-not $folder) {
    Write-Host "  Download failed." -ForegroundColor Red
    Read-Host "  Enter to exit"
    exit 1
}

Write-Host "  Starting win-tools..." -ForegroundColor Green

# ── Launch in a clean, elevated PowerShell process ───────────────────────────
$mainScript = Join-Path $folder.FullName 'win-tools.ps1'
Start-Process powershell.exe -Verb RunAs -ArgumentList @(
    '-NoProfile',
    '-ExecutionPolicy', 'Bypass',
    '-File', "`"$mainScript`""
) -Wait

# ── Cleanup ──────────────────────────────────────────────────────────────────
Remove-Item $extract -Recurse -Force -ErrorAction SilentlyContinue
