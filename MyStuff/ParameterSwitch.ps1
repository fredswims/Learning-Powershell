Param(
    [string]$Content = $null,
    [switch]$Flag
)
# $flag|get-member
$flag.IsPresent
$Content
<#
https://stackoverflow.com/questions/45691877/why-is-the-value-of-switch-type-parameter-passed-to-a-string-parameter
If you don't specify a [switch] parameter, the value is $false; if you do include it - it is $true.
You can explicity specify it as -flag: $true or -flag: $false
This is incorrect  -noflag 

$flag.IsPresent returns a boolean. See below.

PS C:\> .\test.ps1
False

PS C:\> .\test.ps1 -Flag
True

PS C:\> .\test.ps1 -Flag: $true
True

PS C:\> .\test.ps1 -Flag: $false
False

#>
