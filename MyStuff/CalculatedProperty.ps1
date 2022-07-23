
<# calculated property
https://powershell.org/2013/04/29/name-that-property/
#>
Get-ChildItem  | select-object -property LastWriteTime, @{name = "MyLabel"; expression = {$_.lastwritetime.toUniversalTime()}}
Get-ChildItem  | select-object -property LastWriteTime, @{n = "MyLabel"; e = {$_.lastwritetime.toUniversalTime()}}
#can use 'label' or '1' instead of 'name'
#alternately
$Whatever=@{n = "MyLabel"; e = {$_.lastwritetime.toUniversalTime()}}
Get-ChildItem  | select-object -property LastWriteTime, $Whatever
get-process | Sort-Object -Property BasePriority | Format-Table -GroupBy basepriority -wrap
for ($i=0;$i -lt 10; $i++){
    "the value of variable i is {0} $i"
}