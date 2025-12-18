function Get-CanonicalPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path,

        [switch]$Strict,           # Enforce exactly one match
        [switch]$VerboseOutput,    # Optional logging
        [switch]$AsFileInfo        # Return [System.IO.FileInfo] object(s)
    )

    if (-not (Test-Path -Path $Path)) {
        Write-Error "ERROR 1001: Path does not exist [$Path]"
        return $null
    }

    try {
        $Resolved = Resolve-Path -Path $Path -ErrorAction Stop
    } catch {
        Write-Error "ERROR 1002: Failed to resolve path [$Path] — $_"
        return $null
    }

    if ($Strict -and $Resolved.Count -ne 1) {
        Write-Error "ERROR 1003: Strict mode — [$Path] resolves to [$($Resolved.Count)] items"
        return $null
    }

    if ($VerboseOutput) {
        Write-Host "Resolved canonical path(s):"
        $Resolved | ForEach-Object { Write-Host " - $_" }
    }

    if ($AsFileInfo) {
        return $Resolved | ForEach-Object {
            try {
                Get-Item -LiteralPath $_ -ErrorAction Stop
            } catch {
                Write-Error "ERROR 1004: Failed to retrieve item [$($_)] — $_"
                $null
            }
        }
    } else {
        return $Resolved.Path
    }
}
<#
Usage Examples:

# Load the module
Import-Module .\CanonicalPath.psm1

# Get canonical string path(s)
Get-CanonicalPath -Path ".\data\report.csv"

# Enforce single match
Get-CanonicalPath -Path "C:\Logs\*.txt" -Strict

# Return FileInfo object(s)
Get-CanonicalPath -Path "C:\Logs\*.txt" -AsFileInfo

# Verbose logging
Get-CanonicalPath -Path "..\Pictures\*.jpg" -VerboseOutput

#>
<#
Bonus: Error Codes
| Code     | Meaning |
|----------|--------|
| `1001`   | Path does not exist |
| `1002`   | Resolve-Path failed |
| `1003`   | Strict mode violation |
| `1004`   | Get-Item failed |
#>
<#
CanonicalPath.psd1 — Module Manifest (Optional)
@{
    RootModule        = 'CanonicalPath.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'd3f8a1a2-9c2e-4b3e-8e3f-abc123456789'
    Author            = 'Fred'
    Description       = 'Provides canonical path resolution with strict validation and FileInfo support.'
    FunctionsToExport = @('Get-CanonicalPath')
}
#>