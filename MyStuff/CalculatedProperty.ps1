
<# calculated property
https://powershell.org/2013/04/29/name-that-property/
#>
Get-ChildItem  | select-object -property LastWriteTime, @{name = "MyLabel"; expression = {$_.lastwritetime.toUniversalTime()}}

Get-ChildItem  | select-object -property LastWriteTime, @{n = "MyLabel"; e = {$_.lastwritetime.toUniversalTime()}}

get-process | Sort-Object -Property BasePriority | Format-Table -GroupBy basepriority -wrap