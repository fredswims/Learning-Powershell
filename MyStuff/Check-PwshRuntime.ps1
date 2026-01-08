Clear-Host
Write-Warning "In function $($MyInvocation.MyCommand.Name):"
$PSCommandPath

$PSVersionTable
$PSVersionTable
Get-Process | Select-Object -First 5
$PSVersionTable
(Get-Process -Id $PID).Path


# Demo: Show PowerShell runtime details
Write-Host "=== PowerShell Runtime Info ==="
Write-Host "Version Table:"
$PSVersionTable

Write-Host "`nExecutable Path:"
(Get-Process -Id $PID).Path

Write-Host "`nProcess Name:"
(Get-Process -Id $PID).ProcessName

Write-Host "`nSession PID:"
$PID

# Demo: Identify PowerShell runtime with a banner
$exePath = (Get-Process -Id $PID).Path
$version = $PSVersionTable.PSVersion.ToString()

if ($exePath -like "*7-preview*") {
    Write-Host "=============================" -ForegroundColor Yellow
    Write-Host " RUNNING IN POWERsHELL PREVIEW " -ForegroundColor Yellow
    Write-Host " Version: $version" -ForegroundColor Yellow
    Write-Host " Path: $exePath" -ForegroundColor Yellow
    Write-Host "=============================" -ForegroundColor Yellow
}
elseif ($exePath -like "*\PowerShell\7\pwsh*") {
    Write-Host "=============================" -ForegroundColor Green
    Write-Host " RUNNING IN POWERSHELL STABLE  " -ForegroundColor Green
    Write-Host " Version: $version" -ForegroundColor Green
    Write-Host " Path: $exePath" -ForegroundColor Green
    Write-Host "=============================" -ForegroundColor Green
}
else {
    Write-Host "=============================" -ForegroundColor Cyan
    Write-Host " UNKNOWN POWERSHELL RUNTIME    " -ForegroundColor Cyan
    Write-Host " Version: $version" -ForegroundColor Cyan
    Write-Host " Path: $exePath" -ForegroundColor Cyan
    Write-Host "=============================" -ForegroundColor Cyan
}