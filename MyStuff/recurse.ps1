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

function Recurse {
    param (
        [int64]$number
    )
    Write-Warning $number
    if ($number -eq 1) {
        return $number   
    }
    else { 
        Write-Warning "callingx "
        return  $(recurse ($number - 1)) * $number
    }
}    
$answer=recurse 5
$answer=recurse 150
$answer
recurse 5
