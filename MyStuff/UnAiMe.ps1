<# 
function Get-WorkloadStatus {
    Write-Host "`n=== Workload / AI Fabric Status ===`n"

    # Processes
    $procs = "WorkloadsSessionHost","aixhost","aihost","RecallHost"
    foreach ($p in $procs) {
        $running = Get-Process $p -ErrorAction SilentlyContinue
        if ($running) {
            Write-Host "Process: $p  PID(s): $($running.Id -join ', ')"
        } else {
            Write-Host "Process: $p  (not running)"
        }
    }

    # Services
    $svcNames = "WSAIFabricSvc","AIInferenceService","WorkloadManagerSvc"
    foreach ($svc in $svcNames) {
        $s = Get-Service -Name $svc -ErrorAction SilentlyContinue
        if ($s) {
            Write-Host "Service: $($s.Name)  Status: $($s.Status)  Startup: $($s.StartType)"
        } else {
            Write-Host "Service: $svc  (not installed)"
        }
    }

    # Optional Features
    $features = "AIInference","WorkloadManager","Recall"
    foreach ($f in $features) {
        $feat = Get-WindowsOptionalFeature -Online -FeatureName $f -ErrorAction SilentlyContinue
        if ($feat) {
            Write-Host "Feature: $($feat.FeatureName)  State: $($feat.State)"
        } else {
            Write-Host "Feature: $f  (not present)"
        }
    }

    Write-Host "`n=====================================`n"
}
# get-workloadstatus

function Set-WorkloadState {
    param(
        [Parameter(Mandatory)]
        [ValidateSet("Enable","Disable")]
        [string]$State
    )

    $services = "WSAIFabricSvc","AIInferenceService","WorkloadManagerSvc"
    $features = "AIInference","WorkloadManager","Recall"

    if ($State -eq "Disable") {
        Write-Host "Disabling Workload / AI Fabric components..."

        foreach ($svc in $services) {
            if (Get-Service $svc -ErrorAction SilentlyContinue) {
                Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
                Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
            }
        }

        foreach ($f in $features) {
            Disable-WindowsOptionalFeature -Online -FeatureName $f -NoRestart -ErrorAction SilentlyContinue
        }

        # Kill any remaining processes
        "WorkloadsSessionHost","aixhost","aihost","RecallHost" |
            ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }

        Write-Host "Workload subsystem disabled."
    }

    if ($State -eq "Enable") {
        Write-Host "Enabling Workload / AI Fabric components..."

        foreach ($svc in $services) {
            if (Get-Service $svc -ErrorAction SilentlyContinue) {
                Set-Service -Name $svc -StartupType Automatic -ErrorAction SilentlyContinue
                Start-Service -Name $svc -ErrorAction SilentlyContinue
            }
        }

        foreach ($f in $features) {
            Enable-WindowsOptionalFeature -Online -FeatureName $f -NoRestart -ErrorAction SilentlyContinue
        }

        Write-Host "Workload subsystem enabled."
    }
}
    
 #>
 
 
 #region WorkloadsSessionHost
Function fjUnAiMe {
    param(
        $name,
        $age,
        [switch]$Stop=$false
    )
    Clear-Host
    $ProcessName = "WorkloadsSession*"
    $Tasks = get-process $ProcessName 
    # Foreach ($Task in $Tasks) { write-host "$($task.name) `n`tPID: $($_.Id) `tMemory Usage (GB): $([math]::Round($_.WorkingSet64 /1GB,2))" }
    # get total memory used by all WorkloadsSessionHost processes
    write-host "`n Total Memory Used by WorkloadsSessionHost Processes:"
    # $tasks | Measure-Object WorkingSet64 -sum | select-object -Property @{ Name = " GB of Memory"; Expression = { $($_.sum) / 1GB } }

    <#
    if ($false) {
        try {
            $tasks.foreach{stop-process -id $_.id -force} 
            Set-Service -Name "WSAIFabricSvc" -StartupType Disabled 
            Stop-Service -Name "WSAIFabricSvc" -Force 
        }
        catch {
            write-host "An error occured"
            Get-Error
        }    
    }
    #>
}
#endregion
    