<#https://geekeefy.wordpress.com/2017/08/24/get-weather-report-using-powershell/
.SYNOPSIS
Get Weather of a City
.DESCRIPTION
Fetches Weather report of a City from website - http://wttr.in/ courtsey Igor Chubin [Twitter- @igor_chubin]
.PARAMETER City
Name of City
.PARAMETER Tomorrow
Switch to include tomorrow's Weather report
.PARAMETER DayAfterTomorrow
Switch to include Day after tomorrow's Weather report
.EXAMPLE
Get-Weather  "Los Angles" -Tomorrow -DayAfterTomorrow
.EXAMPLE
'london', 'delhi', 'beijing' | Get-Weather
.NOTES
Blog - Geekeefy.wordpress.com
#>
Function Get-Weather {
    [Alias('Wttr')]
    [Cmdletbinding()]
    Param(
            [Parameter(
                Mandatory = $true,
                HelpMessage = 'Enter name of the City to get weather report',
                ValueFromPipeline = $true,
                Position = 0
            )]
            [ValidateNotNullOrEmpty()]
            [string[]] $City,
            [switch] $Tomorrow,
            [switch] $DayAfterTomorrow
    )

    Process
    {
        Foreach($Item in $City){
            try {
                $Weather = $(Invoke-WebRequest "http://wttr.in/$City" -UserAgent curl).content -split "`n"
                If($Weather)
                {
                    $Weather[0..16]
                    If($Tomorrow){ $Weather[17..26] }
                    If($DayAfterTomorrow){ $Weather[27..36] }
                }
            }
            catch {
                $_.exception.Message
            }
        }
    }

}