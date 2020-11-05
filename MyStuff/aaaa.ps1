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


  $fred=Get-ChildItem -path Temp:
  $fred.where({$psitem.attributes -ne "Directory"}).foreach({"{0,12:n0} {2} {1} " -f $_.length,$_.FullName,$PSItem.Attributes})
  $fred.where({!$psitem.PSIsContainer}).foreach({"{0,12:n0} {2} {1} " -f $_.length,$_.FullName,$PSItem.Attributes})

  $fred|Select-Object name,Attributes
  gci|% -begin {$_.Directory}

  # https://mcpmag.com/articles/2015/12/02/where-method-in-powershell.aspx
  @().Where()
#   returns
#   MethodException: Cannot find an overload for ".Where({ expression } [, mode [, numberToReturn]])" and the argument count: "0".

  @(1..10).Where({$_ -BAND 1},'Default',2)
#   What are the values for the optional parameter MODE?
  @(1..10).Where({$_ -BAND 1},'$null',2)
#   Returns
#   InvalidArgument: Cannot convert value "$null" to type "System.Management.Automation.WhereOperatorSelectionMode". Error: "Unable to match the identifier name $null to a valid enumerator name. Specify one of the following enumerator names and try again:
# Default, First, Last, SkipUntil, Until, Split"
  @(1..10).Where({$_ -eq 5},'Until')
  @(1..10).Where({$_ -eq 5},'Until',2)

  $Running,$Other = (Get-Service).Where({$_.Status -eq 'Running'},'Split')


#   https://mcpmag.com/articles/2018/07/10/check-for-locked-file-using-powershell.aspx
  Function Test-IsFileLocked {
    [cmdletbinding()]
    Param (
        [parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [Alias('FullName','PSPath')]
        [string[]]$Path
    )
    Process {
        ForEach ($Item in $Path) {
            #Ensure this is a full path
            $Item = Convert-Path $Item
            #Verify that this is a file and not a directory
            If ([System.IO.File]::Exists($Item)) {
                Try {
                    $FileStream = [System.IO.File]::Open($Item,'Open','Write')
                    $FileStream.Close()
                    $FileStream.Dispose()
                    $IsLocked = $False
                } Catch [System.UnauthorizedAccessException] {
                    $IsLocked = 'AccessDenied'
                } Catch {
                    $IsLocked = $True
                }
                [pscustomobject]@{
                    File = $Item
                    IsLocked = $IsLocked
                }
            }
        }
    }
}



new-item test.ps1
$obj = ls test.ps1


# https://stackoverflow.com/questions/37688708/iterate-over-psobject-properties-in-powershell
# make an object from json and use 'PSObject (hidden property) enumerate methods and properties and a hash table.
$a = '{ "prop1":[int]1, "prop2":[int]2, "prop3":[int]3 }' | convertfrom-json
# $a=get-content "C:\Users\Super Computer\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json" | convertfrom-json
$a.PSObject.Properties | Format-Table @{ Label = 'Type'; Expression = { "[$($($_.TypeNameOfValue).Split('.')[-1])]" } }, Name, Value -AutoSize -Wrap
$a.gettype().fullname
$a|get-member
$a.PSObject.Properties | select-object name, value
$hash=@{} #make empty hash table not an array!
$a.psobject.properties|ForEach-Object -process {$hash.add($_.name,$_.value) }
$hash.gettype().FullName
$hash
$hash.keys; $hash.Values
$hash['prop2'] # return the value for a given key.
# does an entry in the hash table contain '1' as a value.
$hash.ContainsValue('1') 
$hash['prop1'].gettype()
# here is another way to do this.
$hash=@{} #make empty hash table not an array!
$a | Get-Member -MemberType NoteProperty| ForEach-Object -process {$hash.add($_.name,$a.($_.name)) } #look how value is formulated
$hash
$a|Get-Member  



function Enumerate-ObjectProperties {
    param (
        [psobject] $Object,
        [string] $Root
    )

    Write-Output $($Object.PSObject.Properties | Format-Table @{ Label = 'Type'; Expression = { "[$($($_.TypeNameOfValue).Split('.')[-1])]" } }, Name, Value -AutoSize -Wrap | Out-String)

    foreach ($Property in $Object.PSObject.Properties) {
        # Strings always have a single property "Length". Do not enumerate this.
        if (($Property.TypeNameOfValue -ne 'System.String') -and ($($Object.$($Property.Name).PSObject.Properties))) {
            $NewRoot = $($($Root + '.' + $($Property.Name)).Trim('.'))
            Write-Output "Property: $($NewRoot)"
            #Enumerate-ObjectProperties -Object $($Object.$($Property.Name)) -Root $NewRoot
        }
    }
}

Enumerate-ObjectProperties $YourObject
Enumerate-ObjectProperties $a

#region freds region
gci
#endregion fred