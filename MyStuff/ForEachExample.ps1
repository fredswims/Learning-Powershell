$PCName= $env:COMPUTERNAME
$PClist = ("pc1   ","  pc2","VAIoFRED","BOOK4EDGE")
foreach ($Pc in $PClist) {
#$pc
#$pc.ToUpper().trim()
# $foreach
$pc.trim().toUpper()
#$pc.ToUpper()
}
if ($PClist -contains $PCName) {Write-Host "right"} else {write-host "nope"}
