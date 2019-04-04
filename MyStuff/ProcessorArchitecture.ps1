$Arch = (Get-Process -Id $PID).StartInfo.EnvironmentVariables["PROCESSOR_ARCHITECTURE"]
if ($Arch -eq 'x86') {
Write-Host -Object 'Running 32-bit PowerShell'
start-sleep 10
}
elseif ($Arch -eq 'amd64') {
Write-Host -Object 'Running 64-bit PowerShell'
start-sleep 10
}

Get-Member

switch((Get-Process -Id $PID).StartInfo.EnvironmentVariables["PROCESSOR_ARCHITECTURE"]){
'x86' {'Running 32-bit PowerShell'}
'amd64' {'Running 64-bit PowerShell'}
}
start-sleep 10
/* comment */ 

switch($env:PROCESSOR_ARCHITECTURE){
'x86' {'Running 32-bit PowerShell'}
'amd64' {'Running 64-bit PowerShell'}
}
start-sleep 10


<#
.SYNOPSIS
    A brief description of the function or script. This keyword can be used
    only once in each topic.
.DESCRIPTION
    A detailed description of the function or script. This keyword can be
    used only once in each topic.
.NOTES
    File Name      : xxxx.ps1
    Author         : J.P. Blanc (jean-paul_blanc@silogix-fr.com)
    Prerequisite   : PowerShell V2 over Vista and upper.
    Copyright 2011 - Jean Paul Blanc/Silogix
.LINK
    Script posted over:
    http://silogix.fr
.EXAMPLE
    Example 1
.EXAMPLE
    Example 2
#>
function Fred
{
switch($env:PROCESSOR_ARCHITECTURE){
'x86' {'Running 32-bit PowerShell'}
'amd64' {'Running 64-bit PowerShell'}
}
#start-sleep 10

}
