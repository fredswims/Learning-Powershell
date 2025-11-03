<#
    How to enable and disable the builtin camera or for that matter any pnp device
    https://www.dynamsoft.com/codepool/powershell-disable-enable-webcam-windows.html
    If spawned like pwsh -file EnableDisableCamera.ps1 it must be run elevated
    Escape quote the string if it has literal spaces in it.
    start-process -Verb "Runas" -Filepath "pwsh" -ArgumentList "-noprofile -noexit `
     -command & {. `"C:\Users\freds_000\OneDrive\PowershellScripts\MyStuff\EnableDisableCamera.ps1`" -type status}"

    start-process -Verb "Runas" -Filepath "pwsh" -ArgumentList "-noprofile -noexit `
     -command & {. `"$thisRun`" -type status}" 

     start-process -Verb "Runas" -Filepath "pwsh" -ArgumentList "-noprofile -noexit `
-command & {. `"(join-path -path $env:onedrive\PowershellScripts\MyStuff -childpath EnableDisableCamera.ps1)`" -type status}"

    #>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateSet('Status', 'Enable', 'Disable')]
    $Type
)

function ShowStatus {
    Get-PnpDevice -FriendlyName *cam*
    write-host ""
    #Get-PnpDevice -FriendlyName *cam* -Class camera -Status OK
}
Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$PSCommandPath

if ($Type -eq "Status") {
    ShowStatus
}
if ($Type -eq "Disable") {
    ShowStatus
    disable-pnpdevice -InstanceId (Get-PnpDevice -FriendlyName *cam* -Class camera -Status OK).Instanceid 
    #Get-PnpDevice -FriendlyName *cam*  
    ShowStatus
}

if ($Type -eq "Enable") {
    ShowStatus
    #Get-PnpDevice -FriendlyName *cam* -Class camera -Status Error
    enable-pnpdevice -InstanceId (Get-PnpDevice -FriendlyName *cam* -Class camera -Status error).Instanceid
    #Get-PnpDevice -FriendlyName *cam*
    ShowStatus
}
