for (){$t=2;for($i=1;$i -lt 171;$i++){$t=$t*$i;"count {0} value {1}" -f $i,$t}}
for (){$t=2;for($i=1;$i -lt 1024;$i++){$t=[Math]::Pow(2, $i);"count {0} value {1}" -f $i,$t}}
for(){get-uptime}
for(){get-uptime -Since;ShowWindowsComputerInfo}