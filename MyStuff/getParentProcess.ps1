# FAJ 2025-03-28
[CmdletBinding()]
param (
    # [Parameter()]
    # [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateRange(0, [Int64]::MaxValue)]
    # [ValidateScript({if ((get-process).id -contains $_) {return $true}else {throw "Id $($_) is not valid"}})]
    [Int64]$Id=$PID,
    [switch]$NoExit = $false
)
Begin {
    # [int64]$parentId = 0
    if ((get-process).id -contains $id) {"Good Id"} else {"Enter a valid 'Id'";return}
    Write-Warning "In Script $($MyInvocation.MyCommand.Name): "
    write-host -ForegroundColor Yellow 'This Process and Parents'
    # get the current process
    $ThisProcess = get-process -id $Id
    '{4}[{5}{0}{4}]{5} [{2:d6}] [{1}] [{3}]' -f $ThisProcess.name , $ThisProcess.StartTime, $ThisProcess.id, $ThisProcess.path, $psStyle.bold, $psstyle.boldoff
    $ParentId = $(get-process -ErrorAction SilentlyContinue -id $id).parent.id

}
Process {
    while ($ParentId -gt 0) {
        $ParentProcess = get-process -id $ParentId -ErrorAction SilentlyContinue
        '{4}[{5}{0}{4}]{5} [{2:d6}] [{1}] [{3}]' -f $ParentProcess.name , $ParentProcess.StartTime, $ParentProcess.id, $ParentProcess.path, $psStyle.bold, $psstyle.boldoff
        $Id = $ParentProcess.id
        $ParentId = $(get-process -ErrorAction SilentlyContinue -id $Id).parent.id
    }
}
End {
        write-host "Finished GetParentProcess.ps1" -ForegroundColor yellow
        if ($noexit) { Read-Host "Paused. Press Enter to exit." }
} 
<# 
$tasks=get-process
if ($tasks.id -contains $pid) {"true"}else {"false"}
 #>