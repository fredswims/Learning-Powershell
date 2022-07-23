param (
    [Parameter(Mandatory = $true, HelpMessage = "Enter the name of a file to speak; e.g., SayThis.txt : ")]
    [System.IO.FileInfo]
    $FileName1,
    [Parameter(Mandatory = $true, HelpMessage = "Enter the name of a file to speak; e.g., SayThis.txt : ")]
    [string[]]
    $string,

    [Parameter(Mandatory = $false)]
    [switch]
    $Speak
)
Write-host "Filename is $($FileName1)"
write-host "Speak is $($Speak)"
Write-Host "hello there"
$fred="Fred-Arthur"
Write-host $fred
$a=0
for ($i=0;$i -lt 10;$i++){$a=$a+1;"The value of variable 'a' is {0}" -f $a}
Write-Warning "I am done"
