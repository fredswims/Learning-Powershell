<# https://geekeefy.wordpress.com/2017/08/23/expand-short-url-using-powershell/
.SYNOPSIS
Expand Short URLs
.DESCRIPTION
Unshortens the short URL using the UnTiny.me web API http://untiny.me/api
.PARAMETER URL
Short URL to be expanded
.EXAMPLE
PS > Expand-ShortURL -URL https://goo.gl/quuacW, http://goo.gl/VG9XdU

ShortURL              LongURL
--------              -------
https://goo.gl/quuacW https://geekeefy.wordpress.com/
http://goo.gl/VG9XdU  https://raw.githubusercontent.com/PrateekKumarSingh/PowershellScrapy/master/MACManufacturers/MAC_Manufacturer_Reference.csv

.EXAMPLE
PS > 'https://goo.gl/quuacW' |Expand-ShortURL

ShortURL              LongURL
--------              -------
https://goo.gl/quuacW https://geekeefy.wordpress.com/

.NOTES
Blog URL - http://geekeefy.wordpress.com
#>
Function Expand-ShortURL {
    Param(
            [Parameter(
                Mandatory = $true,
                HelpMessage = 'Short URL to be expanded',
                ValueFromPipeline = $true,
                Position = 0
            )]
            [ValidateNotNullOrEmpty()]
            [string[]] $URL
    )

    Begin{
    }
    Process
    {
        Foreach($Item in $URL){
            try {
                    [PSCustomObject]@{
                        ShortURL = $Item
                        LongURL = Invoke-WebRequest -Uri "http://untiny.me/api/1.0/extract?url=$Item&format=text" -ErrorAction Stop |`
                        ForEach-Object Content
                }
            }
            catch {
                $_.exception.Message
            }
        }
    }
    End{
    }

}
'https://goo.gl/quuacW' |Expand-ShortURL
'https://goo.gl/quuacW','https://goo.gl/quuacW' |Expand-ShortURL