#Example 1
#passing an argument via reference
#and optionally, use 'return' to set a value to the function.

function Adder0 {
    param([ref]$a)
    write-host "**begin function**"
    $a.Value += 20
    Write-host "**assign 'return' and leave function**"
    return -1 #should be assigned to Adder
}

write-host "*start*"
$RtnValue = 0
$c = 5
$RtnValue = (Adder0([ref]$c)]) + 1
write-host "*display result*"
"c->$c"
"RtnValue->$RtnValue"

#Example 2
#Passing multiple arguments
function Adder1 {
    param([ref]$a, [ref]$b)

    $a.value += 20
    $b.value += 2
}

$c = 5
$d = 2
Adder1  ([ref]$c) ([ref]$d)
"c->$c"
"d->$d"

#Example 3
#Passing multiple arguments - like a conventional subroutine.
# and retrieving 'return' value of function
function Adder2 {
    param([ref]$a, [ref]$b)

    $a.value += 20
    $b.value += 2
    return -2
}
'*Begin'
$RtnValue = 0
$c = 5
$d = 2
$RtnValue = (Adder2 ([ref]$c) ([ref]$d)) + 1
'$c = {0} $d = {1} $RtnValue = {2}' -f $c, $d, $RtnValue
