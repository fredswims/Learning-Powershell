function Factorial1 ($number) {
write-host "Inside function with argument equal to $number"
if ($number -le 1) {return [int]1} 
else {return "$(Factorial1 ($number-1)) * $number"}
}
$fred=0
$fred=Factorial1 (5)
write-host "Returned from calling function"
$fred

function Factorial ($number) {
write-host "Inside function with argument equal to $number"
if ($number -le 1) {return [int]1} 
else {return $(Factorial ($number-1)) * $number}
}
$fred=0
$fred=Factorial (5)
write-host "Returned from calling function"
$fred
