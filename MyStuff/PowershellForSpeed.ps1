# https://adamtheautomator.com/building-powershell-for-speed/
<# 
$path=(join-path $env:temp "test.txt")
new-item $path
measure-command {Get-FileHash $path}
measure-command {Get-FileHash $path}
measure-command {Get-FileHash $path}

 #>
$last=0
1..10 | ForEach-Object {
	if ($Last) { $Last * $_ } 
	$Last = $_
}

$Array = @()
foreach ($Num in 1..10000) {
	if ($Last) { $Array += $Last * $Num } 
	$Last = $Num
}
#Array Array List ArrayList 
$ArrayList = New-Object System.Collections.ArrayList
foreach ($Num in 1..10) { 
	if ($Last) { $ArrayList.Add($Last * $Num) }
	$Last = $Num
}