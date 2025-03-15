[CmdletBinding()]
param (
    [Parameter()]
    [switch]$NoExit
)
write-host "its me"
if ($NoExit) {
    Read-Host "Press Enter to exit"
}