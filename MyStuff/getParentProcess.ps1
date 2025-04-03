# FAJ 2025-03-28
[CmdletBinding()]
param (
    # [Parameter()]
    [ValidateRange(0, [Int64]::MaxValue)]
    [Int64]$Id=$PID,
    [switch]$NoExit = $false
)
Begin {
    # [int64]$parentId = 0
    Write-Warning "In Script $($MyInvocation.MyCommand.Name): "
    write-host -ForegroundColor Yellow 'This Process and Parents'
    # get the current process
    $ThisProcess = get-process -id $Id
    '[{1}] [{2:d6}] [{0}] [{3}]' -f $ThisProcess.name , $ThisProcess.StartTime, $ThisProcess.id, $ThisProcess.path
    $ParentId = $(get-process -ErrorAction SilentlyContinue -id $id).parent.id

}
Process {
    while ($ParentId -gt 0) {
        $ParentProcess = get-process -id $ParentId -ErrorAction SilentlyContinue
        '[{1}] [{2:d6}] [{0}] [{3}]' -f $ParentProcess.name , $ParentProcess.StartTime, $ParentProcess.id, $ParentProcess.path
        $Id = $ParentProcess.id
        $ParentId = $(get-process -ErrorAction SilentlyContinue -id $Id ).parent.id
    }
}
End {
        write-host "Finished Get-Parent.ps1" -ForegroundColor yellow
        if ($noexit) { Read-Host "Paused. Press Enter to exit." }
} 

