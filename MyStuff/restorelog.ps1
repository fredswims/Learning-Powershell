Get-EventLog -LogName application -InstanceId 8194 |
ForEach-Object {$i=1|Select-Object Event,Application; `
$i.Event, $i.Application = $_.ReplacementStrings[1,0]; $i}
Get-EventLog -LogName application -InstanceId 8194 |
ForEach-Object {$i=1|Select-Object Event,Application; `
$i.Event, $i.Application = $_.ReplacementStrings[1,0]; $i} |
Group-Object Application | select -ExpandProperty Name
