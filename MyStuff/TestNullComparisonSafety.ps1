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

foreach ($file in Get-Item '*.ps1') {Test-NullComparisonSafety -path $file -IncludeLineNumbers}