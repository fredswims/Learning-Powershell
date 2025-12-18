function Get-MyLogonTime {
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $domain, $user = $identity.Name -split '\\'

    $logonLinks = Get-CimInstance Win32_LoggedOnUser
    $logonSessions = Get-CimInstance Win32_LogonSession | Where-Object {
        $_.LogonType -eq 2  # Interactive
    }

    foreach ($link in $logonLinks) {
        $account = $link.Antecedent -replace '^.*Domain="([^"]+)",Name="([^"]+)".*$', '$1\$2'
        $logonId = $link.Dependent -replace '^.*LogonId="([^"]+)".*$', '$1'

        if ($account -eq "$domain\$user") {
            $session = $logonSessions | Where-Object { $_.LogonId -eq $logonId }
            if ($session) {
                return [System.Management.ManagementDateTimeConverter]::ToDateTime($session.StartTime)
            }
        }
    }

    return $null
}