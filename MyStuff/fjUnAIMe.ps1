Function fjUnAiMe {
    param(
        [switch]$Start = $false,
        [switch]$Stop = $false
    )

    Function Get-FreePhysicalMemory {
        # Get Free Physical Memory
        $freeGB = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue / 1KB
        # write-warning ("Free Physical Memory: {0} GB" -f $($(Get-ComputerInfo).OsFreePhysicalMemory / (1024*1024)))
        Write-Host ("Free Physical Memory: {0:N3} GB" -f $freeGB ) -ForegroundColor Green 
    }
    
    Write-Warning "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
    # Cant have -Start and -Stop option at the same time.
    if ($Start -and $Stop) { Write-Warning "Both the -Start and -Stop options were selected. Terminating."; return }
    # Are we elevated?
    $IsElevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (($Stop -or $Start) -and !$IsElevated) { Write-Warning "You must be elevated to run with -Stop or -Start option. Terminating."; return }

    $ServiceName = "WSAIFabricSvc"

    Get-FreePhysicalMemory
    # What processess are we looking for?
    $ProcessName = "WorkloadsSession*"
    $Tasks = get-process $ProcessName 
    # How many processes are running? 
    Foreach ($Task in $Tasks) { write-host "$($task.name) `n`tPID: $($Task.Id) `tMemory Usage (GB): $([math]::Round($Task.WorkingSet64 /1GB,3))" }

    # How much memory is used by all WorkloadsSessionHost processes
    # write-host "`n Total Memory Used by WorkloadsSessionHost Processes:"
    # $tasks | Measure-Object WorkingSet64 -sum | select-object -Property @{ Name = " GB of Memory"; Expression = { $($_.sum) / 1GB } }
    $Size = $tasks | Measure-Object WorkingSet64 -sum
    $PrintSize = @{ Name = " GB of Memory"; Expression = { [math]::Round($Size.sum / 1GB, 3) } }
    # Write-Host "Result:" (& $PrintSize.Expression) $PrintSize.Name -ForegroundColor Green
    $freeGB = (& $PrintSize.Expression)
    Write-Host ("Physical Memory Used by $($ProcessName): {0:N3} GB" -f $freeGB) -ForegroundColor Green

    try {
        if ($Stop) {
            Write-Host "Stopping Processes $($ProcessName), Stopping Service $($ServiceName), Setting-Service $($ServiceName) to Disabled"
            $tasks.foreach{ stop-process -id $_.id -force -Verbose } 
            Stop-Service -Name $ServiceName -Force -Verbose 
            Set-Service -Name $ServiceName -StartupType Disabled  -verbose
            start-sleep -Seconds 5 -Verbose
            # write-warning ("Free Physical Memory: {0} GB" -f $($(Get-ComputerInfo).OsFreePhysicalMemory / (1024*1024)))
            Get-FreePhysicalMemory
        }
        if ($Start) {
            Set-Service -Name $ServiceName -StartupType AutomaticDelayedStart -Verbose && Start-Service -Name $ServiceName -Verbose
            Get-FreePhysicalMemory
        }
    }
    catch {
        write-host "An error occured"
        Get-Error
    }  
    finally {
        <#Do this after the try block regardless of whether an exception occurred or not#>
        Write-Warning "[END  ] Leaving: $($MyInvocation.Mycommand)"
    }
}

    # fjUnAiMe