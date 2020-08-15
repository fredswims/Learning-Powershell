# Get Last Command
Function GetLastCommand($Number) {
    $CommandLength = (Get-History | Measure-Object).Count
    $Start = $CommandLength - $Number + 1
    [array]$CommandRange = @()
    Foreach ($obj in ($Start..$CommandLength)) { $CommandRange += $obj; $obj++ }
    (Get-History $CommandRange).CommandLine | Clip
    Write-Host -NoNewline "Last "; Write-Host -NoNewLine -ForegroundColor Green "$($Number) "; Write-Host "commands have been copied to the clipboard."
}

<# write-host "lets begin"
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
 #>
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

# Jeffrey Hicks
Function Convert-TextToNumber {
    [cmdletbinding()]
    [outputtype("int32")]

    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [ValidatePattern("^[A-Za-z]{1,5}$")]
        [string]$Plaintext,
        [Parameter(HelpMessage = "A custom dictionary file which is updated everytime a word is converted")]
        [string]$Dictionary = (join-path $env:TEMP "mywords.txt")
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"

        #define a simple hashtable
        $phone = @{
            2 = 'abc'
            3 = 'def'
            4 = 'ghi'
            5 = 'jkl'
            6 = 'mno'
            7 = 'pqrs'
            8 = 'tuv'
            9 = 'wxyz'
        }

        #initialize a dictionary list
        # items in a dictionary list may repeat without warning.
        $dict = [System.Collections.Generic.List[string]]::new()
        if (Test-Path -path $Dictionary) {
            Write-Verbose "[BEGIN  ] Loading user dictionary from $Dictionary"
            (Get-Content -path $Dictionary).foreach({$dict.add($_)})
            $originalCount = $dict.Count
            Write-Verbose "[BEGIN  ] Loaded $originalCount items"
        }
    } #begin
    Process {
        Write-Verbose "[PROCESS] Converting: $Plaintext"
        #add plaintext to dictionary if missing
        if ($dict -notcontains $Plaintext) {
            Write-Verbose "[PROCESS] Adding to user dictionary"
            $dict.Add($plaintext)
        }

        #this is a technically a one-line expression
        #get the matching key for each value and join together
        #each single digit is pushed to pipeline and returned as a collection.
        ($plaintext.ToCharArray()).ForEach({
         $val = $_
         ($phone.GetEnumerator().Where({$_.value -match $val}).name)}) -join ""
    } #process

    End {
        #commit dictionary to file if new words were added
        if ($dict.count -gt $originalCount) {
            Write-Verbose "[END    ] Ending: Saving updated dictionary $Dictionary"
            $dict | Out-File -FilePath $Dictionary -Encoding ascii -Force
        }
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
}
convert-TextToNumber -Plaintext "anton"
"eliza"| Convert-TextToNumber
$fred=(Get-Content -path $Dictionary).foreach({Convert-TextToNumber $psitem})


# Condition to test
$CarColor = 'Blue'
 
# Hashtable with $true & $false as the keys, and the subsequent results as the values
@{ $true = 'The car color is blue'; $false = 'The car color is not blue'}
 
# Lookup that tests the condition, outputting the relevant value
[$CarColor -eq 'Blue']
$true

#hostname

# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_enum?view=powershell-7
enum MediaTypes {
    unknown
    music = 10
    mp3
    aac
    ogg = 15
    oga = 15
    mogg = 15
    picture = 20
    jpg
    jpeg = 21
    png
    video = 40
    mpg
    mpeg = 41
    avi
    m4v
}

[mediatypes].GetEnumNames()
[MediaTypes].GetEnumName(15)
[MediaTypes].GetEnumNames() | ForEach-Object {
    "{0,-10} {1}" -f $_,[int]([MediaTypes]::$_)
  }

  [system.environment]::MachineName #fastest
  "$Pid - $(hostname.exe)" # hostname is available on windows and unix
  $env:computername
  (Get-CIMInstance CIM_ComputerSystem).Name