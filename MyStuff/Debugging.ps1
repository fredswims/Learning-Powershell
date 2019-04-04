function Fred ($ellen) {
write-host "This is what I said " $ellen
}

write-host " 1 MyInvocation: $MyInvocation"
write-host " 2 MyInvocation.MyCommand.path $MyInvocation.MyCommand.path"
write-host " 3 MyInvocation.scriptname: $MyInvocation.ScriptName"



$MyScriptName = $MyInvocation.MyCommand.Path
Write-host "I wrote this > $MyScriptName < with lenght of $MyScriptName.Length"
$MyScriptName.Length
write-host "----------------------"

$MyScriptName= $MyInvocation.ScriptName
Write-host "Fred wrote this $MyScriptName.Length"
$MyScriptName.Length

$MyScriptName=$MyInvocation.MyCommand
write-host "MyInvocation.MyCommand:$MyScriptname"
$MyScriptName

write-host "Stop me now"




start-sleep -second 5 #allows time to start debugging via ctrl-B

for ($i = 1; $i -le 100; $i++ ){
write-host "hello"
$parm1="Hello world"
$parm1

start-sleep -Milliseconds 250
write-progress -activity "Search in Progress" -status "$i% Complete:" -percentcomplete $i;}




<#
https://technet.microsoft.com/en-us/library/dd819480.aspx
https://technet.microsoft.com/en-us/library/dd315264.aspx
about_Debuggers
https://technet.microsoft.com/en-us/library/dd347652.aspx

You cannot set a breakpoint unless the script that you want to debug is saved. 
Set-PSBreakpoint -Script C:\Users\freds_000\SkyDrive\Powershell\Debugging.ps1 -variable i

#>