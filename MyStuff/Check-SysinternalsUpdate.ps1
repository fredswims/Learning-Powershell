# push-location C:\Tools\Sysinternals

# The “two 'Sysmon.exe' problem"
# Sysmon is now (2026-02-24) part of Windows 11.
# Prior to the update I installed the MSIX version.
# This resulted in having two instances of sysmon.exe 
#   MSIX version -> sysmon.exe C:\Users\freds\AppData\Local\Microsoft\WindowsApps 02/05/2026 5:15:22 AM
#   New location -> sysmon.exe C:\windows\system32                                02/24/2026 5:52:08 PM
# The new version will be updated thru Check-For-Updates
# The goal is to have only one version.

# remove the STORE version (MSIX) of Systeminternals
# it was previously installed. 
# After the system update two versions of sysmon.exe were present.
# if we don't remove the STORE version, the MSIX version of sysmon.exe will be added/updated repeatedly
Get-AppxPackage *SysinternalsSuite* | Remove-AppxPackage

#region add $path to path if it doesn't exist. Will be correct for future processes.
$path = "C:\Tools\Sysinternals"
$machinePath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
# This ensures you don’t accidentally append the same folder multiple times.
if ($machinePath -notlike "*$path*") {
    setx PATH "$machinePath;$path"
}
#end-region

#region Install the zip version of Sysinternals and look for updates.
$local = (Get-Item "C:\Tools\Sysinternals\*.exe" |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1).LastWriteTime

$remote = (Invoke-WebRequest "https://download.sysinternals.com/files/SysinternalsSuite.zip").Headers["Last-Modified"]

"Local:  $local"
"Remote: $remote"

if ([datetime]$remote -gt $local) {
    "Update available"
} else {
    "Up to date"
}
#end-region





# Pop-Location