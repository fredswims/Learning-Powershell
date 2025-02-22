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
# Create a new thread to handle the SendKeys operation
$sendKeysAction = {
    [System.Windows.Forms.SendKeys]::SendWait("^{ESC}")
}

$thread = [System.Threading.Thread]::New($sendKeysAction)
$thread.Start()
$thread.Join()
 #>