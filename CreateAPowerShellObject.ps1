<#
How to create a PowerShell Object - in this case using WMI properties
#>

$bios = Get-WmiObject win32_OperatingSystem -ComputerName localhost | Select PSComputername
$Proc = Get-WmiObject Win32_processor -ComputerName localhost | Select-Object -First 1
$memory = Get-WmiObject Win32_physicalmemory -ComputerName localhost
$system= Get-WmiObject Win32_ComputerSystem -ComputerName localhost
$localdisk=Get-WMIObject Win32_Logicaldisk -filter "deviceid='C:'" -ComputerName localhost
$Object = New-Object PSObject -Property @{
ComputerName           = $proc.SystemName
Model                  = $system.Model
'Processor Number'     = $system.NumberOfProcessors
'Processor Name'       = $proc.name
'Logical Processor'   = $system.NumberOfLogicalProcessors
'RAM (GB)'             = $system.TotalPhysicalMemory / 1GB -as [int]
'Used RAM slot'        = $memory.count
'Local Disk c'         = $localdisk.size / 1GB -as [int]
}
Write-Output $Object


Get-CimInstance -Classname win32_OperatingSystem         