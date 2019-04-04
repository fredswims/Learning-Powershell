function test
{
    "Line 1 is MyInvocation.MyCommand.Definition,{0}" -f $MyInvocation.MyCommand.Definition
    "Line 2 is PSCommandPath,{0}" -f $PSCommandPath

    "Line 3 is MyInvocation.MyCommand.Definition, {0}" -f (Split-Path -Path $MyInvocation.MyCommand.Definition)
    "Line 4 is PSScriptRoot , {0}" -f $PSScriptRoot
}

test 