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
    $obj=[pscustomobject]@{
        # PSTypeName  = 'System.Diagnostics.Process'
        Process = $Process
        # ProfilePath = $PSCommandPath
        }
    $script:ProcessResults += $obj.process
} # end function PrintLine


# ==========Script Begins Here==========
# Write-Warning "In Script $($MyInvocation.MyCommand.Name): "
write-host -ForegroundColor Yellow "`tExecuting:: $($PSCommandPath)"
write-host -ForegroundColor Yellow "`t`Called by:: $($MyInvocation.ScriptName) `n`tInvoked as:: $($MyInvocation.Line)"
$script:ProcessResults = @()

# Is the param $Id valid? If not THROW an exception.
# Don't need this because of ValidateScript on param $Id
# if (!(Get-Process -Id $id -ErrorAction SilentlyContinue))  {throw "Id $($id) is not valid"}

write-host -ForegroundColor Yellow 'Process and Parents'
$ThisProcess = get-process -id $Id
Printline $ThisProcess 

# Find the first Potential parent Id.
$ParentId = $(get-process -ErrorAction SilentlyContinue -id $id).parent.id
#Loop thru all parents. Stop if Potential parent Id is invalid.
While ($null -ne $ParentId) {
    $ParentProcess = get-process -id $ParentId -ErrorAction SilentlyContinue
    PrintLine $ParentProcess
    $Id = $ParentProcess.id
    #  Next potential parent Id.
    $ParentId = $(get-process -ErrorAction SilentlyContinue -id $Id).parent.id
} # end while

if ($noexit) { Read-Host "Paused. Press Enter to exit." }
write-host "Finis" -ForegroundColor yellow
return $script:ProcessResults

# usage examples:
# $Ogpp=.\GetParentProcessV1.ps1 
# .\GetParentProcessV1.ps1
# .\GetParentProcessV1.ps1 -Id $PID -NoExit

<# 
Absolutely, Fred — here's a clean scaffold for a PowerShell module that supports pipeline input, uses Begin/Process/End blocks, and returns custom objects for each process ID. This structure is ideal for reusable diagnostics, logging, or integration with other tools.

🧱 Module Scaffold: Get-ProcessInfoById.psm1

function Get-ProcessInfoById {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true,
            Mandatory = $true
        )]
        [int]$ProcessId
    )

    begin {
        # Initialize accumulator
        $results = @()
    }

    process {
        try {
            $proc = Get-Process -Id $ProcessId -ErrorAction Stop
            $obj = [PSCustomObject]@{
                ProcessId = $proc.Id
                Name      = $proc.Name
                CPU       = $proc.CPU
                StartTime = $proc.StartTime
                Status    = "Found"
            }
        } catch {
            $obj = [PSCustomObject]@{
                ProcessId = $ProcessId
                Name      = $null
                CPU       = $null
                StartTime = $null
                Status    = "Not Found"
            }
        }

        $results += $obj
    }

    end {
        # Emit all results at once
        $results
    }
}

✅ Example Usage

# Import the module
Import-Module .\Get-ProcessInfoById.psm1

# Pipe in process IDs
@(1234, 5678, 9999) | Get-ProcessInfoById | Format-Table

🧩 Optional Enhancements

You could extend this with:

-Verbose or -Debug support

Logging to a file or timestamped output

Filtering by name or CPU threshold

Export to JSON/CSV

Integration with Out-GridView or dashboards

📌 Best Practices: Function Placement in PowerShell Scripts and Modules

When writing PowerShell scripts or modules containing one or more functions, it is best practice to place all function definitions near the top of the script or module file. This ensures that all functions are loaded and available before the main execution code runs.

Key points:

Define functions first: Place all reusable function definitions at the beginning of your script or module.

Main script logic after: Follow function definitions with the main script code that calls these functions.

Improves readability and maintainability: This structure makes it easier to understand and maintain your code.

Modules: In PowerShell modules (.psm1 files), functions are typically defined at the top level so they can be exported or used internally.

This approach helps avoid errors where functions are called before they are defined and promotes clean, modular, and reusable code design.

Would you like me to help scaffold a sample script demonstrating this best practice?
 #>