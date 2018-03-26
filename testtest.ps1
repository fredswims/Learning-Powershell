function fred ($string) {

begin {
    write-host "Good Moring Jim"
}
process {
    foreach ($name in $string){
    write-host $string}
}

end {
    write-host "I like the way it splits"
}}


fred "ellen,fred,bea,irv"

$a=@("ellen","fred","bea", "irv")
fred ($a)
