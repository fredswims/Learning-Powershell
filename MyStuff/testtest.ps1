
function DoThis ($cmd){
    Invoke-Expression $cmd
    if ($?) {"{0} completed" -f $cmd} else {"{0} failed" -f $cmd}
}
"begin"
cd ~
($cmd = "copy-item fred ellen")
Dothis $cmd
"end"


#Out_currentFile
$fred= @"
Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
    357      56    60736      28236       9.75    776   5 Code
    393      32    43056      26784       5.20  11436   5 Code
    924      52    44536      73120     118.41  11564   5 Code
    230      20    19740      21060       1.11  12804   5 Code
    534      34   375668     170400      80.05  13748   5 Code
    216      14     6424       2524       0.09  15284   5 Code
    506      69   197040     179708     529.98  17844   5 Code
    281      16    10284       8904       0.16   9828   5 CodeHelper
"@
write-host $fred

$years=(1796..1900);foreach ($year in $years) {"{0} {1} ********************" -f$year,[datetime]::isleapyear($year)}
$year=(1796..1900);foreach ($year in $years) {if ([datetime]::IsLeapYear($year)) {"{0} is a leap year"-f $year} else {"$year is not a leap year"}}

