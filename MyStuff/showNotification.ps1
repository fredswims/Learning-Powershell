function Show-Notification {
    param (
        [string]$ToastTitle,
        [string]$ToastText
    )

    $libpath= "C:\Users\freds\OneDrive\PowershellScripts\MyStuff\packages\System.Reflection.TypeExtensions.4.7.0\lib\netstandard2.0\System.Reflection.TypeExtensions.dll"
    test-path $libpath

# Define the path to the DLL
$libpath = "C:\Users\freds\OneDrive\PowershellScripts\MyStuff\packages\System.Reflection.TypeExtensions.4.7.0\lib\netstandard2.0\System.Reflection.TypeExtensions.dll"

# Verify the DLL exists
if (-Not (Test-Path $libpath)) {
    Write-Error "DLL not found at $libpath"
    exit
}

# Load the assembly
try {
    [System.Reflection.Assembly]::LoadFrom($libpath)
    Write-Host "Successfully loaded $libpath"
} catch {
    Write-Error "Failed to load assembly: $_"
    exit}
    
    $assembly = [System.Reflection.Assembly]::LoadFrom($libpath)
    $assembly.GetName().ProcessorArchitecture
    [System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription
    $assembly = [System.Reflection.Assembly]::LoadFrom($libpath)
    $assembly.GetReferencedAssemblies()
    # Add-Type -Path $libpath
    $assembly = [System.Reflection.Assembly]::LoadFrom($libpath)
    [System.Runtime.Loader.AssemblyLoadContext]::Default.LoadFromAssemblyPath($libpath)
    # Load Windows.UI.Notifications
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null

    # Create Toast Notification XML
    $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
    $RawXml = [xml]$Template.GetXml()

    # Set Title and Text
    ($RawXml.toast.visual.binding.text | Where-Object { $_.id -eq "1" }).AppendChild($RawXml.CreateTextNode($ToastTitle)) > $null
    ($RawXml.toast.visual.binding.text | Where-Object { $_.id -eq "2" }).AppendChild($RawXml.CreateTextNode($ToastText)) > $null

    # Convert XML to Toast Notification
    $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $SerializedXml.LoadXml($RawXml.OuterXml)
    $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)

    # Set Expiration Time
    $Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)

    # Show Notification
    $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell")
    $Notifier.Show($Toast)
}

# Example Usage
Show-Notification -ToastTitle "PowerShell Alert" -ToastText "This is a test notification!"

# hererere
$assembly = [System.Reflection.Assembly]::LoadFrom($libpath)
$assembly.GetName().ProcessorArchitecture
[System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription
$assembly = [System.Reflection.Assembly]::LoadFrom($libpath)
$assembly.GetReferencedAssemblies()
# Add-Type -Path $libpath
$assembly = [System.Reflection.Assembly]::LoadFrom($libpath)
[System.Runtime.Loader.AssemblyLoadContext]::Default.LoadFromAssemblyPath($libpath)
# Load Windows.UI.Notifications
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null

# Create Toast Notification XML
$Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
$RawXml = [xml]$Template.GetXml()

# Set Title and Text
($RawXml.toast.visual.binding.text | Where-Object { $_.id -eq "1" }).AppendChild($RawXml.CreateTextNode($ToastTitle)) > $null
($RawXml.toast.visual.binding.text | Where-Object { $_.id -eq "2" }).AppendChild($RawXml.CreateTextNode($ToastText)) > $null

# Convert XML to Toast Notification
$SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
$SerializedXml.LoadXml($RawXml.OuterXml)
$Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)

# Set Expiration Time
$Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)

# Show Notification
$Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell")
$Notifier.Show($Toast)


