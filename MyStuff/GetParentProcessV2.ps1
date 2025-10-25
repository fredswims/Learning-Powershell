# FAJ 2025-04-04
# List the Calling Process and its Parents.

[CmdletBinding()]
param (
    # [Parameter()]
    # [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateRange(0, [Int64]::MaxValue)]
    [ValidateScript({
    if (Get-Process -Id $_ -ErrorAction SilentlyContinue) {return $true} else {throw "Id $_ is not valid"}})
    ]
    [Int64]$Id = $PID,
    [switch]$NoReport,
    [switch]$NoExit = $false
)

Function PrintLine {
    # https://ss64.com/ps/syntax-dateformats.html
    # https://ss64.com/ps/syntax-f-operator.html
    param($Process)
    # "[{2,8}] {4}[{5}{0,-15}{4}]{5} [{1:yyyy-MM-dd hh:mm:ss tt}] [{3}]"
    $string="[{2,5}] {4}[{5}{0,-15}{4}]{5} [{1:dd hh:mm:ss tt}] [{3}]" `
        -f $Process.name , $Process.StartTime, $Process.id, $Process.path, $psStyle.Formatting.Warning, $psstyle.reset
    write-host $string
} # end function PrintLine

Function PrintHeader {
    write-host "==============================" -ForegroundColor Cyan
    write-host "   Process and Parent List   " -ForegroundColor Cyan
    write-host "==============================" -ForegroundColor Cyan
}   
# ==========Script Begins Here==========

write-host -ForegroundColor Yellow "`tExecuting:: $($PSCommandPath)"
write-host -ForegroundColor Yellow "`t`Called by:: $($MyInvocation.ScriptName)"
write-host -foregroundcolor yellow "`tInvoked as:: $($MyInvocation.Line)"

<#
write-host  "`tExecuting:: $($PSCommandPath)"
write-verbose  "`t`Called by:: $($MyInvocation.ScriptName)"
write-verbose  "`tInvoked as:: $($MyInvocation.Line)"
 #>
$results=@()

# Is the param $Id valid? If not THROW an exception.
# Don't need this because of ValidateScript on param $Id
# if (!(Get-Process -Id $id -ErrorAction SilentlyContinue))  {throw "Id $($id) is not valid"}

# write-host -ForegroundColor Yellow 'Process and Parents'
if(!$NoReport){PrintHeader}
$ThisProcess = get-process -id $Id
$results += $ThisProcess
if(!$NoReport){Printline $ThisProcess} 

# Find the first Potential parent Id.
$ParentId = $(get-process -ErrorAction SilentlyContinue -id $id).parent.id
#Loop thru all parents. Stop if Potential parent Id is invalid.
While ($null -ne $ParentId) {
    $ParentProcess = get-process -id $ParentId -ErrorAction SilentlyContinue
    $results += $ParentProcess
    if(!$NoReport){Printline $ParentProcess}
    # PrintLine $ParentProcess
    $Id = $ParentProcess.id
    #  Next potential parent Id.
    $ParentId = $(get-process -ErrorAction SilentlyContinue -id $Id).parent.id
} # end while

if ($noexit) { Read-Host "Paused. Press Enter to exit." }
write-host "Finis" -ForegroundColor yellow
return $results

# usage examples:
# $Ogpp=.\GetParentProcessV1.ps1 
# .\GetParentProcessV1.ps1
# .\GetParentProcessV1.ps1 -Id $PID -NoExit
