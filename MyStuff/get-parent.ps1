function GetParent {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Int64]$Id,
        [switch]$NoExit = $false
    )
    # FAJ 2025-03-28
    <# 
    $thisErrorCount = $Error.Count
    $thisErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'silentlycontinue' 
    #>
    [int64]$parentId = 0
    
    $parentId = $(get-process -ErrorAction SilentlyContinue -id $id).parent.id
               
    if ($ParentId -gt 0) {
        $ParentProcess = get-process -id $parentId -ErrorAction SilentlyContinue

        '[{1}] [{2:d6}] [{0}] [{3}]' -f $ParentProcess.name , $ParentProcess.StartTime, $ParentProcess.id, $ParentProcess.path
        # $parent|Format-Table -HideTableHeaders -AutoSize -Property  id,  starttime, name, path
        # $ErrorActionPreference = $thisErrorActionPreference
        # if ($thisErrorCount -gt $error.count) {
        # $error.Clear()

        # get the next parent
        GetParent $ParentProcess.Id
        
    }
    else {
        <# 
        if ($thisErrorCount -gt $error.count) {
            $error.Clear()
        }
         #>
        write-host "Finished Get-Parent.ps1" -ForegroundColor yellow
        if ($noexit) { Read-Host "Paused. Press Enter to exit." }
    }
    # $error.Clear()
} # end Function Get-Parent

#Begin
Write-Warning "In Script $($MyInvocation.MyCommand.Name): "

write-host -ForegroundColor Yellow 'This Process and Parents'
# get the current process
$ThisProcess = get-process -id $pid 
'[{1}] [{2:d6}] [{0}] [{3}]' -f $ThisProcess.name , $ThisProcess.StartTime, $ThisProcess.id, $ThisProcess.path

GetParent $PID