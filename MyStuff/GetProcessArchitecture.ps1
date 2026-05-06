# Add-Type -Path .\ProcArch.cs

function Get-ProcessArchitecture {
    param([int]$Id)

    $p = Get-Process -Id $Id -ErrorAction Stop
    $h = $p.Handle

    # Declare output variables BEFORE using [ref]
    $pm = 0
    $nm = 0

    $ok = [Win32.ProcArch]::IsWow64Process2($h, [ref]$pm, [ref]$nm)
    if (-not $ok) {
        throw "IsWow64Process2 failed: $([Runtime.InteropServices.Marshal]::GetLastWin32Error())"
    }

    $map = @{
        0x014c = "x86"
        0x8664 = "x64"
        0x01c0 = "ARM"
        0x01c4 = "ARMv7"
        0xaa64 = "ARM64"
        0x0000 = "Native"
    }

    [pscustomobject]@{
        ProcessId            = $Id
        ProcessArchitecture  = $map[$pm]
        NativeOSArchitecture = $map[$nm]
    }
}
# Get-ProcessArchitecture -Id (Get-Process notepad).Id