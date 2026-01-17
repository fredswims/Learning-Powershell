Function fjUnAiMe {
    <#
        .SYNOPSIS
        Frees up AI memory.
        AUTHOR:FAJ January 2026
        REVISION HISTORY:FAJ 2026.01.17 Version 1.1.1

        .DESCRIPTION
        PURPOSE: Free-Java-AI-Memory. Stops WSAIFabricSvc and related processes when physical memory is low.
        Optionally just stops the processes "WorkLoadsSessionManager", "WorkloadsSessionHost" and leaves the service running.

        .PARAMETER Id
        ?Unique string identifying this header instance. Used for replacement or updating by reuse.

        .PARAMETER Title
        ?The text displayed to the user as the header.

        .PARAMETER Arguments
        ?String data passed to Activation if the header itself is clicked.

        .PARAMETER ActivationType
        ?Enum specifying the activation type (defaults to Protocol).

        .INPUTS
        None. You cannot pipe input to this function.

        .OUTPUTS
        Custom Object: 
            Mode  - what actions were taken
            Return - ($True/$False)
        A BurntToast Notification

        .EXAMPLE
        ?New-BTHeader -Title 'First Category'
        Creates a header titled 'First Category' for categorizing toasts.

        .EXAMPLE
        ?New-BTHeader -Id '001' -Title 'Stack Overflow Questions' -Arguments 'http://stackoverflow.com/'
        Creates a header with ID '001' and links activation to a URL.

        .LINK
        ?https://github.com/Windos/BurntToast/blob/main/Help/New-BTHeader.md
    #>
    [CmdletBinding()]
    param(
        $TriggerGB = 0.500,         # Used with $Auto 
        [switch]$Auto = $false,     # Free memory if 'Free Physical Memory' -le $TriggerGB
        [switch]$Stop = $false,     # Free memory by stopping the related processes (WorkloadsSessionManager, WorkloadsSessionHost).
        [switch]$StartService = $false, # Start the service.
        [switch]$StopService = $false   # Stop the service.
    )

        Function Get-FreePhysicalMemory {
        [CmdletBinding()]
        param()
            Write-Host "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
            # Get Free Physical Memory
            $freeGB1 = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue / 1KB
            # write-warning ("Free Physical Memory: {0} GB" -f $($(Get-ComputerInfo).OsFreePhysicalMemory / (1024*1024)))
            Write-Host ("[{0:N3} GiB] Free Physical Memory " -f $freeGB1 ) 
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
    # Write-Host "[*BEGIN  ] Starting: $($MyInvocation.Mycommand):" -ForegroundColor Green
    Write-Host "[*BEGIN  ] Starting:`$pscommandpath $($PSCommandPath):V1" -ForegroundColor Green

    # Define Service and Process Names
    $ServiceName = "WSAIFabricSvc"
    $ProcessName = ( "WorkLoadsSessionManager", "WorkloadsSessionHost")
    [string]$MyMode="" # returned to caller. What was done.
    
    if (-not $Auto -and -not $Stop -and -not $StartService -and -not $StopService) {
        write-warning "No options selected. Reporting only"
    }
    # Cant have -Start and -Stop option at the same time.
    if ($StartService -and $Stop) { Write-Warning "Both the -Start and -Stop switches were selected. Terminating."; return }
    # Are we elevated?
    $IsElevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    Write-Host "IsElevated: $IsElevated "
    if (($Auto -or $Stop -or $StartService -or $StopService) -and -not $IsElevated) {
        Write-Warning "You must be elevated to run with any switches. Terminating."
        return "Not Elevated"
    }
    
    $FreePhysicalMemory = Get-FreePhysicalMemory #get Free Physical Memory
    Write-Host -msg ("[{0:N3} GiB] Trigger Threshold" -f $TriggerGB )


    if( $FreePhysicalMemory -le $TriggerGB ) {
        $beLowGB=$true
        write-host "Free Physical Memory is low."
        $MyMode += "[Low-Memory] " 
    }
    else {
        $beLowGB = $false
        write-host "Free Physical Memory is sufficient."
        # $MyMode += "[Sufficient-Memory] " 
    }
    
    # What processess are we looking for?
    Write-Host "Checking for Processes: $($ProcessName -join ', ')"
    $Tasks = get-process $ProcessName -ErrorAction SilentlyContinue
    # How many processes are running? 
    write-host "[$($Tasks.Count)] Instances of $($ProcessName -join ' & ') are running."
    # List each process and its memory usage
    Foreach ($Task in $Tasks) {
        write-host " `tPID: $($Task.Id) `tMemory Usage (GiB): $([math]::Round($Task.WorkingSet64 /1GB,3)) `t$($task.name)"
    }
    
    # How much memory is used by each instance of $ProcessName.
    $AIusedGB = $($tasks | Measure-Object -property WorkingSet64 -sum).sum /1GB
    Write-Host ("[{0:N3} GiB] Physical Memory Used by {1}" -f $($AIusedGB), $($ProcessName -join ' & ') )
    
    # -Auto works alone.
    if ((!$stop -and !$StartService -and !$StopService) -and ($beLowGB -and $Auto)) {
        Write-Warning -msg (
            "Available Memory [$FreePhysicalMemory] is less than or equal to [$TriggerGB] GiB `
            and neither -Stop or -Start switches were selected. `
            -> Running with -Stop option. <-" `
            )
        $Stop=$true
        $StopService = $false
    }
    
    try {
        if ($Stop) {
            $MyMode += "[Stop] "
            $tasks.foreach{stop-process -id $_.id -force -Verbose}
        } 
        
        if ($StopService) {
            #neither of these two cmdlets return an object.
            Set-Service -Name $ServiceName -StartupType Disabled  -verbose
            if (!(get-service -Name $ServiceName)) {
                $MyMode += "[Service-Disabled] "
                Stop-Service -Name $ServiceName -Force -Verbose}
            else {
                    Write-Warning "[$ServiceName] is already stopped"
            }
        }

        if ($StartService) {
            #neither of these two cmdlets return an object.
            Set-Service -Name $ServiceName -StartupType AutomaticDelayedStart -Verbose
            if (!(get-service -Name $ServiceName)) {
                $MyMode += "[Start] "
                Start-Service -Name $ServiceName -Verbose}
            else {
                Write-Warning "[$ServiceName] is already running"
            }
        }
    }
    catch {
        write-host "An error occured"
        Get-Error
    }  
    finally {
        <#Do this after the try block regardless of whether an exception occurred or not#>
        if ($stop) {
            # show available memory
            SleepProgress -Seconds 4 # Give the system a moment to settle.
            $FinalFreeGB = Get-FreePhysicalMemory
        }

        $gs = Get-Service -name $ServiceName # don't let the object go down the pipeline.
        Write-Host -msg ("Service-Name -> [{1}] Status -> [{0}] StartupType -> [{2}]" `
        -f $gs.status, $gs.name,$gs.StartUpType) -ForegroundColor Green
        
        $MyMode += "[Free: $([math]::Round($FreePhysicalMemory,3)) GiB] "
        $MyMode += "[Trigger: $TriggerGB GiB] " 
        $MyMode += "[AI: $([math]::Round($AIusedGB,3)) GiB] " 
        If ($Stop) {$MyMode += "[FinalFreeMemory: $([math]::Round($FinalFreeGB,3)) GB] "}

        $MyMode = $MyMode.trim()
        write-host ("`$MyMode is {0}" -f $MyMode) -ForegroundColor Green
        Write-Warning "[END  ] Leaving: $($MyInvocation.Mycommand)"

        $MyReturn = [PSCustomObject]@{
            Mode = $mymode;
            'StartingFreeMemory' = $FreePhysicalMemory
            'Trigger' = $TriggerGB;
            'AIUsed' = $AIusedGB;
            'FinalFreeMemory' = $FinalFreeGB;
            'ReturnCode' = $True
        }
        $MyReturn # return $MyMode
    } #end finally
} #end function fjUnAiMe

    # source it 
    #   . (join-path $home MyStuff fjUnAIme.ps1)
    #  fjUnAiMe -Auto [-TriggerGB 5.000]
    #  fjUnAiMe -Stopservice