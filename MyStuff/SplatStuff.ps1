function Get-MyCommand
{
    Param ([switch]$P, [switch]$C)
    "the value of Args is {0}" -f $args
    "first call"
    if ($P) { Get-Process @Args }
    "second call"
    if ($C) { Get-Command @Args }
}

Get-MyCommand -P -C -Name PowerShell