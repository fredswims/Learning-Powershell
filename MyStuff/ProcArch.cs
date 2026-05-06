using System;
using System.Runtime.InteropServices;

namespace Win32
{
    public static class ProcArch
    {
        [DllImport("kernel32.dll", SetLastError=true, CallingConvention=CallingConvention.Winapi)]
        public static extern bool IsWow64Process2(
            IntPtr hProcess,
            out ushort processMachine,
            out ushort nativeMachine
        );
    }
}