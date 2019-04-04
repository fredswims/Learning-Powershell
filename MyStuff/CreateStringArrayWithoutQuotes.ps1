# http://powershell.com/cs/blogs/tips/archive/2013/05/14/creating-string-arrays-without-quotes.aspx
$MachineType = Write-Output Native I386 Itanium x64
$Machinetype

Write-Output Native I386 Itanium x64 | Set-Content -Path TESTFILE
