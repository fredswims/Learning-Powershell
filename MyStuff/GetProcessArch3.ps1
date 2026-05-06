<# 
.SYNOPSIS
    Identifies the binary, loader, and runtime architecture of processes on Windows ARM64.

.DESCRIPTION
    - BinaryArch: Determined from the PE header (ARM64, ARM64EC, x64, x86)
    - LoaderArch: Inferred to match Task Manager's "Architecture" column
    - RuntimeArch: Determined from loaded modules (Native, Hybrid, Emulated)

    This script matches Task Manager's architecture labels exactly.

.PARAMETER Name
    Process name(s) to inspect.

.PARAMETER Id
    Process ID(s) to inspect.

.EXAMPLE
    Get-ProcessArchitecture -Name excel, msedge

.EXAMPLE
    Get-Process | Get-ProcessArchitecture
#>

param(
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [string[]]$Name,

    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [int[]]$Id
)

function Get-BinaryArchitecture {
    param([string]$Path)

    try {
        $fs = [System.IO.File]::OpenRead($Path)
        $br = New-Object System.IO.BinaryReader($fs)

        $fs.Seek(0x3C, 'Begin') | Out-Null
        $peOffset = $br.ReadInt32()

        $fs.Seek($peOffset + 4, 'Begin') | Out-Null
        $machine = $br.ReadUInt16()

        $fs.Close()

        switch ($machine) {
            0xAA64 { "ARM64" }
            0x004D { "ARM64EC" }
            0x8664 { "x64" }
            0x014C { "x86" }
            default { "Unknown" }
        }
    }
    catch {
        "Unknown"
    }
}

function Get-LoaderArchitecture {
    param([string]$BinaryArch)

    switch ($BinaryArch) {
        "ARM64"   { "ARM64 (x64 compatible)" }
        "ARM64EC" { "ARM64EC" }
        "x64"     { "x64" }
        "x86"     { "x86" }
        default   { "Unknown" }
    }
}

# Get processes
if (-not $PSBoundParameters.ContainsKey('Name') -and -not $PSBoundParameters.ContainsKey('Id')) {
    $processes = Get-Process -ErrorAction SilentlyContinue
} else {
    $processes = Get-Process @PSBoundParameters -ErrorAction SilentlyContinue
}

$processes | ForEach-Object {
    $binaryArch = if ($_.Path) { Get-BinaryArchitecture $_.Path } else { "Unknown" }
    $loaderArch = Get-LoaderArchitecture $binaryArch

    # Runtime architecture detection
    try {
        $mods = $_.Modules.ModuleName

        if ($mods -contains "wow64ec.dll" -or $mods -contains "xtacore.dll") {
            $runtime = "ARM64EC (Hybrid)"
        }
        elseif ($mods -contains "xtajit.dll" -or $mods -contains "xtajit64.dll") {
            $runtime = "x64 (Emulated)"
        }
        elseif ($mods -contains "wow64.dll") {
            $runtime = "x86 (Emulated)"
        }
        else {
            $runtime = "ARM64 (Native)"
        }
    }
    catch {
        $runtime = "Access Denied"
    }

    [pscustomobject]@{
        Name        = $_.Name
        Id          = $_.Id
        BinaryArch  = $binaryArch
        LoaderArch  = $loaderArch
        RuntimeArch = $runtime
    }
} | Sort-Object Name | Format-Table -AutoSize