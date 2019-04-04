Get-Process -IncludeUserName *chrome* | Group-Object username


get-process -IncludeUserName 
$fred = get-process -IncludeUserName

Get-ChildItem $pshomedir | ForEach-Object -Process {if (!$_.PSIsContainer) {$_.Name; $_.Length / 1024; "" }}
    

Get-Process | ForEach-Object -process { if ($_.Id -lt 80) {$_.id} }

Get-Process -IncludeUserName | ForEach-Object -process {if ($_.username -contains "Super") {$_.id; $_.username}}
get-process -IncludeUserName| ForEach-Object -Process { if ($_.id -lt 80) {$_.id, $_.username}}
get-process -IncludeUserName | ForEach-object -process { if ($_.username -like "*freds*") {$_.Id, $_.username}}-Begin {"Begin"} -End {"Finis"}
get-process -IncludeUserName | ForEach-Object -process { if ($_.username -Contains "FRED\freds_000") {$_.Id, $_.username}}-Begin {"Begin"} -End {"Finis"}
get-process -IncludeUserName| ForEach-Object -Process { if ($_.id -lt 80) {$_.id, $_.username}}

