function Invoke-MagicWhere {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$Inputx,

        [Parameter(Mandatory)]
        [ScriptBlock]$Filter
    )

    process {
        Write-Verbose "Filtering input with provided script block"
        return $Inputx.Where($Filter)
    }
}

function Invoke-MagicForEach {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ScriptBlock]$Action,

        [Parameter()]
        [Array]$Inputx,

        [Parameter()]
        [string]$Label = "Transform"

    )
    if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"]) { 
        Write-Host "[$Label] Applying action to: $($Input.Count) items" 
    }
    return $Inputx.ForEach($Action)
}

# You can use them like:
# $evens = Invoke-MagicWhere -Inputx (1..10) -Filter { $_ % 2 -eq 0 } -Verbose
# $doubled = Invoke-MagicForEach -Input $evens -Action { $_ * 2 } -Verbose

# Example usage:


 $evens=@()
 $evens = Invoke-MagicWhere -Inputx (1..10) -Filter { $_ % 2 -eq 0 } -Verbose
 $evens


 $doubled =@()
 $doubled = Invoke-MagicForEach -Inputx $evens -Action { $_ * 2 } -Verbose
 $doubled


function ThisFunction {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory)]
        [string]$File
    )

    if ($PSCmdlet.ShouldProcess($File, "Delete file")) {
        Remove-Item $File
    }
}