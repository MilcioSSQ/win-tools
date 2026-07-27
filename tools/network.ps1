#Requires -Version 5.1
Write-Host "`n  Network Info" -ForegroundColor Cyan
Write-Host "  ─────────────────────────────────────────────────"

$adapters = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled }
foreach ($a in $adapters) {
    Write-Host "  $($a.Description)" -ForegroundColor White
    Write-Host "    IP       : $($a.IPAddress -join ', ')"
    Write-Host "    Gateway  : $($a.DefaultIPGateway -join ', ')"
    Write-Host "    DNS      : $($a.DNSServerSearchOrder -join ', ')"
    Write-Host "    MAC      : $($a.MACAddress)"
    Write-Host ""
}

Write-Host "  Public IP:" -ForegroundColor White -NoNewline
try {
    $pub = (Invoke-RestMethod 'https://api.ipify.org?format=text' -TimeoutSec 5)
    Write-Host "  $pub"
} catch { Write-Host "  (could not reach ipify.org)" -ForegroundColor DarkGray }

Write-Host ""
$target = Read-Host "  Ping target (Enter to skip)"
if ($target) {
    $result = Test-Connection $target -Count 4 -ErrorAction SilentlyContinue
    if ($result) {
        $avg = ($result | Measure-Object -Property Latency -Average).Average
        Write-Host ("  {0}  avg {1:N0} ms" -f $target, $avg) -ForegroundColor Green
    } else {
        Write-Host "  No response from $target" -ForegroundColor Red
    }
}
