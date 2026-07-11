#Requires -Version 5.1
Write-Host "`n  System Info" -ForegroundColor Cyan
Write-Host "  ─────────────────────────────────────────────────"

$os  = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$gpu = Get-CimInstance Win32_VideoController | Where-Object { $_.Name -notmatch 'Basic|Remote|Virtual' } | Select-Object -First 1
$ram = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
$free = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
$disk = Get-PSDrive C | Select-Object Used, Free
$up  = (Get-Date) - $os.LastBootUpTime

$rows = [ordered]@{
    'OS'       = "$($os.Caption) (Build $($os.BuildNumber))"
    'CPU'      = "$($cpu.Name)  [$($cpu.NumberOfCores)C / $($cpu.NumberOfLogicalProcessors)T]"
    'GPU'      = $gpu.Name
    'RAM'      = "$free GB free / $ram GB total"
    'Disk C:'  = "$([math]::Round($disk.Free/1GB,1)) GB free / $([math]::Round(($disk.Used+$disk.Free)/1GB,1)) GB total"
    'Uptime'   = "$($up.Days)d $($up.Hours)h $($up.Minutes)m"
    'Hostname' = $env:COMPUTERNAME
    'User'     = "$env:USERDOMAIN\$env:USERNAME"
}

foreach ($k in $rows.Keys) {
    Write-Host ("  {0,-12} {1}" -f "$k :", $rows[$k])
}

Write-Host ""
Write-Host "  Running processes : $((Get-Process).Count)"
Write-Host "  Startup entries   : $((Get-CimInstance Win32_StartupCommand).Count)"
