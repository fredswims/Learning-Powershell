$testvar= "$env:homedrive$env:HOMEPATH\fredfred.txt"
$testvar

new-item -path $testvar -force
#remove-item $testvar
if (test-path -Path $testvar) -eq $true {
    Write-Host "I am going to delete $testvar"
    remove-item -Path $testvar -force
}
else {
    write-host "it is gone" -ForegroundColor Red
}

$fredpath=read-host
get-childitem $fredpath
