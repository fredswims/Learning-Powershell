function Show-Notification {
    param (
        [string]$ToastTitle,
        [string]$ToastText
    )

    # Define the path to the DLL
    $libpath = "C:\Users\freds\OneDrive\PowershellScripts\MyStuff\packages\System.Reflection.TypeExtensions.4.7.0\lib\netstandard2.0\System.Reflection.TypeExtensions.dll"

    # Verify the DLL exists
    if (-Not (Test-Path $libpath)) {
        Write-Error "DLL not found at $libpath"
        exit
    }

    # Load the assembly
    try {
        $assembly = [System.Reflection.Assembly]::LoadFrom($libpath)
        Write-Host "Successfully loaded $libpath"
    } catch {
        Write-Error "Failed to load assembly: $_"
        exit
    }

    # Check Architecture & .NET Runtime
    Write-Host "Processor Architecture: $($assembly.GetName().ProcessorArchitecture)"
    Write-Host "Runtime Framework: $([System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription)"
    Write-Host "Referenced Assemblies: $($assembly.GetReferencedAssemblies())"

    # Load Windows.UI.Notifications (Use Add-Type for compatibility)
    try {
        Add-Type -TypeDefinition @"
using Windows.UI.Notifications;
using Windows.Data.Xml.Dom;

public class ToastHelper {
    public static void ShowToast(string title, string message) {
        string toastXml = $@"<toast>
            <visual>
                <binding template='ToastGeneric'>
                    <text>{title}</text>
                    <text>{message}</text>
                </binding>
            </visual>
        </toast>";

        XmlDocument doc = new XmlDocument();
        doc.LoadXml(toastXml);

        ToastNotification toast = new ToastNotification(doc);
        ToastNotificationManager.CreateToastNotifier("PowerShell").Show(toast);
    }
}
"@ -Language CSharp
    } catch {
        Write-Error "Failed to load Windows.UI.Notifications: $_"
        exit
    }

    # Trigger Notification
    [ToastHelper]::ShowToast($ToastTitle, $ToastText)
}

# Example Usage
Show-Notification -ToastTitle "PowerShell Alert" -ToastText "This is a test notification!"