# FAJ 2025-04-04
# List the Calling Process and its Parents.

[CmdletBinding()]
param (
    # [Parameter()]
    # [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateRange(0, [Int64]::MaxValue)]
    # [ValidateScript({if ((get-process).id -contains $_) {return $true}else {throw "Id $($_) is not valid"}})]
    [Int64]$Id = $PID,
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
        # create a custom object
             $oProcess=       [pscustomobject]@{
                        # PSTypeName  = 'System.Diagnostics.Process'
                        Process = $Process
                        # ProfilePath = $PSCommandPath
                    }
            $oProcess
}

# Script Begins Here
# Write-Warning "In Script $($MyInvocation.MyCommand.Name): "
write-host -ForegroundColor Yellow "`tExecuting:: $($MyInvocation.MyCommand.Source)"
write-host -ForegroundColor Yellow "`t`Called by:: $($MyInvocation.ScriptName) `n`tInvoked as:: $($MyInvocation.Line)"

#  Is the param $Id valid? If not print message and exit.
if ((get-process).id -contains $id) { write-verbose "Good `$Id" } else { Write-host -ForegroundColor Red  "Enter a valid 'Id'"; return }
    
write-host -ForegroundColor Yellow 'Process and Parents'
$ThisProcess = get-process -id $Id
Printline $ThisProcess 

    
# Find the first Potential parent Id.
$ParentId = $(get-process -ErrorAction SilentlyContinue -id $id).parent.id
#Loop thru all parents. Stop if Potential parent Id is invalid.
While ($ParentId -gt 0) {
    $ParentProcess = get-process -id $ParentId -ErrorAction SilentlyContinue
    PrintLine $ParentProcess
    $Id = $ParentProcess.id
    #  Next potential parent Id.
    $ParentId = $(get-process -ErrorAction SilentlyContinue -id $Id).parent.id
} # end while

write-host "Finis" -ForegroundColor yellow
if ($noexit) { Read-Host "Paused. Press Enter to exit." }
 