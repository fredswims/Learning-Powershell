Get-ChildItem $home\desktop | ForEach-Object -Process {if (!$_.PSIsContainer) {$_.Name; $_.Length / 1024; "" }}
$fred=dir C:\Users\freds_000\Desktop
$fred | ForEach-Object -process { if ($_.Extension = contains ".lnk") {$_.name}}
$fred= dir $home\desktop
$fred | ForEach-Object -Process { if ($_.extension -eq ".lnk") {write-host $_.name} } | ft
ForEach-Object  -InputObject $fred.name -Process { if ($_.extension -eq ".lnk") {write-host $_.name} }
$fred=dir C:\Users\freds_000\Desktop
$fred.name | Select-object -Pattern ".lnk" 

$a
