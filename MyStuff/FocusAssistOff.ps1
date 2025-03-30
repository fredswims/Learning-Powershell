# https://www.youtube.com/watch?v=pXTbBXwVRiQ
# + for the Shift key
# ^ for the Ctrl key
# % for the Alt key

# Focus Assist Off
# https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms?view=windowsdesktop-9.0
add-Type -AssemblyName System.Windows.Forms
# https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.sendkeys?view=windowsdesktop-9.0&form=MG0AV3
# invoke sendwait method in the class.
[System.Windows.Forms.SendKeys]::SendWait("(^{ESC})")
Start-Sleep -Milliseconds 2000
[System.Windows.Forms.SendKeys]::SendWait("(Focus Settings)")
Start-Sleep -Milliseconds 2000
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
Start-Sleep -Milliseconds 2000
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

# [System.Windows.Forms.SendKeys]::SendWait("{TAB}{TAB}")
Start-Sleep -Milliseconds 2000
[System.Windows.Forms.SendKeys]::SendWait("(%{F4})")

<# 
Here is an alternate method using a URI.
https://support.microsoft.com/en-us/windows/ms-settings:quiethours
Place this in browser:
ms-settings:quiethours

You can find a comprehensive list of URI schemes for Windows 11 that allow you to 
open specific settings pages and apps directly. 
Here are some resources that provide detailed lists of these URIs:

1. [Pureinfotech](https://pureinfotech.com/windows-11-mssettings-uri-commands/): This guide 
shows every command to open settings pages on Windows 11 using the `ms-settings` URI scheme.

2. [Winaero](https://winaero.com/windows-11-uri-commands-to-launch-apps-directly/): 
This article includes a full list of URI commands to launch Windows 11 apps directly.

3. [Windows OS Hub](https://woshub.com/ms-settings-uri-commands-windows-11/): 
This article provides a complete list of `ms-settings` URI commands for Windows 11.

These resources will help you discover and use the various URI schemes available in Windows 11. 
If you have any other questions or need further assistance, feel free to ask!



 #>
<# 
# Create a new thread to handle the SendKeys operation
$sendKeysAction = {
    [System.Windows.Forms.SendKeys]::SendWait("^{ESC}")
}

$thread = [System.Threading.Thread]::New($sendKeysAction)
$thread.Start()
$thread.Join()
 #>
<# 
Use reflection to get the methods of the SendKeys class.
This script uses reflection to list the names of all methods within the SendKeys class.
    [System.Windows.Forms.SendKeys].GetMethods() | ForEach-Object { $_.Name }


 It's not unusual, actually. 
 When you use `Get-Member`, you're seeing all the methods and properties inherited from the base classes 
 as well as interfaces implemented by `[System.Windows.Forms.SendKeys]`. That's why the list is much longer.
    $methods=[System.Windows.Forms.SendKeys] | Get-Member -type All |format-table name

The `SendWait` method is specific to the `SendKeys` class itself, 
but there are many methods that come from the underlying classes in the .NET framework hierarchy. 
These include fundamental methods like `ToString`, `Equals`, `GetHashCode`, and others, 
which are part of the basic `System.Object` class or other base classes.

Here's a quick summary of what's happening:
- **`Get-Member`**: Lists all members (methods, properties, etc.), including those inherited from base classes.
- **Reflection (`GetMethods`)**: Allows you to see the specific methods defined in the
`SendKeys` class, including `SendWait`.

In this case, reflection helped pinpoint the exact methods defined in the `SendKeys` class 
without including inherited members, which is why you were able to find `SendWait` there.

If you have any further questions or need more details, feel free to ask!

You can use reflection in PowerShell to list all the classes within the System.Windows.Forms assembly. 
Here's how you can do it:

Add-Type -AssemblyName System.Windows.Forms

# Get the assembly
$assembly = [System.Windows.Forms.SendKeys].Assembly

# List all the types (classes) in the assembly
$assembly.GetTypes() | Where-Object { $_.IsClass } | Select-Object FullName

You're very welcome!

Yes, the `System.Windows.Forms` assembly is indeed part of the .NET Framework. 
It is part of the Windows Forms library, which is used for creating graphical user interface (GUI) applications. 
Windows Forms provides a wide range of controls and components for building Windows desktop applications.

Windows Forms is primarily used in .NET Framework, 
but it is also supported in .NET Core and .NET 5+ through the Windows Compatibility Pack, 
which allows you to run Windows Forms applications on the latest versions of .NET.

If you have any more questions about .NET or anything else, feel free to ask!

For developing an application for Windows 11 ARM64, 
you have several excellent options. 
Here are a few frameworks that are well-suited for this purpose:

1. **WPF (Windows Presentation Foundation)**: 
WPF is a powerful framework for building Windows desktop applications with rich user interfaces. 
It supports ARM64 and provides a modern approach to UI development using XAML and the MVVM pattern.

2. **.NET MAUI (Multiplatform App UI)**: 
.NET MAUI is a cross-platform framework that allows you to build applications for 
Windows, macOS, iOS, and Android using a single codebase. 
It supports ARM64 and is a great choice if you want to target multiple platforms.

3. **WinUI 3**: 
WinUI 3 is the latest UI framework from Microsoft for building modern, 
native Windows applications. 
It provides a rich set of controls and supports ARM64, making it a good choice for Windows 11 applications.

4. **UWP (Universal Windows Platform)**:
 UWP allows you to create applications that run on a wide range of Windows devices, 
 including ARM64. It provides a unified platform for building responsive and touch-friendly interfaces.

5. **Qt**: 
Qt is a C++ framework for creating cross-platform applications with rich graphical user interfaces. 
It supports ARM64 and is widely used in various industries.

Each of these frameworks has its strengths and use cases. If you have specific requirements or preferences, 
I can help you explore further and find the best fit for your project. Just let me know!

: [CodeProject](https://www.codeproject.com/Articles/5368162/Implementing-Desktop-Apps-with-Windows-11-on-Arm64)
: [Visual Studio Magazine](https://visualstudiomagazine.com/articles/2024/02/13/desktop-dev.aspx)


 #>