function GetParent {
[CmdletBinding()]
param (
    [Parameter()]
    [Int64]
    $Id
)
    $ErrorActionPreference='ignore'
    $parent=$null
    $Parent=get-process -id (get-process -ErrorAction Ignore -id $id).parent.id -ErrorAction ignore
    if ($Parent.id -gt 0) {
        'Parent ID: {0}' -f $parent.id
        '      Parent Name: {0}' -f $parent.name
    GetParent $parent.Id
    } else {"Finished"}
}
Clear-Host
'starting'
'       ID: {0}' -f $pid
'             Name: {0}' -f (Get-process -id $pid).name
getparent $PID