<#
https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/finding-powershell-named-pipes
Each PowerShell host running PowerShell 5 or better opens a “named pipe” that you can detect.
The code below identifies these named pipes and returns the processes exposing the pipes:

Any process listed here is hosting a PowerShell runspace,
and you can use Enter-PSHostProcess -Id XXX to connect to
the PowerShell process (provided you have local Administrator privileges).

#>
$PID
Get-ChildItem -Path "\\.\pipe\" -Filter '*pshost*' |
ForEach-Object {
    Get-Process -Id $_.Name.Split('.')[2]
}