$a= Get-EventLog -LogName "Windows Powershell"
$a | Select-Object -Index 0, ($a.count -1)

Get-Process explorer |Select-Object -Property processname, -expandproperty modules
Get-Process Explorer | Select-Object -Property ProcessName -ExpandProperty Modules | Format-List