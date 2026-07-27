@echo off
:: win-tools by MilcioSSQ — double-click to run
:: Downloads the latest version and opens the menu.

:: ── Elevate to admin ────────────────────────────────────────────────────────
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ── Download, extract, launch ───────────────────────────────────────────────
title win-tools by MilcioSSQ
echo.
echo   win-tools by MilcioSSQ
echo   ─────────────────────────────────────────────────
echo   Downloading latest version...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$zip = Join-Path $env:TEMP 'win-tools.zip'; " ^
    "$ext = Join-Path $env:TEMP 'win-tools-extract'; " ^
    "if (Test-Path $ext) { Remove-Item $ext -Recurse -Force }; " ^
    "Invoke-WebRequest 'https://github.com/MilcioSSQ/win-tools/archive/refs/heads/main.zip' -OutFile $zip -UseBasicParsing; " ^
    "Expand-Archive $zip $ext -Force; Remove-Item $zip -Force; " ^
    "$f = (Get-ChildItem $ext)[0].FullName; " ^
    "& (Join-Path $f 'win-tools.ps1'); " ^
    "Remove-Item $ext -Recurse -Force -ErrorAction SilentlyContinue"
