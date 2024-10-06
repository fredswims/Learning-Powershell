$count=0
do {
    $count++
    "write this line and the count {0}" -f $count

} until ($count -eq 5)

Clear-Host
Get-ChildItem