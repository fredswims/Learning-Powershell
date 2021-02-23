# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/understanding-rest-web-services-in-powershell?s=03
Invoke-RestMethod -Uri https://blogs.msdn.microsoft.com/powershell/feed/ |
  Select-Object -Property Title, pubDate

  Invoke-RestMethod http://numbersapi.com/25

  invoke-restMethod https://forecast.weather.gov/MapClick.php?lat=40.6538&lon=-73.7032

  # https://4bes.nl/2020/08/23/calling-a-rest-api-from-powershell/

$Body = @{
    Cook = "Fred-Arthur"
    Meal = "PastaConCarne"
}
 
$Parameters = @{
    Method = "POST"
    Uri =  "https://4besday4.azurewebsites.net/api/AddMeal"
    Body = ($Body | ConvertTo-Json) 
    ContentType = "application/json"
}
Invoke-RestMethod @Parameters -SessionVariable cookie
Invoke-RestMethod "https://4besday4.azurewebsites.net/api/AddMeal" -WebSession $cookie

# Accessing Web Services
# Did you know PowerShell can access public and private Web services? 
# The piece of code below will connect to a global weather service providing airport weather reports from around the globe:

$a = New-WebServiceProxy 'http://www.webservicex.net/globalweather.asmx?WSDL'
$a.GetCitiesByCountry('Sweden')
$a.GetWeather('Stockholm / Arlanda', 'Sweden')

$URI = "http://www.dneonline.com/calculator.asmx?wsdl"
$calc = New-WebServiceProxy -Uri $URI -Namespace "WSProxy" -Class "Calculator"
new-web