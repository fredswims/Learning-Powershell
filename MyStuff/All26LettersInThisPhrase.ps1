
function Letters26 {
    Param ( [string[]]$names = "the uick brown fox jumps over the lazy dog")
    Write-Warning "In function $($MyInvocation.MyCommand.Name)"
    # does the phrase contain all the letters in the alphabet?
    $phrase = $names.split("").ToLower()
    $phrase=$phrase.Replace(" ","")
    Write-host ("[{0}]" -f $phrase)
    $count = 0
    foreach ($letter in ("a" .. "z")) {
        if ($($phrase.IndexOf("$($letter)")) -eq -1)`
        {write-host ("did not find {0}" -f $letter);$count=$count+1;write-host("count $($count)")}   else { write-host ("found {0}" -f $letter) }
    }
    write-host ("count {0}" -f $count)
    if ($count -ge 1) { return $false }else {return  $true }
}
<# 
cls
if(Letters26 "ab cdefghijklmnopqrstuvwxyz"){write-host "true"} else {write-host "false"} 
 #>

 function Limit-StringToAlphabet {
    Param (
        [string]$inputString
    )

    # Use a regular expression to remove non-alphabet characters
    $outputString = $inputString -replace '[^a-zA-Z]', ''
    return $outputString
}

function Check-DuplicateLetters {
    Param (
        [string]$inputString
    )

    # Create an empty hashtable to store character counts
    $charCount = @{}

    # Iterate through each character in the string
    foreach ($char in $inputString.ToCharArray()) {
        if ($charCount.ContainsKey($char)) {
            # If the character is already in the hashtable, increment its count
            $charCount[$char]++
        } else {
            # If the character is not in the hashtable, add it with a count of 1
            $charCount[$char] = 1
        }
    }

    # Check for duplicates
    $duplicates = @()
    foreach ($key in $charCount.Keys) {
        if ($charCount[$key] -gt 1) {
            $duplicates += $key
        }
    }

    return $duplicates
}
<# 
# Example usage
$inputt = "Hello, World! 123"
$limitedString = Limit-StringToAlphabet -inputString $inputt
$duplicates = Check-DuplicateLetters -inputString $limitedString

Write-Output "Limited String: $limitedString"
Write-Output "Duplicate Letters: $($duplicates -join ', ')"
 #>