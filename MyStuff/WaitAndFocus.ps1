Function fred {
$hwnd = [Win32]::GetForegroundWindow()
write-host "hwnd is $hwnd"

# Save the current window title
$originalTitle = $Host.UI.RawUI.WindowTitle

# Launch the new PowerShell process and wait for it to exit
# Start-Process -FilePath "notepad.exe" -ArgumentList -'Noprofile',  -Wait
$myprocess = start-process -FilePath notepad -passthru -Verbose
        #if ($Priority) { $MyProcess.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::AboveNormal }
        $Myprocess.WaitForExit()

# Maximize the original window using .NET
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Win32 {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
}
"@

[Win32]::ShowWindow($hwnd, 3) # 3 is the code for SW_MAXIMIZE
[win32]::SetForegroundWindow($hwnd) #puts cursor in windows
}