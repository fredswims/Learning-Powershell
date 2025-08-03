



 <# 
   cd hklm:
   set-location HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList
   gci . -rec -ea SilentlyContinue | % { if((get-itemproperty -Path $_.PsPath) -match "Super Computer") { write-host "$_.PsPath,$(get-itemproperty -Path $_.PsPath) "} }

 #>

###################################################################### 
## 
## Search-RegistryKeyValues.ps1 
## Search the registry keys from the current location and down for a 
## given key value. 
## 
######################################################################
<# 
$searchText = "Super Computer"
$searchText = "VAIOFRED"

gci . -recURSE -ErrorAction SilentlyContinue |  
   % {  
      if((get-itemproperty -Path $_.PsPath) -match $searchText ) 
      {  
         write-host "Path>>>>"
         write-host $_.PsPath -BackgroundColor Yellow -foregroundcolor DarkRed
         write-host "<<<<"
         write-host "vvvvvvvVVVVVVVVV"
         $temp=get-itemproperty -Path $_.PsPath
         write-host $temp
         write-host "^^^^^^^^^^^^^^^^^^^^^^^"
      }  
   } 

 #>

 #not sure what this is:
 <# 
   @{ProfileImagePath=C:\Users\Super Computer; Flags=0; State=0; Sid=System.Byte[]; FullProfile=1; Migrate
d=System.Byte[]; ProfileAttemptedProfileDownloadTimeLow=0; ProfileAttemptedProfileDownloadTimeHigh=0; P
rofileLoadTimeLow=0; ProfileLoadTimeHigh=0; RunLogonScriptSync=0; PSPath=Microsoft.PowerShell.Core\Regi
stry::HKEY_LOCAL_MACHINE\software\microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-21-266193764-12
42674347-2670217995-1000; PSParentPath=Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\software\
microsoft\Windows NT\CurrentVersion\ProfileList; PSChildName=S-1-5-21-266193764-1242674347-2670217995-1
000; PSProvider=Microsoft.PowerShell.Core\Registry}
 #>

 <#
Ah, the stealthy touch of installers past.
That registry entry under App Paths is almost certainly the work of the PowerShell MSI installer (or winget/msix if used). 
It’s designed to make launching pwsh.exe easier from 
places like the Run box or Start search — bypassing PATH entirely.
Most Microsoft installers for CLI tools, especially PowerShell Core, include logic to: 
Register pwsh. exe under HKLM: \SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths. 
Optionally add it to PATH, depending on install options or elevation.
Sometimes skip PATH entirely if installed per-user or with limited elevation It's sneaky but well-intentioned.
The tradeoff, as you've seen, is that it can short- circuit your own launcher logic or alias preferences.

If you'd rather take back control:

Option 1: Remove the Registry Entry
Pros: 
   Clears the override entirely. 
   Forces the system to fall back to resolving pwsh.exe via PATH.
Cons: 
   Might make the Run box or Start search bar stop resolving pwsh, 
   if the preview version isn't registered or isn't early enough in Command:

Option 2: Edit the Registry to Point to Preview
Pros: 
   Keeps Run box functionality intact.
   Ensures consistent behavior regardless of PATH order. 
Cons:
   Could be undone by future updates or reinstalls of the standard version.
#>


# Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\pwsh.exe"
# Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\pwsh.exe"
<# 
Set-ItemProperty `
  -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\pwsh.exe" `
  -Name "(Default)" `
  -Value "C:\Program Files\PowerShell\7-preview\pwsh.exe"

 #>
 
$targetPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\pwsh.exe"
$expectedValue = "C:\Program Files\PowerShell\7-preview\pwsh.exe"

$currentValue = (Get-ItemProperty -Path $targetPath -Name '(Default)').'(default)'

if ($currentValue -ne $expectedValue) {
    Write-Host "🔄 Updating registry value: '$currentValue' ➡ '$expectedValue'"
    Set-ItemProperty -Path $targetPath -Name '(Default)' -Value $expectedValue
} else {
    Write-Host "✅ Registry already points to preview: '$expectedValue'"
}
