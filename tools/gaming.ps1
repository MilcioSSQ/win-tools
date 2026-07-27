#Requires -Version 5.1
$backup = Join-Path $env:LOCALAPPDATA 'win-tools-gaming.json'
$GUID_HIGH = '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
$GUID_BAL  = '381b4222-f694-41f0-9685-ff5bb260df2e'

$saved = @{}

function Set-Reg($path, $name, $value, $type) {
    if (-not (Test-Path $path)) { New-Item $path -Force | Out-Null }
    $cur = Get-ItemProperty $path -Name $name -ErrorAction SilentlyContinue
    $key = "$path||$name"
    if (-not $saved.ContainsKey($key)) {
        $saved[$key] = @{ path=$path; name=$name; old=($cur?.$name); type=$type; existed=($null -ne $cur) }
    }
    New-ItemProperty $path -Name $name -Value $value -PropertyType $type -Force | Out-Null
}

function Apply {
    Write-Host "  Applying gaming tweaks..." -ForegroundColor Cyan

    # mouse
    Set-Reg 'HKCU:\Control Panel\Mouse' 'MouseSpeed'      '0'  String
    Set-Reg 'HKCU:\Control Panel\Mouse' 'MouseThreshold1' '0'  String
    Set-Reg 'HKCU:\Control Panel\Mouse' 'MouseThreshold2' '0'  String

    # keyboard
    Set-Reg 'HKCU:\Control Panel\Keyboard' 'KeyboardDelay' '0'  String
    Set-Reg 'HKCU:\Control Panel\Keyboard' 'KeyboardSpeed' '31' String

    # game dvr
    Set-Reg 'HKCU:\System\GameConfigStore' 'GameDVR_Enabled' 0 DWord
    Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' 'AppCaptureEnabled' 0 DWord
    Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR' 'AllowGameDVR' 0 DWord

    # background store apps
    Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' 'LetAppsRunInBackground' 2 DWord

    # game mode
    Set-Reg 'HKCU:\Software\Microsoft\GameBar' 'AutoGameModeEnabled' 1 DWord

    # gpu scheduling
    Set-Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' 'HwSchMode' 2 DWord

    # mmcss
    $mm = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile'
    Set-Reg $mm 'SystemResponsiveness' 10 DWord
    Set-Reg "$mm\Tasks\Games" 'GPU Priority'        8      DWord
    Set-Reg "$mm\Tasks\Games" 'Priority'            6      DWord
    Set-Reg "$mm\Tasks\Games" 'Scheduling Category' 'High' String
    Set-Reg "$mm\Tasks\Games" 'SFIO Priority'       'High' String

    # power plan
    $cur = [regex]::Match((powercfg /getactivescheme), '[0-9a-fA-F-]{36}').Value
    $saved['POWER'] = @{ old = $cur }
    powercfg /setactive $GUID_HIGH 2>$null

    $saved | ConvertTo-Json -Depth 6 | Set-Content $backup -Encoding UTF8
    Write-Host "  Done. Reboot recommended." -ForegroundColor Green
}

function Restore {
    if (-not (Test-Path $backup)) { Write-Host "  No backup found." -ForegroundColor Yellow; return }
    $data = Get-Content $backup -Raw | ConvertFrom-Json
    foreach ($k in $data.PSObject.Properties.Name) {
        $e = $data.$k
        if ($k -eq 'POWER') { powercfg /setactive $e.old 2>$null; continue }
        try {
            if ($e.existed) { New-ItemProperty $e.path -Name $e.name -Value $e.old -PropertyType $e.type -Force | Out-Null }
            else             { Remove-ItemProperty $e.path -Name $e.name -ErrorAction SilentlyContinue }
        } catch {}
    }
    Remove-Item $backup -ErrorAction SilentlyContinue
    Write-Host "  Restored. Reboot recommended." -ForegroundColor Green
}

Write-Host "`n  Gaming Tweaks" -ForegroundColor Cyan
Write-Host "  ─────────────────────────────────────────────────"
Write-Host "  [1] Apply    [2] Restore    [0] Back"
switch (Read-Host "  Select") {
    '1' { Apply   }
    '2' { Restore }
}
