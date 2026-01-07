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



get-process WorkloadsSessionHost |stop-process  
Set-Service -Name "WSAIFabricSvc" -StartupType Disabled 
Stop-Service -Name "WSAIFabricSvc" -Force 




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