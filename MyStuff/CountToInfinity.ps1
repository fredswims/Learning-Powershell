cls
$val=0
$alphabet=for($test=0; $test -lt 26; $test++)
{[char](65+$test)
}
while ($val -ne 10000000000000000000000000000000000000000)
{
$val++
write-host -NoNewline $val -BackgroundColor red -ForegroundColor white
#Start-Sleep 1
}

cls
$val=0
$alphabet=for($test=0; $test -lt 26; $test++)
{[char](65+$test)
}
#$fred=while ($val -ne 10000000000000000000000000000000000000000)
$fred=while ($val -ne 10)

{
$val++
write-host -NoNewline $val -BackgroundColor red -ForegroundColor white
#Start-Sleep 1
}
$fred
$fred.count