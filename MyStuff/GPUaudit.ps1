# GPU Audit Tool for Snapdragon X Elite (Adreno GPU)

# 1. Basic GPU Info via WMI
Write-Host "`n--- GPU Info via Win32_VideoController ---"
Get-CimInstance Win32_VideoController | Select-Object Name, AdapterRAM, DriverVersion, VideoProcessor

# 2. Shared Memory Details
Write-Host "`n--- Shared Memory Allocation ---"
Get-CimInstance Win32_VideoController | ForEach-Object {
    $ramMB = $_.AdapterRAM / 1MB
    [PSCustomObject]@{
        GPU_Name     = $_.Name
        Shared_RAM_MB = "{0:N0}" -f $ramMB
        Driver       = $_.DriverVersion
        Processor    = $_.VideoProcessor
    }
}

# 3. Optional: Dump dxdiag to temp and parse
$dxdiagPath = "$env:TEMP\dxdiag_output.txt"
Start-Process -FilePath "dxdiag.exe" -ArgumentList "/t $dxdiagPath" -Wait

Write-Host "`n--- DirectX Diagnostics Summary ---"
Get-Content $dxdiagPath | Select-String "Display Devices", "Card name", "Driver Version", "Display Memory", "Shared Memory"

# 4. Cleanup
Remove-Item $dxdiagPath -Force

# Updated PowerShell Snippet: Parse Shared Memory from dxdiag

# Dump dxdiag output to temp file
$dxdiagPath = "$env:TEMP\dxdiag_output.txt"
Start-Process -FilePath "dxdiag.exe" -ArgumentList "/t $dxdiagPath" -Wait

# Parse shared memory info
$gpuInfo = Get-Content $dxdiagPath | Select-String -Pattern "Card name", "Display Memory", "Shared Memory", "Driver Version"

Write-Host "`n--- Parsed GPU Info from dxdiag ---"
$gpuInfo | ForEach-Object { $_.Line }

# Cleanup
Remove-Item $dxdiagPath -Force