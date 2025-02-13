function GetParent {
[CmdletBinding()]
param (
    [Parameter()]
    [Int64]$Id,
    [switch]$NoExit=$false
)
    $thisErrorCount=$Error.Count
    $thisErrorActionPreference=$ErrorActionPreference
    $ErrorActionPreference='silentlycontinue'
    $parent=$null
    $Parent=get-process -ErrorAction SilentlyContinue -id (get-process -ErrorAction SilentlyContinue  -id $id).parent.id
    if ($Parent.id -gt 0) {
        'Parent ID: {0}' -f $parent.id
        '      Parent Name: {0}' -f $parent.name
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
        write-host "Finished"
        if ($noexit){Read-Host "Paused. Press Enter to exit."}
    }
    # $error.Clear()
}
# Clear-Host
'starting'
'       ID: {0}' -f $pid
'             Name: {0}' -f (Get-process -id $pid).name
getparent $PID