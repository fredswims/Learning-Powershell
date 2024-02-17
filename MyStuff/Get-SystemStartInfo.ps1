Function Get-SystemStartInfo()
 {
 <#
 .Synopsis
 Get System Boot / Wake-up Time
 .DESCRIPTION
 This script retrieves system boot and wakeup times from the specified client(s).
 On Windows 8x clients, the last Wake-up time is the last time the system performed a
 fast boot.
 .PARAMETER Computer
 The name of one or multiple clients
 .EXAMPLE
 Get-SystemStartInfo localhost, dev001 | Format-Table -AutoSize

 Computer LastWakeupTime LastBootTime TimeZone
 -------- -------------- ------------ --------
 localhost 1/5/2014 11:55:41 PM 1/5/2014 2:35:44 PM (UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm,...
 dev001 1/5/2014 11:55:41 PM 1/5/2014 2:35:44 PM (UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm,...

.NOTES
 WinRM must be enabled on remote clients
 #>

[CmdletBinding()]
 Param(
    [Parameter(Mandatory=$true,
    ValueFromPipelineByPropertyName=$true,HelpMessage="Enter Computername(s)",
    Position=0)]
    [Alias("ipaddress","host")]
    [String[]]$Computer
    )

Begin
{
    Function Get-LocalTime($UTCTime,$Comp)
    {
        #Credits to Tao Yang for the Get-LocalTime function
        #http://blog.tyang.org/2012/01/11/powershell-script-convert-to-local-time-from-utc/
        #$strCurrentTimeZone = (Get-WmiObject win32_timezone).StandardName
        $strCurrentTimezone = Get-CimInstance -ComputerName $Comp -Namespace root/CIMV2 -ClassName win32_TimeZone | Select-Object -ExpandProperty StandardName -ErrorAction SilentlyContinue
        $TZ = [System.TimeZoneInfo]::FindSystemTimeZoneById($strCurrentTimeZone)
        $LocalTime = [System.TimeZoneInfo]::ConvertTimeFromUtc($UTCTime, $TZ)
        Return $LocalTime, $TZ
    }
}
Process
{
    $SystemStartInfo=@()
    foreach ($c in $Computer)
    {
        Write-Output "Processing $c"
        if (Test-Connection -ComputerName $c -Quiet -Count 3 )
        {
            # The last boot date time
            $LBootLocal = Get-CimInstance -ComputerName $c -Namespace root/CIMV2 -ClassName Win32_OperatingSystem -ErrorAction SilentlyContinue | Select -ExpandProperty LastBootuptime -ErrorAction SilentlyContinue
            If([string]::IsNullOrEmpty($LBootLocal) -eq $true)
            {
                # No last boot time found
                $LBootLocal=""
            }

            $PowerEvent = Invoke-Command -ComputerName $c -ScriptBlock {
            $orgCulture = Get-Culture
            [System.Threading.Thread]::CurrentThread.CurrentCulture = New-Object "System.Globalization.CultureInfo" "en-US"
            $PowerEvent = Get-WinEvent -ProviderName "Microsoft-Windows-Power-Troubleshooter" -MaxEvents 1 -ErrorAction SilentlyContinue | Where-Object { $_.id -eq 1 } | Select-Object -ExpandProperty  Message -ErrorAction SilentlyContinue
            [System.Threading.Thread]::CurrentThread.CurrentCulture = $orgCulture
            return $PowerEvent
            }

            If($PowerEvent.count -gt 0)
            {
                # Extract the Date / Time information when the system woke up
                $wake = ($PowerEvent.Replace("`n","@").split("@")[3]).replace("Wake Time: ","")
                [string]$utcyear = $wake.Substring(1,4)
                [string]$utcmonth = $wake.Substring(8,2)
                [string]$utcday = $wake.Substring(13,2)
                [string]$utchour = $wake.Substring(16,2)
                [string]$utcminute = $wake.Substring(19,2)
                [string]$utcseconds = $wake.Substring(22,2)
                $wakedt = $utcyear + $utcmonth + $utcday + $utchour + $utcminute + $utcseconds

                $Culture = [System.Globalization.CultureInfo]::InvariantCulture

                #The datetime in UTC format
                $LWUTC = [datetime]::ParseExact($wakedt,"yyyyMMddHHmmss",$Culture)
                # The datetime in Local Time format
                $LWLocal = Get-LocalTime $LWUTC $c
            }
            Else
            {
                #No last wake up event found, so let's just get the TimeZone information
                $TZName = Get-CimInstance -ComputerName $c -Namespace root/CIMV2 -ClassName win32_TimeZone | Select-Object -ExpandProperty StandardName -ErrorAction SilentlyContinue
                $TZ = [System.TimeZoneInfo]::FindSystemTimeZoneById($TZName)
                $LWLocal = "","$TZ"
                $PowerEvent = ""
            }

            $object = New-Object -TypeName PSObject
            $object | Add-Member -MemberType NoteProperty -Name "Computer" -Value $c
            $object | Add-Member -MemberType NoteProperty -Name "LastWakeupTime" -Value $LWLocal[0]
            $object | Add-Member -MemberType NoteProperty -Name "LastBootTime" -Value $LBootLocal
            $object | Add-Member -MemberType NoteProperty -Name "TimeZone" -Value $LWLocal[1]
            $object | Add-Member -MemberType NoteProperty -Name "Message" -Value $PowerEvent
            $SystemStartInfo += $object
        }
Else
        {
        Write-Verbose "Unable to connect to $c"
        }
    }
}
End
{
    return $SystemStartInfo
}
}
Get-SystemStartInfo "SuperComputer" | format-list
Get-SystemStartInfo "Super Computer@SUPERCOMPUTER"| format-list