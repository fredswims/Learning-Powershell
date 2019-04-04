$myfile="fredtest.txt"
Add-Content -path $myfile "`r"
Add-Content -path $myfile "`r"
$a=get-date
Add-Content -path $myfile $a
notepad $myfile
