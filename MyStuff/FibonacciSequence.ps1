Clear-Host
$a=0
$b=0
for ($i=0;$i -lt 100;$i++) {
    if($i -eq 0) {$b=0}
    else {if($i -eq 1) {$b=1}}
    else {$b=
    
    $a = $b + $i
    $b=$a
    "$b"
    }