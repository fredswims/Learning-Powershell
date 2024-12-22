param (
    [string]$newTitle = "My New Tab"
)

# Define the Windows API function
Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class WinAPI {
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleTitle(string lpConsoleTitle);
    }
"@

# Set the console title
[WinAPI]::SetConsoleTitle($newTitle)

# .\ChangeConsoleTitle.ps1 -newTitle "My Custom Tab"
