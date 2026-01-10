Function fjUnAiMe {
    [CmdletBinding()]
    param(
        $LimitGB = 1,        # Less than or equal triggers the -stop opton.
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
            $freeGB1 = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue / 1KB
            # write-warning ("Free Physical Memory: {0} GB" -f $($(Get-ComputerInfo).OsFreePhysicalMemory / (1024*1024)))
            Write-Host ("[{0:N3} GB] Free Physical Memory " -f $freeGB1 ) 
            $freeGB1 # return
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
    # Write-Host "[*BEGIN  ] Starting: $($MyInvocation.Mycommand)" -ForegroundColor Green
    Write-Host "[*BEGIN  ] Starting:`$pscommandpath $($PSCommandPath)" -ForegroundColor Green

    # Define Service and Process Names
    $ServiceName = "WSAIFabricSvc"
    $ProcessName = ( "WorkLoadsSessionManager", "WorkloadsSessionHost")
    [string]$MyMode=$null # returned to caller. What was done.
    
    # Cant have -Start and -Stop option at the same time.
    if ($Start -and $Stop) { Write-Warning "Both the -Start and -Stop options were selected. Terminating."; return }
    # Are we elevated?
    $IsElevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    Write-Host "IsElevated: $IsElevated "
    if (($Stop -or $Start) -and !$IsElevated) {
        Write-Warning "You must be elevated to run with -Stop or -Start option. Terminating."
        return "Not Elevated"
    }
    
    $FreePhysicalMemory = Get-FreePhysicalMemory #get Free Physical Memory
    Write-Host ("[{0:N3} GB] Limit/Trigger" -f $LimitGB ) 
    if( $FreePhysicalMemory -le $LimitGB ) {
        $beLowGB=$true
        write-host "Free Physical Memory is low."
        $MyMode += " Memory Low:" 
    }
    else {
        $beLowGB = $false
        write-host "Free Physical Memory is sufficient."
        $MyMode += " Memory Low:" 
    }
    
    # What processess are we looking for?
    Write-Host "Checking for Processes: $($ProcessName -join ', ')"
    $Tasks = get-process $ProcessName -ErrorAction SilentlyContinue
    # How many processes are running? 
    write-host "[$($Tasks.Count)] Instances of $($ProcessName -join ' & ') are running."
    # List each process and its memory usage
    Foreach ($Task in $Tasks) {
        write-host " `tPID: $($Task.Id) `tMemory Usage (GB): $([math]::Round($Task.WorkingSet64 /1GB,3)) `t$($task.name)"
    }
    
    # How much memory is used by each instance of $ProcessName.
    $freeGB = $($tasks | Measure-Object -property WorkingSet64 -sum).sum
    Write-Host ("[{0:N3} GB] Physical Memory Used by {1}" -f $($freeGB / 1GB), $($ProcessName -join ' & ') )
    
    if ((!$stop -and !$Start) -and ($beLowGB -and $Auto)) {
        Write-Warning "Physical Memory is below or equal to $LimitGB GB and neither -Stop or -Start options were selected. Suggesting to run with -Stop option."
        $stop=$true
        $LeaveServiceRunning = $true
    }
    
    try {
        if ($Stop) {
            $MyMode += " Stop:"
            $tasks.foreach{stop-process -id $_.id -force -Verbose} 

            if (-not $LeaveServiceRunning) {
                Set-Service -Name $ServiceName -StartupType Disabled  -verbose
                Stop-Service -Name $ServiceName -Force -Verbose
            }
        }
        if ($Start) {
            $MyMode += " Start:"
            Set-Service -Name $ServiceName -StartupType AutomaticDelayedStart -Verbose && Start-Service -Name $ServiceName -Verbose
        }
    }
    catch {
        write-host "An error occured"
        Get-Error
    }  
    finally {
        <#Do this after the try block regardless of whether an exception occurred or not#>
        if ($stop) {
            SleepProgress -Seconds 4 # Give the system a moment to settle.
            Get-FreePhysicalMemory
        }
        get-service -name $ServiceName|format-table status,name,StartType 
        write-host ("`$MyMode is [{0}]" -f $MyMode) -ForegroundColor Green
        Write-Warning "[END  ] Leaving: $($MyInvocation.Mycommand)"

$MyReturn = [PSCustomObject]@{
    Mode = $mymode
}

        $MyReturn # return $MyMode
    }
}

    # fjUnAiMe