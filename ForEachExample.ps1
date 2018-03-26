$PCName= $env:COMPUTERNAME
$PClist = ("pc1   ","  pc2","VAIoFRED")
foreach ($Pc in $PClist) {
#$pc
#$pc.ToUpper().trim()
$pc.trim().toUpper()
#$pc.ToUpper()
}
if ($PClist -contains $PCName) {Write-Host "right"} else {write-host "nope"}
