$Here = @'
Msg1 = The string parameter is required.
Msg2 = Credentials are required for this command.
Msg3 = The specified variable does not exist.
'@
# ConvertFrom-StringData converts a string in the format of key=value pairs to a hashtable
$hashTable = ConvertFrom-StringData -StringData $Here
<# 
Name                           Value
----                           -----
Msg3                           The specified variable does not exist.
Msg2                           Credentials are required for this command.
Msg1                           The string parameter is required. 
#>
$data = @" 
# The next line contains Unicode characters representing a bell emoji
$([char]0xD83D + [char]0xDD14)
$([System.Globalization.CultureInfo]::CurrentCulture.TextInfo.ToTitleCase($env:USERNAME))
here are some $($psStyle.foreground.brightred)Things$($psStyle.reset) you might want to try:
settings->sniping tool
settings->time & language -> typing.
Search in Youtube TV for 'YouTube TV Zen'
System Internals $($psStyle.foreground.brightred) Zoomit $($psStyle.reset)
[System.Globalization.CultureInfo] | gm -static
[System.Globalization.CultureInfo]::CurrentCulture | gm -static
[System.Globalization.CultureInfo]::CurrentCulture.TextInfo | gm -static

rename a file like '2024 Real Estate Tax Factors' 
`$MyString="2024 Real Estate Tax Factors"
[System.Globalization.CultureInfo]::CurrentCulture.TextInfo.ToTitleCase(`$MyString.tolower()).Replace(" ","")

2024RealEstateTaxFactors
Accelerators.ps1
test-connection 192.168.86.250 -Traceroute -ResolveDestination
1..254 | ForEach-Object {Test-Connection -ComputerName "192.168.86.$_" -Count 1 -Quiet} | ForEach-Object { if ($_) {$_}}
"@


#This display all the lines in the HereString
write-host $data

<# begin comment
# Split the here-string into an array of lines
$lines = $data -split "`n" 
# Print the second line (index 1) 
Write-Output $lines[1]
 #> end comment