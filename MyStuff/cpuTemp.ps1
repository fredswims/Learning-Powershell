# https://social.technet.microsoft.com/Forums/lync/en-US/badf142e-2c34-4d6b-9362-d411e7f3b3a5/get-the-cpu-temperature-with-powershell?forum=ITCG
# https://www.remkoweijnen.nl/blog/2014/07/18/get-actual-cpu-clock-speed-powershell/
"In script {0}" -f $MyInvocation.MyCommand.Name
"Retreiving Temperature"
function GetClockSpeed()
{
$freq = Get-Counter -Counter "\Processor Information(*)\Processor Frequency"
$item = New-Object  System.Object
foreach ($cpu in $freq.CounterSamples)
{
$procNum = ([RegEx]::Match($cpu.Path, '.+\((\d+,\d+)\).*')).Groups[1].Value
if ($procNum)
{
$item | Add-Member -Type NoteProperty -Name $procNum -Value $cpu.CookedValue
}
}
$item
}
$x=@{n="Temps F";e={(($_.currenttemperature /10 -273.15) *1.8 +32)}}
do {
    "GetClockSpeed"
    GetClockSpeed |format-list *
    $MaxClockSpeed=@{n="Max Clock Speed";e={"{0} GHz" -f (1 * $_.maxclockspeed / 1000)}}
    $property = "systemname","maxclockspeed","addressWidth","numberOfCores","NumberOfLogicalProcessors"
    Get-WmiObject -class win32_processor -Property  $property | Select-Object -Property systemname,addresswidth,numberofcores, $MaxClockSpeed |format-list *




    $temps = Get-WMIObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
    $temps | Select-Object -Property InstanceName,$x
<# 
    $temps = Get-WMIObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
    $temps | Select-Object -Property InstanceName,@{n="Temps F";e={(($_.currenttemperature /10 -273.15) *1.8 +32)}}
     #>
    sleep -seconds 5
} while ($true)

<#
$objWMi = get-wmiobject -namespace root\cimv2 -computername localhost -Query "Select * from Win32_PerfFormattedData_Counters_ThermalZoneInformation WHERE Name like '%GFXZ%'"
$objWMi = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
foreach ($obj in $objWmi)
{
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