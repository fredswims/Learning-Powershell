$pwsh = "C:\Program Files\PowerShell\7\pwsh.exe"
$winx = Join-Path $env:LOCALAPPDATA "Microsoft\Windows\WinX\Group3"

# The two Win+X entries you want to replace
$targets = @(
    "01a - Windows PowerShell.lnk",
    "02a - Windows PowerShell.lnk"
)

# Remove old shortcuts
foreach ($t in $targets) {
    $path = Join-Path $winx $t
    if (Test-Path $path) {
        Remove-Item $path -Force
    }
}

# Function to create a .lnk file
function New-Shortcut {
    param(
        [string]$ShortcutPath,
        [string]$TargetPath,
        [switch]$RunAsAdmin
    )

    $ws = New-Object -ComObject WScript.Shell
    $sc = $ws.CreateShortcut($ShortcutPath)
    $sc.TargetPath = $TargetPath
    $sc.WorkingDirectory = Split-Path $TargetPath
    $sc.IconLocation = "$TargetPath,0"
    $sc.Save()

    if ($RunAsAdmin) {
        # Set "Run as administrator" flag in the .lnk file
        $bytes = [System.IO.File]::ReadAllBytes($ShortcutPath)
        $bytes[0x15] = $bytes[0x15] -bor 0x20
        [System.IO.File]::WriteAllBytes($ShortcutPath, $bytes)
    }
}

# Create new shortcuts
New-Shortcut -ShortcutPath (Join-Path $winx "01a - Windows PowerShell.lnk") -TargetPath $pwsh
New-Shortcut -ShortcutPath (Join-Path $winx "02a - Windows PowerShell.lnk") -TargetPath $pwsh -RunAsAdmin

Write-Host "Done. Restart Explorer for changes to take effect."