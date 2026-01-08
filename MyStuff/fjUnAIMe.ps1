Function fjUnAiMe {
    [CmdletBinding()]
    param(
        [switch]$Start = $false,
        [switch]$Stop = $false,
        [switch]$LeaveServiceRunning = $false
    )

    Function Get-FreePhysicalMemory {
        # Get Free Physical Memory
        $freeGB = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue / 1KB
        # write-warning ("Free Physical Memory: {0} GB" -f $($(Get-ComputerInfo).OsFreePhysicalMemory / (1024*1024)))
        Write-Host ("[{0:N3} GB] Free Physical Memory " -f $freeGB ) -ForegroundColor Green 
    }
    
    Function SleepProgress {
        $items = 1..5
        foreach ($i in $items) {
            $percent = ($i / $items.Count) * 100
            Write-Progress -Activity "Processing data" -Status "$percent% Complete" -PercentComplete $percent
            Start-Sleep -seconds 1 # Simulate work
        }
    }

    Write-Warning "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
    # Cant have -Start and -Stop option at the same time.
    if ($Start -and $Stop) { Write-Warning "Both the -Start and -Stop options were selected. Terminating."; return }
    # Are we elevated?
    $IsElevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (($Stop -or $Start) -and !$IsElevated) { Write-Warning "You must be elevated to run with -Stop or -Start option. Terminating."; return "Not Elevated" }

    $ServiceName = "WSAIFabricSvc"

    Get-FreePhysicalMemory
    # What processess are we looking for?
    $ProcessName = "WorkloadsSessionHost"
    $ProcessName = ( "WorkLoadsSessionManager", "WorkloadsSessionHost")
    Write-Host "Checking for Processes: $($ProcessName -join ', ')"
    $Tasks = get-process $ProcessName -ErrorAction SilentlyContinue
    # How many processes are running? 
    write-host "[$($Tasks.Count)] instances of $($ProcessName -join ' & ') running"
    # Foreach ($Task in $Tasks) { write-host "$($task.name) `tPID: $($Task.Id) `tMemory Usage (GB): $([math]::Round($Task.WorkingSet64 /1GB,3))" }
    Foreach ($Task in $Tasks) { write-host " `tPID: $($Task.Id) `tMemory Usage (GB): $([math]::Round($Task.WorkingSet64 /1GB,3)) `t$($task.name)" }

    # How much memory is used by all WorkloadsSessionHost processes
    # write-host "`n Total Memory Used by WorkloadsSessionHost Processes:"
    # $tasks | Measure-Object WorkingSet64 -sum | select-object -Property @{ Name = " GB of Memory"; Expression = { $($_.sum) / 1GB } }
    $Size = $tasks | Measure-Object WorkingSet64 -sum
    $PrintSize = @{ Name = " GB of Memory"; Expression = { [math]::Round($Size.sum / 1GB, 3) } }
    # Write-Host "Result:" (& $PrintSize.Expression) $PrintSize.Name -ForegroundColor Green
    $freeGB = (& $PrintSize.Expression)
    Write-Host ("[{0:N3} GB] Physical Memory Used by $($ProcessName -join ' & '): " -f $freeGB) -ForegroundColor Green
    # Get-FreePhysicalMemory

    try {
        if ($Stop) {
            # Write-Host "Stopping Processes $($ProcessName), Stopping Service $($ServiceName), Setting-Service $($ServiceName) to Disabled"
            $tasks.foreach{ stop-process -id $_.id -force -Verbose } 
            if (-not $LeaveServiceRunning) {
                Set-Service -Name $ServiceName -StartupType Disabled  -verbose
                Stop-Service -Name $ServiceName -Force -Verbose
            }
            # start-sleep -Seconds 5 -Verbose
            # write-warning ("Free Physical Memory: {0} GB" -f $($(Get-ComputerInfo).OsFreePhysicalMemory / (1024*1024)))
            # Get-FreePhysicalMemory
        }
        if ($Start) {
            Set-Service -Name $ServiceName -StartupType AutomaticDelayedStart -Verbose && Start-Service -Name $ServiceName -Verbose
            # Get-FreePhysicalMemory
        }
    }
    catch {
        write-host "An error occured"
        Get-Error
    }  
    finally {
        <#Do this after the try block regardless of whether an exception occurred or not#>
        SleepProgress
        Get-FreePhysicalMemory
        get-service -name $ServiceName|format-table status,name,StartType 
        Write-Warning "[END  ] Leaving: $($MyInvocation.Mycommand)"
    }
}

    # fjUnAiMe