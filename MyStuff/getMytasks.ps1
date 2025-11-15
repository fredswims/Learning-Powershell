function Get-MyProcess {
    [CmdletBinding()]
    param ()
    
    Write-Warning "In script [$($PSCommandPath)]: [$(get-date -Format "dddd yyyy-MM-dd hh:mm:ss K")]"
    Write-Warning "In function [$($MyInvocation.MyCommand.Name)]: [$(get-date -Format "dddd yyyy-MM-dd hh:mm:ss K")]"
    Write-host "Getting current user identity..."
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $domain, $user = $identity.Name -split '\\'

    $results = @()

    $processes = Get-CimInstance -ClassName Win32_Process
    write-host ("Number of Processess `n`t[{0}]" -f $processes.Count)
    foreach ($proc in $processes) {
        try {
            $owner = Invoke-CimMethod -InputObject $proc -MethodName GetOwner
            if ([string]::IsNullOrEmpty($Owner)) {
                write-host "Process [$proc]"
                write-host "`$Owner [$Owner]"
            }
            if ($owner -and $owner.ReturnValue -eq 0) {
                if ($owner.User -eq $user -and $owner.Domain -eq $domain) {
                    $results += [PSCustomObject]@{
                        ProcessId = $proc.ProcessId
                        Name      = $proc.Name
                        User      = "$($owner.Domain)\$($owner.User)"
                    }
                }
            }
        } catch {
            # Skip processes that fail GetOwner (e.g., SYSTEM-owned or protected)
            write-host "In Catch Block with `$Proc [$Proc]"
            continue
        }
    }

    return $results
}

# $tasks=Get-MyProcess
# return $tasks
return get-MyProcess