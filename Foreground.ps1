    #Bring this console to the foreground
     function Show-Process($Process, [Switch]$Maximize) {
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
    #Set-PSDebug -Step
    Show-Process -Process (get-process -id $pid) -Maximize  


    Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class Tricks {
     [DllImport("user32.dll")]
     [return: MarshalAs(UnmanagedType.Bool)]
     public static extern bool SetForegroundWindow(IntPtr hWnd);
  }
"@
sleep -sec 2
$h = (Get-Process notepad2).MainWindowHandle
[void] [Tricks]::SetForegroundWindow($h)
sleep -sec 10
$h = (Get-Process -id $pid).MainWindowHandle
[void] [Tricks]::SetForegroundWindow($h)