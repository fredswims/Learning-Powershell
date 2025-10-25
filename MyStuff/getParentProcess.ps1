# FAJ 2025-03-28
# List the Calling Process and its Parents.
<# 
Function PrintLine {
    param($Process)
    "[{2,8}] {4}[{5}{0,-15}{4}]{5} [{1:yyyy-MM-dd hh:mm:ss tt}] [{3}]" `
        -f $Process.name , $Process.StartTime, $Process.id, $Process.path, $psStyle.Formatting.Warning, $psstyle.reset
}
 #>
[CmdletBinding()]
param (
    # [Parameter()]
    # [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateRange(0, [Int64]::MaxValue)]
    [ValidateScript({
    if (Get-Process -Id $_ -ErrorAction SilentlyContinue) {return $true} else {throw "Id $_ is not valid"}})
    ]
    [Int64]$Id=$PID,
    [switch]$NoExit = $false
)
Begin {
    Write-Warning "In Script $($MyInvocation.MyCommand.Name): "
    write-host -ForegroundColor Yellow 'This Process and Parents'
    # get the current process
    $ThisProcess = get-process -id $Id
    "[{2,8}] {4}[{5}{0,-15}{4}]{5} [{1:yyyy-MM-dd hh:mm:ss tt}] [{3}]" `
        -f $ThisProcess.name , $ThisProcess.StartTime, $ThisProcess.id, $ThisProcess.path, $psStyle.Formatting.Warning, $psstyle.reset
    $ParentId = $(get-process -ErrorAction SilentlyContinue -id $id).parent.id

}
Process {
    while ($ParentId -gt 0) {
        $ParentProcess = get-process -id $ParentId -ErrorAction SilentlyContinue
        "[{2,8}] {4}[{5}{0,-15}{4}]{5} [{1:yyyy-MM-dd hh:mm:ss tt}] [{3}]" `
            -f $ParentProcess.name , $ParentProcess.StartTime, $ParentProcess.id, $ParentProcess.path, $psStyle.Formatting.Warning, $psstyle.reset
        $Id = $ParentProcess.id
        $ParentId = $(get-process -ErrorAction SilentlyContinue -id $Id).parent.id
    }
}
End {
        write-host "Finished GetParentProcess.ps1" -ForegroundColor yellow
        if ($noexit) { Read-Host "Paused. Press Enter to exit." }
} 
