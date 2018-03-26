
<# calculated property
https://powershell.org/2013/04/29/name-that-property/
#>
gci  | select-object -property LastWriteTime, @{name="MyLabel";expression={$_.lastwritetime.toUniversalTime()}}
get-process | Sort-Object -Property BasePriority | Format-Table -GroupBy basepriority -wrap | more