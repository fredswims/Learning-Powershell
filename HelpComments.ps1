


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


<#
For more explanation about .SYNOPSIS and .* see about_Comment_Based_Help.

Remark: These function comments are used by the Get-Help CmdLet and can be put before the keyword Function, or inside the {} before or after the code itself.
#>