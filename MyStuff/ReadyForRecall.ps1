
# Check Windows Version
$winVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
Write-Host "Windows Version: $winVersion"

# Check RAM
$ram = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB
Write-Host "Installed RAM: $([math]::Round($ram, 2)) GB"

# Check Storage
$drive = Get-PSDrive -Name C
Write-Host "Total Storage: $([math]::Round((($drive.Used + $drive.Free) / 1GB), 2)) GB"
Write-Host "Free Storage: $([math]::Round($drive.Free / 1GB, 2)) GB"

# Check for NPU (Neural Processing Unit)
$npu = Get-CimInstance Win32_PnPEntity | Where-Object { $_.Name -like "*NPU*" }
if ($npu) {
    Write-Host "NPU Detected: $($npu.Name)"
} else {
    Write-Host "No NPU detected"
}

<# 
# Check BitLocker or Device Encryption
$bitlocker = Get-BitLockerVolume -MountPoint "C:"
if ($bitlocker.ProtectionStatus -eq "On") {
    Write-Host "BitLocker is enabled"
} else {
    Write-Host "BitLocker is NOT enabled"
}

 #>
# Check for Device Encryption (if available)
$encryptionStatus = Get-CimInstance -Namespace "root\CIMV2\Security\MicrosoftVolumeEncryption" -ClassName Win32_EncryptableVolume -ErrorAction SilentlyContinue
if ($encryptionStatus) {
    $protection = $encryptionStatus.ProtectionStatus
    if ($protection -eq 1) {
        Write-Host "Device Encryption is enabled"
    }
    else {
        Write-Host "Device Encryption is NOT enabled"
    }
}
else {
    Write-Host "Device Encryption not supported or not available"
}



<# 
# Check for Windows Hello (Biometric)
$hello = Get-WmiObject -Namespace root\cimv2\mdm\dmmap -Class MDM_Policy_Config01_Authentication
if ($hello.RequireBiometric -eq 1) {
    Write-Host "Windows Hello Biometric is enabled"
} else {
    Write-Host "Windows Hello Biometric is NOT enabled"
}

 #>
# Check for Biometric Devices (Windows Hello)
$biometric = Get-PnpDevice | Where-Object { $_.FriendlyName -like "*Fingerprint*" -or $_.FriendlyName -like "*Face*" }
if ($biometric) {
    Write-Host "Biometric device detected: $($biometric.FriendlyName)"
} else {
    Write-Host "No biometric device detected"
}
