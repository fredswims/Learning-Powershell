#Reverse a file including blank lines.
$TempFile=New-TemporaryFile
#'Set-Content' add x0D x0A to the end of the file. `n is x0A
set-content -path $TempFile -Value "The big`nbrown fox`n`njumps over the lazy`n`n`ndog."
start-process -Wait notepad $TempFile 
$StringIn = Get-Content -Path $TempFile -Raw
#Set-Content -Path TempFile.txt -Value ($x[($x.Length-1)..0]) #only reverse lines
$arrayX=$StringIn.ToCharArray()
[array]::Reverse($arrayX)
$StringOut= -join($arrayX[2..($arrayX.length-1)])
#$StringOut.replace(" ","`n")
set-content -path $TempFile -Value $StringOut
start-process -wait notepad $TempFile
remove-item $tempfile