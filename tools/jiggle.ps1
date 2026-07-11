#Requires -Version 5.1
Add-Type @'
using System;
using System.Runtime.InteropServices;
public class Mouse {
    [DllImport("user32.dll")] public static extern bool SetCursorPos(int x, int y);
    [DllImport("user32.dll")] public static extern bool GetCursorPos(out POINT p);
    [StructLayout(LayoutKind.Sequential)] public struct POINT { public int X, Y; }
}
'@

$interval = 5
Write-Host "`n  Mouse Jiggle  (every ${interval} min)  —  Ctrl+C to stop" -ForegroundColor Cyan
Write-Host "  ─────────────────────────────────────────────────"

while ($true) {
    $p = New-Object Mouse+POINT
    [Mouse]::GetCursorPos([ref]$p) | Out-Null
    [Mouse]::SetCursorPos($p.X + 1, $p.Y) | Out-Null
    Start-Sleep -Milliseconds 80
    [Mouse]::SetCursorPos($p.X, $p.Y) | Out-Null
    Write-Host "  $(Get-Date -f 'HH:mm:ss')  jiggled  (next: $((Get-Date).AddMinutes($interval).ToString('HH:mm')))" -ForegroundColor DarkGray
    Start-Sleep -Seconds ($interval * 60)
}
