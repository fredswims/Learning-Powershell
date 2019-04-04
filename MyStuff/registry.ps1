



 
   cd hklm:
   set-location HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList
   gci . -rec -ea SilentlyContinue | % { if((get-itemproperty -Path $_.PsPath) -match "Super Computer") { write-host "$_.PsPath,$(get-itemproperty -Path $_.PsPath) "} }



###################################################################### 
## 
## Search-RegistryKeyValues.ps1 
## Search the registry keys from the current location and down for a 
## given key value. 
## 
######################################################################
$searchText = "Super Computer"

gci . -rec -ea SilentlyContinue |  
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


   @{ProfileImagePath=C:\Users\Super Computer; Flags=0; State=0; Sid=System.Byte[]; FullProfile=1; Migrate
d=System.Byte[]; ProfileAttemptedProfileDownloadTimeLow=0; ProfileAttemptedProfileDownloadTimeHigh=0; P
rofileLoadTimeLow=0; ProfileLoadTimeHigh=0; RunLogonScriptSync=0; PSPath=Microsoft.PowerShell.Core\Regi
stry::HKEY_LOCAL_MACHINE\software\microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-21-266193764-12
42674347-2670217995-1000; PSParentPath=Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\software\
microsoft\Windows NT\CurrentVersion\ProfileList; PSChildName=S-1-5-21-266193764-1242674347-2670217995-1
000; PSProvider=Microsoft.PowerShell.Core\Registry}
