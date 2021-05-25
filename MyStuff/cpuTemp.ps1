#2021-05-24 
# https://social.technet.microsoft.com/Forums/lync/en-US/badf142e-2c34-4d6b-9362-d411e7f3b3a5/get-the-cpu-temperature-with-powershell?forum=ITCG
# https://www.remkoweijnen.nl/blog/2014/07/18/get-actual-cpu-clock-speed-powershell/
# https://www.thomasmaurer.ch/2020/03/whats-new-in-powershell-7-check-it-out/
param (
    [int32]$Sleep = 60,
    [switch]$Pause=$false
)
"In script {0}" -f $MyInvocation.MyCommand.Name
function GetClockSpeed() {
write-warning "In function $($MyInvocation.MyCommand.Name)"
$freq = Get-Counter -Counter "\Processor Information(*)\Processor Frequency"
$item = New-Object  System.Object
foreach ($cpu in $freq.CounterSamples) {
    $procNum = ([RegEx]::Match($cpu.Path, '.+\((\d+,\d+)\).*')).Groups[1].Value
    if ($procNum) {
        $item | Add-Member -Type NoteProperty -Name $procNum -Value $cpu.CookedValue
    }
}
$item
$item=$null
}
Function GetCpuTemperature {
# "In function {0}" -f $MyInvocation.MyCommand.Name
Write-warning "In function $($MyInvocation.MyCommand.Name)"

try {$Temperature = @{n = "Temperature in Fahrenheit"; e = { (($_.currenttemperature / 10 - 273.15) * 1.8 + 32) } }

        $TempInC = Get-WMIObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
        $TempObj=$TempInC | Select-Object -Property InstanceName, $Temperature | format-list *
}
catch {
        write-warning "$error"        
}
$TempObj
}

# Must be elevated
$user = [Security.Principal.WindowsIdentity]::GetCurrent()
if ((New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {}
else {
    "Process must run elevated."; read-host "Enter to terminate"; return
}

# "First Get system information, then clock speed and then temperature"

$MaxClockSpeed = @{n = "Max Clock Speed"; e = { "{0} GHz" -f (1 * $_.maxclockspeed / 1000) } }
[boolean]$FirstTime = $true

for ($i = 1; $i -lt 5000; $i++) {
    "Beginning Loop {0}" -f $i
    Get-Date
    "Get System information"
    if ($FirstTime) {
        $property = "SystemName", "MaxClockSpeed", "AddressWidth", "NumberOfCores", "NumberOfLogicalProcessors"
        $SystemInfo = Get-WmiObject -class win32_processor -Property  $property | Select-Object -Property SystemName, AddressWidth, NumberOfCores, $MaxClockSpeed | format-list *
        $FirstTime = $false
    }    
    $SystemInfo

    "Get Clock Speed of each Core"
    GetClockSpeed | format-list *
    
    "Get CPU Temperature"
    $TempObject=GetCpuTemperature
    "returned"
    if ($i -eq 1) {
        $FirstTempObject = $TempObject
        $TempObject
    }
    else {
        $TempObject
        Write-Warning "First Temperature"
        $FirstTempObject
    }

    <#      
    $objWMi = get-wmiobject -namespace root\cimv2 -computername localhost -Query "Select * from Win32_PerfFormattedData_Counters_ThermalZoneInformation WHERE Name like '%GFXZ%'"
    $objWMi = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
    foreach ($obj in $objWmi) {
        write-host "######## INICIO Win32_PerfFormattedData_Counters_ThermalZoneInformation"
        write-host "Caption:" $obj.Caption
        write-host "Description:" $obj.Description
        write-host "Frequency_Object:" $obj.Frequency_Object
        write-host "Frequency_PerfTime:" $obj.Frequency_PerfTime
        write-host "Frequency_Sys100NS:" $obj.Frequency_Sys100NS
        write-host "Name:" $obj.Name
        write-host "PercentPassiveLimit:" $obj.PercentPassiveLimit
        write-host "Temperature:" (($obj.Temperature -273.15))
        write-host "ThrottleReasons:" $obj.ThrottleReasons
        write-host "Timestamp_Object:" $obj.Timestamp_Object
        write-host "Timestamp_PerfTime:" $obj.Timestamp_PerfTime
        write-host "Timestamp_Sys100NS:" $obj.Timestamp_Sys100NS
        write-host
        write-host "######## INICIO Win32_PerfFormattedData_Counters_ThermalZoneInformation"
        write-host
    }
 #>
    write-host "Next sample in $($sleep) seconds."
    "Ending Loop {0}" -f $i
    Start-Sleep -seconds $Sleep
    # if ($Pause) {Read-Host "pause"}
}