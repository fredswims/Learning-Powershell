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
     Write-Verbose "`n`tIn function [$($MyInvocation.MyCommand.Name)]: " 
    # "[{2,8}] {4}[{5}{0,-15}{4}]{5} [{1:yyyy-MM-dd hh:mm:ss tt}] [{3}]"
    $string="[{2,5}] {4}[{5}{0,-15}{4}]{5} [{1:dd hh:mm:ss tt}] [{3}]" `
        -f $Process.name , $Process.StartTime, $Process.id, $Process.path, $psStyle.Formatting.Warning, $psstyle.reset
    write-host $string
} # end function PrintLine

Function PrintHeader {
    Write-Verbose "`n`tIn function [$($MyInvocation.MyCommand.Name)]: " 
    $callStack = Get-PSCallStack
    $caller=$callstack[1]
    write-verbose "`n`tCalled by [$($caller.FunctionName)]"

    write-host -ForegroundColor Yellow "`tCaller`t[$($MyInvocation.ScriptName)]"
    write-host "==============================" -ForegroundColor Cyan
    write-host "   Process and Parent List   " -ForegroundColor Cyan
    write-host "==============================" -ForegroundColor Cyan
}   
# ==========Script Begins Here==========
write-host -ForegroundColor Yellow "`tCall To`t[$($MyInvocation.MyCommand.Name)]: Get process and parents. [$(Get-Date -Format 'dddd MM/dd/yyyy HH:mm:ss K')]"
write-host -ForegroundColor Yellow "`tPath`t[$($PSCommandPath)]" 
write-host -ForegroundColor Yellow "`tCaller`t[$($MyInvocation.ScriptName)]"
write-host -foregroundcolor yellow "`t>>`t[$([System.Environment]::commandline.tostring())]"
write-host -foregroundcolor yellow "`tCmdLine`t[$($MyInvocation.Line.ToString().ReplaceLineEndings($null))]"
#region Who Am I
<# 
Write-Warning (
    "`n`t[$(Get-Date -Format 'dddd MM/dd/yyyy HH:mm:ss K')]"+
    "`n`tIn function [$($MyInvocation.MyCommand.Name)]: Get process and parents" +
    "`n`tIn script   [$PSCommandPath]: " +
    "`n`tInvoked as  [$($MyInvocation.Line)]" +
    "`n`tEnvironment [$([System.Environment]::commandline)]"
)
 #>
#endregion

$results=@() # Array to hold results from Get-Process.

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
    # $null=$ParentId
    # Use the null‑conditional operator (?.) when [set-strickmode -level lastest] is used.

    $ParentId = $(get-process -ErrorAction SilentlyContinue -id $Id)?.parent?.id
} # end while

if ($noexit) { Read-Host "Paused. Press Enter to exit." }
return $results
<#
    Examples:
    $Ogpp=.\GetParentProcessV2.ps1 
    $Ogpp=.\GetParentProcessV2.ps1 -noReport
    .\GetParentProcessV2.ps1 -noReport
    .\GetParentProcessV2.ps1 -Id $PID -NoExit
#>