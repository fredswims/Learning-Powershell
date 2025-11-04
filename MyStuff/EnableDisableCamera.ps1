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
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            'Status','Enable','Disable'
        })]
        [string]$Action = 'Status'
    )

write-host ( $(get-date -format "dddd yyyy-MM-dd' 'HH:mm:ss K" ) )
write-host -ForegroundColor Yellow "`tExecuting::`t $($PSCommandPath)"
write-host -ForegroundColor Yellow "`tCalled by::`t $($MyInvocation.ScriptName)"
write-host -foregroundcolor yellow "`tInvoked as::`t $($MyInvocation.Line)"

function ShowStatus {
    Get-PnpDevice -FriendlyName *cam*
    write-host ""
    #Get-PnpDevice -FriendlyName *cam* -Class camera -Status OK
}

if ($Action -eq "Status") {
    ShowStatus
}
else {
    Write-host -ForegroundColor RED "Other actions disabled for safety. Edit script to enable."
    return -1
}


if ($Action -eq "Disable") {
    ShowStatus
    # disable-pnpdevice -InstanceId (Get-PnpDevice -FriendlyName *cam* -Class camera -Status OK).Instanceid 
    ShowStatus
}
if ($Action -eq "Enable") {
    ShowStatus
    # enable-pnpdevice -InstanceId (Get-PnpDevice -FriendlyName *cam* -Class camera -Status error).Instanceid
    ShowStatus
}
