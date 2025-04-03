<# 
In PowerShell, the `begin` block or label is typically used in advanced functions and scripts within a `process` block. 
It's part of the `begin`, `process`, and `end` workflow that helps manage how data is processed.

The `begin` block is executed once before the `process` block begins iterating over input objects. 
This makes it ideal for initialization tasks, like setting up variables, opening files, 
or preparing other resources needed during processing.

 #>
function ExampleFunction {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]$Input
    )

    begin {
        Write-Host "Initializing resources..."
    }
    process {
        Write-Host "Processing: $($Input)"
    }
    end {
        Write-Host "Cleaning up resources..."
    }
} 

# "Fred" | ExampleFunction
# "Fred","Ellen","Bea","Irv" | ExampleFunction