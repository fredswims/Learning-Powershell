$refString = @"
fred arthur,
 ,
ellen,
brown
"@
$diffString = @"
fred,
ellen,
bea,
irv,
yellow
"@
$refArray = $null
$diffArray = $null
<# 
# Split on line breaks and remove empty entries
$refarray = $refstring -split "`r`n" | Where-Object { $_.Trim() -ne "" }
# Optional: Trim each entry
$refarray = $refarray | ForEach-Object { $_.Trim() }
# remove the trailing comma from "fred,", you can add a cleanup step:
$refarray = $refarray | ForEach-Object { $_.TrimEnd(',') }
# Output the array
$refarray

 #>
$refArray = $($refstring -split "`r`n").foreach{$_.TrimEnd(',')} | Where-Object { $PSItem -notlike " " }
$diffArray = $($diffString -split "`r`n").foreach{$_.TrimEnd(',')} | Where-Object { $PSItem -notlike " " }

<# 
$refArray = $refArray | ForEach-Object { $_.TrimEnd(',') }
$diffArray = $diffString -split "`r`n" | Where-Object { $_.Trim() -ne "" }
$diffArray = $diffArray | ForEach-Object { $_.TrimEnd(',')}
#>
Compare-Object $refArray $diffArray 


function Send-Greeting {
    [OutputType([string])]
    param($Name,$lastName)
    "Hello, $Name"
}

Get-Command Send-Greeting | Select-Object Name, OutputType