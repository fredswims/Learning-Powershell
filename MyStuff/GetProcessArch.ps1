
<#
.SYNOPSIS
    Identifies the architecture of running processes on Windows ARM64.

.DESCRIPTION
    This script checks for specific emulation modules (xtajit.dll or wow64.dll) to determine 
    if a process is running as x64 Emulated, x86 Emulated, or Native ARM64. 
    By default, it filters out native ARM64 processes to show only emulated apps.

.PARAMETER Name
    The name(s) of the processes to check.

.PARAMETER Id
    The unique process ID(s) to check.

.EXAMPLE
    .\Get-ProcessArchitecture.ps1 -Name "notepad", "KeePass"
    Returns the architecture for Notepad and KeePass if they are emulated.

.EXAMPLE
    .\Get-ProcessArchitecture.ps1
    Returns all emulated processes currently running on the system.
#>
param(
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [string[]]$Name,

    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [int[]]$Id
)

# If no parameters are provided, get all processes; otherwise, use the provided filters
if (-not $PSBoundParameters.ContainsKey('Name') -and -not $PSBoundParameters.ContainsKey('Id')) {
    $processes = Get-Process -ErrorAction SilentlyContinue
} else {
    $processes = Get-Process @PSBoundParameters -ErrorAction SilentlyContinue
}

$processes | Select-Object Name, Id, @{Name="Architecture"; Expression={
    try {
        $mods = $_.Modules.ModuleName

        if ($mods -contains "wow64ec.dll" -or $mods -contains "xtacore.dll") {
            "ARM64EC (Hybrid)"
        }
        elseif ($mods -contains "xtajit.dll" -or $mods -contains "xtajit64.dll") {
            "x64 (Emulated)"
        }
        elseif ($mods -contains "wow64.dll") {
            "x86 (Emulated)"
        }
        else {
            "ARM64 (Native)"
        }
    } catch {
        "Access Denied"
    }
}} | Sort-Object Architecture