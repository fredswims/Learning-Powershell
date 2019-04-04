/#
Meltdown Spectre
Microsoft releases PowerShell script to check if your PC is vulnerable to Meltdown and Spectre
https://betanews.com/2018/01/05/microsoft-powershell-meltdown-spectre-script/#comments
#/

Install-Module SpeculationControl
Import-Module SpeculationControl
Get-SpeculationControlSettings

<#PackageManagement\Install-Package : No match was found for the specified search criteria and module 
name 'speculatoncontrol'. Try Get-PSRepository to see all available registered module repositories.
At C:\Program Files\WindowsPowerShell\Modules\PowerShellGet\1.0.0.1\PSModule.psm1:1809 char:21
+ ...          $null = PackageManagement\Install-Package @PSBoundParameters
+                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (Microsoft.Power....InstallPackage:InstallPackage) [Ins 
   tall-Package], Exception
    + FullyQualifiedErrorId : NoMatchFoundForCriteria,Microsoft.PowerShell.PackageManagement.Cmdlets. 
   InstallPackage
   #>

   Get-PSRepository 
   find-module SpeculationControl
