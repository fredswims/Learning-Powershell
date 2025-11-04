<#
    How to enable and disable the builtin camera or for that matter any pnp device
    https://www.dynamsoft.com/codepool/powershell-disable-enable-webcam-windows.html
    $thisScript = $(join-path $env:onedrive PowershellScripts\MyStuff EnableDisableCamera.ps1 -Resolve)
    # splat the arguments to start-process and use 'Argumentlist' parameters as array to avoid quoting issues.
    $splat = @{
        FilePath     = "pwsh"
        Verb         = "RunAs"
        ArgumentList = @(
            "-NoProfile",
            "-NoExit",
            "-File", $thisScript,
            "-type", $Action
        )
    }
    $json = $splat | ConvertTo-Json -Depth 3
    Write-Output $json

    Start-Process @splat
    Remove-Variable thisScript
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
write-host ( $(get-date -format yyyy-MM-dd' 'HH:mm:ss) )
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
