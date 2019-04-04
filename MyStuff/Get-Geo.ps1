<#
.SYNOPSIS
Get-Geo - Domain/Hostname Geolocation
.DESCRIPTION
Resolves the IP address of a domain and returns the country name and country code information.
 
.PARAMETER domain
Specifies the domain name (enter the domain name without http:// and www (e.g. power-shell.com))
 
.EXAMPLE
Get-Geo -domain microsoft.com 
Get-Geo microsoft.com
 
.NOTES
File Name: get-geo.ps1
Author: Nikolay Petkov
Blog: http://power-shell.com
Last Edit: 12/20/2014
 
.LINK
http://power-shell.com
http://power-shell.com/2014/powershell-scripts/powershell-function-get-domainhostname-geolocation/
#>
Function Get-Geo {
param (
                [Parameter(Mandatory=$True,
                           HelpMessage='Please enter domain name (e.g. microsoft.com)')]
                           [string]$domain
        )
try {
$ `
|foreach {$_.IPAddressToString} |Out-String
$ip = $ipadresses.Split()[0]
} catch {
Write-Host "Get-Geo request could not find host $domain. Please check the name and try again." -ForegroundColor Red
}
$geo = New-WebServiceProxy -uri "http://www.webservicex.net/geoipservice.asmx?WSDL"
$results = $geo.GetGeoIP($ip)
If ($results.ReturnCodeDetails -eq "Success")
{
$GeoObject = New-Object PSObject
Add-Member -inputObject $GeoObject -memberType NoteProperty -name "Domain Name" -value $domain
Add-Member -inputObject $GeoObject -memberType NoteProperty -name "IP Address" -value $results.IP
Add-Member -inputObject $GeoObject -memberType NoteProperty -name "Country" -value $results.CountryName
Add-Member -inputObject $GeoObject -memberType NoteProperty -name "Country Code" -value $results.CountryCode
$GeoObject
}
else {Write-Host "The $domain GEO location cannot be resolved." -ForegroundColor Red}
} #end function Get-Geo