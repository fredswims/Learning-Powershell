#http://community.idera.com/powershell/powertips/b/tips/posts/bringing-window-in-the-foreground
#requires -Version 2
function Show-Process($Process, [Switch]$Maximize)
{
  $sig = '
    [DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hwnd);
  '
  
  if ($Maximize) { $Mode = 3 } else { $Mode = 4 }
  $type = Add-Type -MemberDefinition $sig -Name WindowAPI -PassThru
  $hwnd = $process.MainWindowHandle
  $null = $type::ShowWindowAsync($hwnd, $Mode)
  $null = $type::SetForegroundWindow($hwnd) 
}
show-process -Process (get-process -id $pid) -Maximize

#here are a couple of alternates
    #this one minimizes all windows including itself!
    #Bring this console to the foreground
    <#
    $shell = New-Object -ComObject "Shell.Application"
    $shell.minimizeall()
    #>

    <# I haven't tried this one as the first one works really well
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class Tricks {
        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool SetForegroundWindow(IntPtr hWnd);
    }
    "@
    Start-Sleep -Seconds 5
    $h = (Get-Process -id $pid).MainWindowHandle
    [void] [Tricks]::SetForegroundWindow($h)
    #>