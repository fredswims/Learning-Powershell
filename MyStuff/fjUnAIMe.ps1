Function fjUnAiMe {
    [CmdletBinding()]
    param(
        [Int32]$LimitGB = 1,
        [switch]$Auto= $false,
        [switch]$Start = $false,
        [switch]$Stop = $false,
        [switch]$LeaveServiceRunning = $false
    )

        Function Get-FreePhysicalMemory {
        [CmdletBinding()]
        param()
            Write-Host "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
            # Get Free Physical Memory
            $freeGB = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue / 1KB
            # write-warning ("Free Physical Memory: {0} GB" -f $($(Get-ComputerInfo).OsFreePhysicalMemory / (1024*1024)))
            Write-Host ("[{0:N3} GB] Free Physical Memory " -f $freeGB ) 
            $freeGB # return
        }
        
        Function SleepProgress {
            param (
                [int]$Seconds = 5
                )   
                Write-Host "[*BEGIN  ] Starting: $($MyInvocation.Mycommand)" -ForegroundColor Green
                $items = 1..$Seconds
                foreach ($i in $items) {
                    $percent = ($i / $items.Count) * 100
                    Write-Progress -Activity "Processing data" -Status "$percent% Complete" -PercentComplete $percent
                    Start-Sleep -seconds 1 # Simulate work
                }
            }
            
    #region main starts here
    write-host "$(get-date -Format "dddd yyyy.MM.dd HH:mm:ss K")"
    Write-Host "[*BEGIN  ] Starting: $($MyInvocation.Mycommand)" -ForegroundColor Green
    
    $path = "$home\mystuff\fjUnAIme1.log" # eventually get rid of this.
    out-file -InputObject   "In Script $($PSCommandPath): [$(Get-Date -Format o)] " -append $path
    
    # Cant have -Start and -Stop option at the same time.
    if ($Start -and $Stop) { Write-Warning "Both the -Start and -Stop options were selected. Terminating."; return }
    # Are we elevated?
    $IsElevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    Write-Host "IsElevated: $IsElevated "
    if (($Stop -or $Start) -and !$IsElevated) { Write-Warning "You must be elevated to run with -Stop or -Start option. Terminating."; return "Not Elevated" }
    
    $ServiceName = "WSAIFabricSvc"
    
    $FreePhysicalMemory = Get-FreePhysicalMemory #get Free Physical Memory
    Write-Host ("[{0:N3} GB] Limit/Trigger" -f $LimitGB ) 
    $beLowGB = if( $FreePhysicalMemory -le $LimitGB ) { $true; write-host "Free Physical Memory is low." } else { $false }

    # What processess are we looking for?
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
    
    if ((!$stop -and !$Start) -and ($beLowGB -and $Auto)) {
        Write-Warning "Physical Memory is below or equal to $LimitGB GB and neither -Stop or -Start options were selected. Suggesting to run with -Stop option."
        $stop=$true
        $LeaveServiceRunning = $true
    }

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
        if ($stop) {
            Get-FreePhysicalMemory
            SleepProgress -Seconds 4}
        get-service -name $ServiceName|format-table status,name,StartType 
        Write-Warning "[END  ] Leaving: $($MyInvocation.Mycommand)"
    }
}

    # fjUnAiMe