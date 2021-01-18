function EnableDisableIt{
    <#
    How to enable and disable the builtin camera or for that matter any pnp device
    https://www.dynamsoft.com/codepool/powershell-disable-enable-webcam-windows.html
    If spawned like pwsh -file EnableDisableCamera.ps1 it must be run elevated
    #>
    [CmdletBinding()]
     param (
            [Parameter(Mandatory=$true)]
            [ValidateSet('Status', 'Enable', 'Disable')]
            $Type
     )
    if ($Type -eq "Status") {     
        Get-PnpDevice -FriendlyName *cam*
        write-host ""
        Get-PnpDevice -FriendlyName *cam* -Class camera -Status OK
    }
    if ($Type -eq "Disable") { disable-pnpdevice -InstanceId (Get-PnpDevice -FriendlyName *cam* -Class camera -Status OK).Instanceid }
    if ($Type -eq "Enable") {
        Get-PnpDevice -FriendlyName *cam* -Class camera -Status Error
        enable-pnpdevice -InstanceId (Get-PnpDevice -FriendlyName *cam* -Class camera -Status error).Instanceid
    }
}

