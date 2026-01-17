    <#
        .SYNOPSIS
        Frees up AI memory.
        AUTHOR:FAJ January 2026
        REVISION HISTORY:FAJ 2026.01.17 Version 1.1.1
#>
<#
$transcriptPath = ".\logs\test.log"
start-transcript -path $transcriptPath -append
write-warning "Starting $pscommandpath"
$action = New-ScheduledTaskAction `
    -Execute "pwsh.exe" `
    -Argument "-w Hidden -nonInteractive -noProfile -noLogo -File `".\fjUnAIme1.ps1`"" `
    -WorkingDirectory "C:\Users\fred\mystuff"
$trigger = New-ScheduledTaskTrigger `
    -Once `
    -At (Get-Date) `
    -RepetitionInterval (New-TimeSpan -Minutes 15) `
    # -RepetitionDuration ([TimeSpan]::MaxValue)

    # -w Hidden -nonInteractive -noProfile -noLogo -file "C:\Users\freds\OneDrive\PowershellScripts\MyStuff\fjUnAIme1.ps1"

    Register-ScheduledTask `
    -TaskName "fjUnAIme2" `
    -Action $action `
    -Trigger $trigger `
    -Description "Runs myscript.ps1 every 15 minutes" `
    -User "$env:USERNAME"
    -RunLevel Highest

# no good - 
$MyTaskName = "fjUnAIme2"
Register-ScheduledTask -TaskName $MyTaskName `
  -Action (New-ScheduledTaskAction -Execute "pwsh.exe" -Argument '-w Hidden -nonInteractive -noProfile -noLogo -file "C:\users\freds\mystuff\fjUnAIme1.ps1"') `
  -Trigger (New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 15)) `
  -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries) `
  -RunLevel Highest `
  -User "SYSTEM"

# this works but uses 
$MyTaskName = "fjUnAIme2"
Register-ScheduledTask -TaskName $MyTaskName `
  -Action (New-ScheduledTaskAction -Execute "pwsh.exe" -Argument '-w Hidden -nonInteractive -noProfile -noLogo -file "C:\users\freds\mystuff\fjUnAIme1.ps1"') `
  -Trigger (New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 15)) `
  -Settings (New-ScheduledTaskSettingsSet -RunOnlyIfLoggedOn:$false -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries)

#>


<#
#this works - no blink (internal uses Run wether or not LoggedOn)
  schtasks /create `
  /tn "fjUnAIme2" `
  /tr "pwsh.exe -w Hidden -nonInteractive -noProfile -noLogo -file C:\users\freds\mystuff\fjUnAIme1.ps1" `
  /sc minute /mo 15 `
  /ru "$env:USERNAME" `
  /rp *

 #>
<#
  function New-HiddenScheduledTask {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$ScriptPath,

        [Parameter()]
        [int]$EveryMinutes = 15,

        [Parameter()]
        [string]$PwshPath = "pwsh.exe"
    )

    if (-not (Test-Path $ScriptPath)) {
        throw "Script not found: $ScriptPath"
    }

    # Build the schtasks command
    $taskCommand = @(
        "/create"
        "/tn `"$Name`""
        "/tr `"$PwshPath -w Hidden -nonInteractive -noProfile -noLogo -file `"$ScriptPath`"`""
        "/sc minute"
        "/mo $EveryMinutes"
        "/ru `"$env:USERNAME`""
        "/rp *"
    ) -join " "

    Write-Host "Creating scheduled task '$Name'..."
    Write-Host "You will be prompted for your password."

    # Run schtasks
    $proc = Start-Process -FilePath "schtasks.exe" -ArgumentList $taskCommand -NoNewWindow -Wait -PassThru

    if ($proc.ExitCode -eq 0) {
        Write-Host "Task '$Name' created successfully."
    } else {
        Write-Warning "schtasks.exe returned exit code $($proc.ExitCode)."
        # Now you can detect:
         	# success (0)
         	# task already exists (1)
         	# invalid parameter (87)
         	# access denied (5)
         	# credential failure (0x80041318)
    }
}
#>
# New-HiddenScheduledTask -Name fjUnAiMePlease -ScriptPath (join-path $home mystuff fjunaime1.ps1) -EveryMinutes 16 -PwshPath pwsh -Verbose


#Updated Version to capture all the errors that schtasks.exe can report

<#
function New-HiddenScheduledTask {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$ScriptPath,

        [Parameter()]
        [int]$EveryMinutes = 15,

        [Parameter()]
        [string]$PwshPath = "pwsh.exe"
    )
$VerbosePreference = 'SilentlyContinue'
    if (-not (Test-Path $ScriptPath)) {
        throw "Script not found: $ScriptPath"
    }

    # Build the pwsh command line with automatic -TaskName injection
    $pwshArgs =
        "-w Hidden -nonInteractive -noProfile -noLogo " +
        "-file `"$ScriptPath`" " +
        "-TaskName `"$Name`""

    # Build the schtasks command
    $taskCommand = @(
        "/create"
        "/tn `"$Name`""
        "/tr `"$PwshPath $pwshArgs`""
        "/sc minute"
        "/mo $EveryMinutes"
        "/ru `"$env:USERNAME`""
        "/rp *"
    ) -join " "

    Write-Verbose "Running: schtasks.exe $taskCommand"

    # Capture stdout and stderr
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "schtasks.exe"
    $psi.Arguments = $taskCommand
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true

    $proc = New-Object System.Diagnostics.Process
    $proc.StartInfo = $psi

    Write-Host "Creating scheduled task '$Name'..."
    Write-Host "You will be prompted for your password."

    $null = $proc.Start()
    $proc.WaitForExit()

    $stdout = $proc.StandardOutput.ReadToEnd().Trim()
    $stderr = $proc.StandardError.ReadToEnd().Trim()
    $exit   = $proc.ExitCode

    if ($stdout) { Write-Verbose "STDOUT: $stdout" }
    if ($stderr) { Write-Verbose "STDERR: $stderr" }

    if ($exit -ne 0) {
        $msg = @(
            "schtasks.exe failed with exit code $exit."
            "Output:"
            $stdout
            $stderr
        ) -join "`n"

        throw $msg
    }

    Write-Host "Task '$Name' created successfully."
    if ($stdout) { Write-Host $stdout }
}

#>
<#
function New-HiddenScheduledTask {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$ScriptPath,

        [Parameter()]
        [int]$EveryMinutes = 15,

        [Parameter()]
        [string]$PwshPath = "pwsh.exe"
    )

    if (-not (Test-Path $ScriptPath)) {
        throw "Script not found: $ScriptPath"
    }

    # Build pwsh command with automatic -TaskName injection
    $pwshArgs =
        "-w Hidden -nonInteractive -noProfile -noLogo " +
        "-file `"$ScriptPath`" " +
        "-TaskName `"$Name`""

    # Build schtasks command
    $taskCommand = @(
        "/create"
        "/tn `"$Name`""
        "/tr `"$PwshPath $pwshArgs`""
        "/sc minute"
        "/mo $EveryMinutes"
        "/st 00:00"
        "/ru `"$env:USERNAME`""
        "/rp *"
    ) -join " "

    Write-Host "Creating scheduled task '$Name'..."
    Write-Host "You will be prompted for your password."

    # Run schtasks.exe interactively so password prompt works
    $proc = Start-Process -FilePath "schtasks.exe" `
        -ArgumentList $taskCommand `
        -Wait `
        -PassThru `
        -NoNewWindow

    if ($proc.ExitCode -ne 0) {
        throw "schtasks.exe failed with exit code $($proc.ExitCode)"
    }

    Write-Host "Task '$Name' created successfully."
}
#>
# New-HiddenScheduledTask -Name fjUnAiMePlease -ScriptPath (join-path $home mystuff fjunaime1.ps1) -EveryMinutes 16 -PwshPath pwsh -Verbose

function New-HiddenScheduledTask {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$ScriptPath,

        [Parameter()]
        [int]$EveryMinutes = 15,

        [Parameter()]
        [string]$PwshPath = "pwsh.exe"
    )
    <#
        .SYNOPSIS
        Frees up AI memory.
        AUTHOR:FAJ January 2026
        REVISION HISTORY:FAJ 2026.01.17 1.1.0
    #>

    Write-Warning -msg "`n[$(get-date -Format "dddd yyyy.MM.ddTHH:mm:ss K")]" 
    Write-Warning "In function $($MyInvocation.MyCommand.Name):"

    if (-not (Test-Path $ScriptPath)) {
        throw "Script not found: $ScriptPath"
    }

    # Build pwsh command with automatic -TaskName injection
    $pwshArgs =
        "-w Hidden -nonInteractive -noProfile -noLogo " +
        "-file `"$ScriptPath`" " +
        "-TaskName `"$Name`""

    # Build schtasks command
    $taskCommand = @(
        "/create"
        "/tn `"$Name`""
        "/tr `"$PwshPath $pwshArgs`""
        "/sc minute"
        "/mo $EveryMinutes"
        "/ru `"$env:USERNAME`""
        "/rp *"
    ) -join " "

    Write-Host "Creating scheduled task [$Name]..."
    Write-Host "You will be prompted for your password."

    # Create the repeating task
    $proc = Start-Process -FilePath "schtasks.exe" `
        -ArgumentList $taskCommand `
        -Wait `
        -PassThru `
        -NoNewWindow

    if ($proc.ExitCode -ne 0) {
        throw "schtasks.exe failed with exit code $($proc.ExitCode)"
    }

    # Add a one-time trigger in the past to force immediate run
    $runNowCmd = "/change /tn `"$Name`" /st 00:00 /sd 01/01/2000"
<# 
    $proc2 = Start-Process -FilePath "schtasks.exe" `
        -ArgumentList $runNowCmd `
        -Wait `
        -PassThru `
        -NoNewWindow

    if ($proc2.ExitCode -ne 0) {
        throw "schtasks.exe /change failed with exit code $($proc2.ExitCode)"
    }
 #>
    Start-ScheduledTask -TaskName $Name
    Write-Host "Task '$Name' created and triggered immediately."
}
$ScriptPath = (join-path $home mystuff fjUnAImeWrapper.ps1)
$Name = "fjUnAiMe"
#is it already registered?
$Task = Get-ScheduledTask -TaskName $Name -ErrorAction SilentlyContinue
if ($null -ne $Task) {
    Write-Host "Scheduled Task '$Name' already exists. No action taken."
    return
}
New-HiddenScheduledTask -Name $Name -ScriptPath $ScriptPath -EveryMinutes 15 -PwshPath pwsh -Verbose
# Start-ScheduledTask -TaskName fjUnAiMePlease
# Unregister-ScheduledTask -TaskName fjunaimeplease