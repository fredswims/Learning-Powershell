# === CONFIGURATION ===
$procmonPath    = "C:\Sysinternals\Procmon.exe"    # Path to ProcMon executable
$targetExe      = "qw.exe"                         # Target executable name
$filterFile     = "$env:TEMP\ProcmonFilter.pmc"    # Custom filter file
$logFile        = "$env:TEMP\qw_trace.pml"         # Output trace file
$includeTarget  = "Process Name","is",$targetExe,"Include"

# === Step 1: Create Filter File (.pmc) ===
$pmcContent = @"
FilterCount=1
Filter1=$($includeTarget -join "`t")
"@
Set-Content -Path $filterFile -Value $pmcContent

# === Step 2: Launch ProcMon with Custom Filter ===
Start-Process -FilePath $procmonPath -ArgumentList @(
    "/Quiet",
    "/AcceptEula",
    "/Minimized",
    "/LoadConfig", "`"$filterFile`"",
    "/BackingFile", "`"$logFile`""
)

# === Step 3 (Optional): Launch Target Executable ===
Start-Sleep -Seconds 3
Start-Process -FilePath $targetExe -WorkingDirectory (Get-Location)