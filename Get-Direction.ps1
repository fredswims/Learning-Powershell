﻿#https://gist.github.com/PrateekKumarSingh/3c04b3169d513b3ad887#file-get-direction-ps1
Function Get-Direction()
{

Param(
    [Parameter(Mandatory=$true,Position=0)] $Origin,
    [Parameter(Mandatory=$true,Position=1)] $Destination,
    [Parameter(Position=2)] [ValidateSet('driving','bicycling','walking')] $Mode ="driving",
    [Switch] $InMeters
    )
    
$Units='imperial' # Default set to Miles

# If Switch is selected, use 'KiloMeters' as the Unit
If($InMeters){$Units = 'metric'}

#Requesting Web Page
$webpage = Invoke-WebRequest "https://maps.googleapis.com/maps/api/directions/xml?origin=$Origin&destination=$Destination&mode=$($mode.toLower())&units=$Units&key=AIzaSyAjkqgmCw15XhKat2Z-cIGZ-rzmE0xXHjc" -UseBasicParsing -ErrorVariable +err

# Capturing the HTML output
$content = $webpage.Content

#To Clear unwanted data from the String
    Function Clean-String($Str)
    {
        $str = $Str.replace('<div style="font-size:0.9em">','')
        $str = $str.replace('</div>','')
        $str = $str.replace('<b>','')
        $str = $str.replace('</b>','')
        $str = $str.replace('&nbsp;','')
        Return $str
    }

# Data Mining information from the XML content
$status = (Select-Xml -Content $content -xpath '//status').Node.InnerText

    If($status -eq 'OK')
    {
        $Mode = (Select-Xml -Content $content -xpath '//route/leg/step/travel_mode').Node.InnerText
        $Duration = (Select-Xml -Content $content -xpath '//route/leg/step/duration/text').Node.InnerText
        $Distance = (Select-Xml -Content $content -xpath '//route/leg/step/distance/text').Node.InnerText
        $Instructions = (Select-Xml -Content $content -xpath '//route/leg/step/html_instructions').Node.InnerText | %{ Clean-String $_}
        
        $Object = @()
        for($i=0;$i -le $instructions.count;$i++)
        {
        $Object += New-Object psobject -Property @{TravelMode=$Mode[$i];Duration=$Duration[$i];Distance= $Distance[$i];"Instructions"= $Instructions[$i]}
        }
        "Here are you Instructions from $Origin to $Destination" 
        Return $Object
    }
    else
    {
        # In case the no data is received due to incorrect parameters
        Write-Host "Zero Results Found :  Try changing the parameters" -fore Yellow
    }

}