function GetParent {
[CmdletBinding()]
param (
    [Parameter()]
    [Int64]$Id,
    [switch]$NoExit=$false
)
    # FAJ 2025-03-28
    $thisErrorCount=$Error.Count
    $thisErrorActionPreference=$ErrorActionPreference
    $ErrorActionPreference='silentlycontinue'
    $parent=$null
    $Parent=get-process -ErrorAction SilentlyContinue -id (get-process -ErrorAction SilentlyContinue  -id $id).parent.id
    if ($Parent.id -gt 0) {
        # 'Parent ID: {0}' -f $parent.id
        '[{1}] [{2:d6}] [{0}] [{3}]' -f $parent.name , $parent.StartTime, $parent.id, $parent.path
        # $parent|Format-Table -HideTableHeaders -AutoSize -Property  id,  starttime, name, path
        $ErrorActionPreference = $thisErrorActionPreference
        if ($thisErrorCount -gt $error.count) {
            $error.Clear()
        }
        # get the next parent
        GetParent $parent.Id
    }
    else {
        if ($thisErrorCount -gt $error.count) {
            $error.Clear()
        }
        $ErrorActionPreference = $thisErrorActionPreference
        write-host "Finished Get-Parent.ps1"
        if ($noexit){Read-Host "Paused. Press Enter to exit."}
    }
    # $error.Clear()
} # end Function Get-Parent

# Clear-Host
Write-Warning "In Script $($MyInvocation.MyCommand.Name): "

'This Process and Parents'
# '       ID: {0}' -f $pid
# '             Name: {0}' -f (Get-process -id $pid).name
$ThisProcess=get-process -id $pid # get the current process
'[{1}] [{2:d6}] [{0}] [{3}]' -f $ThisProcess.name , $ThisProcess.StartTime, $ThisProcess.id, $ThisProcess.path

getparent $PID