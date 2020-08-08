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


$ArrayList = New-Object System.Collections.ArrayList

function fShowSubDirectorySize {
    [Alias('ShowSubDirectorySize')] param ([string[]]$Path = "*")
    Write-Warning "In function $($MyInvocation.MyCommand.Name): "
    write-warning "$($path)"
    $colItems = get-childitem -Directory  -Path $path
    foreach ($i in $colItems) {
        $subFolderItems = Get-ChildItem $i.FullName -recurse -force | Where-Object { $_.PSIsContainer -eq $false } | Measure-Object -property Length -sum | Select-Object Sum
        $thisobject = [pscustomobject]@{
            Size = $subFolderItems.Sum
            Name = $i.FullName
        }
        $thisobject
    }
}
function fShowFormattedSubDirectorySize{[Alias('ShowFormattedSubDirectorySize')] param ([string[]]$Path="*")
fShowSubDirectorySize -path $path | sort-object -property size -Descending|Select-Object @{name="Bytes";exp={"{0,16:n0}" -f $psitem.size}}, name
}


