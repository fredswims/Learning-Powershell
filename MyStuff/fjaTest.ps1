$code = @'
using System;
using System.Runtime.InteropServices;

public static class ProcArch {
    [DllImport("kernel32.dll", SetLastError=true, CallingConvention=CallingConvention.Winapi)]
    public static extern bool IsWow64Process2(
        IntPtr hProcess,
        out ushort processMachine,
        out ushort nativeMachine
    );
}
'@

$code.ToCharArray() | ForEach-Object {
    '{0} {1}' -f $_, [int]$_
}