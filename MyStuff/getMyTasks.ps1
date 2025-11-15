function Get-MyTasks {
    [CmdletBinding()]
    param ()
    Write-Warning "In script [$($PSCommandPath)]: [$(get-date -Format "dddd yyyy-MM-dd hh:mm:ss K")]"
    Write-Warning "In function [$($MyInvocation.MyCommand.Name)]: [$(get-date -Format "dddd yyyy-MM-dd hh:mm:ss K")]"
    Write-host "Getting current user identity..."

    $faults = 0 # usually from Get-CimInstance
    $processed = 0
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $domain, $user = $identity.Name -split '\\'

    $results = @()

    $processes = Get-CimInstance -ClassName Win32_Process
    write-host ("Number of Processess `n`t[{0}]" -f $processes.Count)

    foreach ($proc in $processes) {
        try {
            $owner = Invoke-CimMethod -InputObject $proc -MethodName GetOwner -ErrorAction Stop
            if ($owner.ReturnValue -eq 0 -and
                $owner.User -eq $user -and
                $owner.Domain -eq $domain) {

                $results += [PSCustomObject]@{
                    ProcessId = $proc.ProcessId
                    Name      = $proc.Name
                    User      = "$($owner.Domain)\$($owner.User)"
                }
                $processed++
            }
        }
        catch {
            Write-host "In Catch Block `n`tSkipped $($proc.Name) (PID $($proc.ProcessId)): $_"
            $faults++
            continue
        }
    } # end foreach
    
    write-host "Number of Faults [$faults]"
    write-host "Number of tasks [$Processed]"
    Write-Warning "Leaving script [$($PSCommandPath)]: [$(get-date -Format "dddd yyyy-MM-dd hh:mm:ss K")]"
    return $results
}
Get-MyTasks