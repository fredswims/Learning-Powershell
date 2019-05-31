# this is not a function

param (
    [Parameter(Mandatory = $true,
        ValueFromPipeline = $true,
        HelpMessage = "Enter an interger.")
    ]
    [Int]
    $code = 1234,
    $Name = "fred",
    $City = "Brooklyn")
Write-Host "The value of Name is $name"
write-host "The value of City is $City"
exit $code #not return

<#
Invoke form cmd.exe like this
powershell -noprofile -file ./param.ps1 -code 555
Echo %Errorlevel%

or from powershell
powershell -noprofile -file ./param.ps1 -code 555 -name "Irving"
$lastexitcode
#>
