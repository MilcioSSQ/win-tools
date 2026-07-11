#Requires -Version 5.1
Write-Host "`n  Windows Defender" -ForegroundColor Cyan
Write-Host "  ─────────────────────────────────────────────────"

try {
    $s = Get-MpComputerStatus
    $rt  = if ($s.RealTimeProtectionEnabled) { 'ON' } else { 'OFF' }
    $col = if ($s.RealTimeProtectionEnabled) { 'Green' } else { 'Red' }
    Write-Host "  Real-time protection : " -NoNewline
    Write-Host $rt -ForegroundColor $col
    Write-Host "  Signature version    : $($s.AntivirusSignatureVersion)"
    Write-Host "  Last full scan       : $($s.FullScanEndTime)"
} catch { Write-Host "  Could not read Defender status." -ForegroundColor Yellow }

Write-Host ""
Write-Host "  [1] Quick scan    [2] Full scan    [3] Offline scan (reboot)    [0] Back"
switch (Read-Host "  Select") {
    '1' { Update-MpSignature -ErrorAction SilentlyContinue; Start-MpScan -ScanType QuickScan; Write-Host "  Quick scan started." -ForegroundColor Green }
    '2' { Update-MpSignature -ErrorAction SilentlyContinue; Start-MpScan -ScanType FullScan;  Write-Host "  Full scan started (runs in background)." -ForegroundColor Green }
    '3' {
        if ((Read-Host "  This will reboot. Continue? [JA]") -ceq 'JA') {
            Start-MpWDOScan
        }
    }
}
