<#
.SYNOPSIS
    One-line installer for win-tools by MilcioSSQ.
    Run:  irm https://raw.githubusercontent.com/MilcioSSQ/win-tools/main/install.ps1 | iex
#>

$ErrorActionPreference = 'Stop'

# ── Elevate: save to temp file and relaunch as admin ─────────────────────────
$principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host ""
    Write-Host "  win-tools needs Administrator. Elevating..." -ForegroundColor Yellow
    $tmp = Join-Path $env:TEMP 'win-tools-install.ps1'
    Invoke-RestMethod 'https://raw.githubusercontent.com/MilcioSSQ/win-tools/main/install.ps1' -OutFile $tmp
    Start-Process powershell.exe -Verb RunAs -ArgumentList @(
        '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$tmp`""
    )
    exit
}

# ── We are admin now, running as a real file ─────────────────────────────────
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

try {
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile -UseBasicParsing
    Expand-Archive -Path $zipFile -DestinationPath $extract -Force
    Remove-Item $zipFile -Force
} catch {
    Write-Host "  Download failed: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "  Enter to exit"
    exit 1
}

$folder = Get-ChildItem $extract | Where-Object { $_.PSIsContainer } | Select-Object -First 1

if (-not $folder) {
    Write-Host "  Extract failed." -ForegroundColor Red
    Read-Host "  Enter to exit"
    exit 1
}

Write-Host "  Starting win-tools..." -ForegroundColor Green
Write-Host ""

# ── Run the script directly (works because we are a real .ps1 file) ──────────
$mainScript = Join-Path $folder.FullName 'win-tools.ps1'
& $mainScript

# ── Cleanup ──────────────────────────────────────────────────────────────────
Remove-Item $extract -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item (Join-Path $env:TEMP 'win-tools-install.ps1') -Force -ErrorAction SilentlyContinue
