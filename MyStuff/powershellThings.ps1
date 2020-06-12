Installing PowerShell on Windows
https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?WT.mc_id=THOMASMAURER-blog-thmaure&view=powershell-7

Create an array or strings without surrounding each item with quotes.
$names=@'
fred
ellen
bea
irv
'@

$items=$names.split("`n")
foreach ($item in $items) {$item}
Or create a file with one name on each line and then
$names=get-content "that file"

*****************
out-host
https://devblogs.microsoft.com/powershell/how-powershell-formatting-and-outputting-really-works/

#Write-Host Considered Harmful
https://www.jsnover.com/blog/2013/12/07/write-host-considered-harmful/#:~:text=The%20problem%20with%20using%20Write,to%20automate%20a%20larger%20task.

Rick Roll
Invoke-Expression (New-Object Net.WebClient).DownloadString(“http://bit.ly/e0Mw9w“)

Get-ClipboardText | ForEach-Object { $i=0 } { '#{0}: {1}' -f (++$i), $_ }

function test-script {
[CmdletBinding()]param()

    Write-verbose "here we go"
}
test-script
test-script -Verbose