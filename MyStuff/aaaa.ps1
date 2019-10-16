# Get Last Command
Function GetLastCommand($Number) {
    $CommandLength = (Get-History | Measure-Object).Count
    $Start = $CommandLength - $Number + 1
    [array]$CommandRange = @()
    Foreach ($obj in ($Start..$CommandLength)) { $CommandRange += $obj; $obj++ }
    (Get-History $CommandRange).CommandLine | Clip
    Write-Host -NoNewline "Last "; Write-Host -NoNewLine -ForegroundColor Green "$($Number) "; Write-Host "commands have been copied to the clipboard."
}

write-host "lets begin"
GetLastCommand -Number 5
gci
gci | test-path



gci | test-path
gci | test-path

param(
	[Parameter(Mandatory=$true,
			ValueFromPipeline = $true,
			HelpMessage = "Enter an interger.")]
	[Int]
	$code=99,

 	$name="fred",
	$namer="Irving"
)
"The value of `$name is {0}." -f $name
write-host "The value of `$Namer is $($namer)."
exit $code
