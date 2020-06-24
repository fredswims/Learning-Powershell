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

<#
https://answers.microsoft.com/en-us/windows/forum/all/mat-debug-xxxxlog-files/8875d070-62f9-429b-b3e1-9a6e006c45be?auth=1&page=6

https://docs.microsoft.com/en-us/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services
I solved the annoying problem with mat-debug-xxxx.log files for me using the commands:

Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "Microsoft.MicrosoftOfficeHub"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}

Get-AppxPackage Microsoft.MicrosoftOfficeHub | Remove-AppxPackage

See: https://docs.microsoft.com/en-us/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like "Microsoft.MicrosoftOfficeHub"}

#>