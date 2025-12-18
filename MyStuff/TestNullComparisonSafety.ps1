function Test-NullComparisonSafety {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path,

        [switch]$IncludeLineNumbers
    )

    if (-not (Test-Path $Path)) {
        Write-Warning "File not found: $Path"
        return
    }

    $lines = Get-Content -Path $Path
    $pattern = '(?<!\$null\s)-eq\s+\$null|(?<!\$null\s)-ne\s+\$null'

    $results = @()
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -match $pattern) {
            $entry = if ($IncludeLineNumbers) {
                [PSCustomObject]@{
                    LineNumber = $i + 1
                    Line       = $line.Trim()
                    Path=split-path $path -Leaf
                }
            } else {
                $line.Trim()
            }
            $results += $entry
        }
    }

    if ($results.Count -eq 0) {
        Write-Verbose "No risky null comparisons found."
    } else {
        Write-Output $results
    }
}

# foreach ($file in Get-Item '*.ps1') {Test-NullComparisonSafety -path $file.fullname -IncludeLineNumbers} 
# test-NullComparisonSafety -path RebootDetection.ps1 -IncludeLineNumbers
function Convert-NullComparisonsToYodaStyle {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$Path,
        [switch]$Backup
    )

    if (-not (Test-Path $Path)) {
        Write-Warning "File not found: $Path"
        return
    }

    $original = Get-Content -Path $Path -Raw
    $fixed = $original

    # Match patterns like: $var -eq $null or $something -ne $null
    $fixed = [regex]::Replace($fixed, '(?<expr>.+?)\s*(-eq|-ne)\s*\$null', {
        param($m)
        "$($m.Groups[2].Value) `$null -and $($m.Groups['expr'].Value.Trim())"
    })

    if ($fixed -ne $original) {
        if ($PSBoundParameters.ContainsKey('WhatIf')) { # $PSBoundParameters['WhatIf']
            Write-Host "Changes detected, but not applied due to -WhatIf:"
            Write-Host "---- ORIGINAL ----"
            Write-Host $original
            Write-Host "---- FIXED ----"
            Write-Host $fixed
        } else {
            if ($Backup) {
                Copy-Item -Path $Path -Destination "$Path.bak" -Force
            }
            Set-Content -Path $Path -Value $fixed
            Write-Host "Updated: $Path"
            if ($Backup) { Write-Host "Backup saved as: $Path.bak" }
        }
    } else {
        Write-Host "No changes needed. All null comparisons are already Yoda-style."
    }
}
# foreach ($file in Get-Item '*.ps1') {Convert-NullComparisonsToYodaStyle -Path $file.FullName -WhatIf}
Convert-NullComparisonsToYodaStyle -Path RebootDetection.ps1 -WhatIf -Backup