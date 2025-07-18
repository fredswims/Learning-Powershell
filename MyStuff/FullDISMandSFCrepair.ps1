# Start a transcript to log output
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logPath = "$env:USERPROFILE\Desktop\DISM_SFC_$timestamp.txt"
Start-Transcript -Path $logPath -NoClobber

Write-Host "`n=== Starting DISM and SFC Repairs ===`n" -ForegroundColor Cyan

# Run DISM commands
$commands = @(
    "DISM /Online /Cleanup-Image /CheckHealth",
    "DISM /Online /Cleanup-Image /ScanHealth",
    "DISM /Online /Cleanup-Image /RestoreHealth"
)

foreach ($cmd in $commands) {
    Write-Host "`nRunning: $cmd" -ForegroundColor Yellow
    Invoke-Expression $cmd
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Command failed: $cmd" -ForegroundColor Red
        break
    }
}

# Run SFC
Write-Host "`nRunning: SFC /scannow" -ForegroundColor Yellow
sfc /scannow

Write-Host "`n=== Repairs Completed ===`n" -ForegroundColor Green
Stop-Transcript



<# 
net stop wuauserv
net stop bits
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
net start wuauserv
net start bits 
#>
