Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Audio {
    [DllImport("ole32.dll")]
    public static extern int CoInitializeEx(IntPtr pvReserved, int dwCoInit);
}
"@
[Audio]::CoInitializeEx([IntPtr]::Zero, 2)