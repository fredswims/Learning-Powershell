https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_splatting?view=powershell-7
<#
The feature uses the $Args automatic variable, 
which contains all unassigned parameter values.
#>
function Get-MyProcess { $args;Get-Process @Args }
Get-MyProcess -Name Pwsh
Get-MyProcess -Name Pwsh -FileVersionInfo

function Get-MyCommand
{
    Param ([switch]$P, [switch]$C)
    if ($P) { Get-Process @Args }
    if ($C) { Get-Command @Args }
}
Get-MyCommand -P -C -Name Pwsh

<#
This example shows how to forward their parameters to other commands 
by using splatting and the $PSBoundParameters automatic variable.
The $PSBoundParameters automatic variable is a dictionary object
#>
function Test1
{
    param($a, $b, $c)

    $a
    $b
    $c
}
function Test2
{
    param($a, $b, $c)

    #Call the Test1 function with $a, $b, and $c.
    Test1 @PsBoundParameters
    
    #Call the Test1 function with $b and $c, but not with $a
    $LimitedParameters = $PSBoundParameters
    $LimitedParameters.Remove("a") | Out-Null
    Test1 @LimitedParameters
}
Test2 -a 1 -b 2 -c 3

    #Splat away
 
    

$Colors = @{
    ForegroundColor = "black"
    BackgroundColor = "white"
}
Write-host "fred was here" @Colors
    
$Text = "Fred was here on $(get-date)"
$Splatter = @{Object = $Text; Separator = '' }
$Colors = @{
    ForegroundColor = "black"
    BackgroundColor = "white"
}
Write-Host @Colors @Splatter

$Text = "Fred was here on $(get-date)"
$SplatWriter = @{
    ForegroundColor = "black"
    BackgroundColor = "white"
    OBJECT          = $Text
    SEPARATOR       = ''
}
Write-Host @SplatWriter
