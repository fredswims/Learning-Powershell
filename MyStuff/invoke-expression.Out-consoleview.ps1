<# 
Write-warning -Message "Starting [$($MyInvocation.MyCommand)]"
$cmds = (Get-PSReadLineHistory -count -1) | Out-ConsoleGridView
if ($cmds) {
    $cmds | ForEach-Object {
        Write-Host "Running:`n$_" -ForegroundColor Cyan
        Invoke-expression $_.CommandLine
    }
} 
#>

# Invoke-SoundPlayer C:\windows\media\qdelete2.wav -Verbose

function Get-CanonicalPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path,

        [switch]$Strict,  # Enforce exactly one match
        [switch]$VerboseOutput  # Optional logging
    )

    if (-not (Test-Path -Path $Path)) {
        throw "Path does not exist: [$Path]"
    }

    $Resolved = Resolve-Path -Path $Path -ErrorAction Stop

    if ($Strict -and $Resolved.Count -ne 1) {
        throw "Strict mode: [$Path] resolves to [$($Resolved.Count)] items. Expected exactly one."
    }

    if ($VerboseOutput) {
        Write-Host "Resolved path(s):"
        $Resolved | ForEach-Object { Write-Host " - $_" }
    }

    # Return canonical path(s) as string(s)
    return $Resolved.Path
}
$rpath=@()
$rpath=Get-CanonicalPath -Path 'C:\Windows\System32\*.exe'  -VerboseOutput -Strict:$true
