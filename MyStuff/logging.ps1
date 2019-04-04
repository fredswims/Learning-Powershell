<#
references
https://social.technet.microsoft.com/Forums/lync/en-US/70cbf2aa-b136-4d69-bb8f-3cec0fe18d7f/how-to-redirect-verbose-to-the-log-file?forum=winserverpowershell

https://social.technet.microsoft.com/Forums/windowsserver/en-US/8d989cc1-5f50-4e67-9d5d-87458421fefb/being-verbose-when-running-a-script?forum=winserverpowershell

******
https://gallery.technet.microsoft.com/scriptcenter/Enhanced-Script-Logging-27615f85#content

https://gallery.technet.microsoft.com/scriptcenter/Enhanced-Script-Logging-27615f85/view/Discussions#content

https://stackoverflow.com/questions/49326056/how-to-generate-comprehensive-log-file-from-powershell-script

some things i tried
$VerbosePreference="Silentlycontinue" set to continue
$DebugPreference="Silentlycontinue"   set to continue

invoke the script with this 
Powershell .\fred.ps1 *> ellen.log
and include in the first line 
$PSDefaultParameterValues['*:Verbose'] = $true

$LogFile = Enable-LogFile -Path $env:temp\test.log
....
$logFile | disable-logfile
 
#>
Import-Module PowerShellLogging 
 
$LogFile = Enable-LogFile -Path $env:temp\test.log 
 
# Note - it is necessary to save the result of Enable-LogFile to a variable in order to keep the object alive.  As soon as the $LogFile variable is reassigned or falls out of scope, the LogFile object becomes eligible for garbage collection. 
 
$VerbosePreference = 'Continue' 
$DebugPreference = 'Continue' 

$PSDefaultParameterValues['*:Verbose'] = $true

Set-Location $env:temp

Get-ChildItem *.tmp
new-item fred
new-item fred.txt
new-item fred1
remove-item fred*

new-item fred
Copy-Item fred ellen
remove-item ellen
test-path fred

$logFile | disable-logfile


