set-location $env:HOMEPATH
set-location desktop    
$fred=Get-Content home.qif
#$ellen= $fred | ForEach-Object {$_ -replace "`n",""}
$ellen= $fred -join ("`n") #make one big record
$bea=$ellen.split("^") #make into multiple records
$Nipsco=$bea | Where-Object {$_ -like "*Nipsco*"} 
