$uri="https://icanhazdadjoke.com/"
$headers=@{Accept="text/plain"}
Invoke-RestMethod -Uri $uri -Headers $headers
  
Invoke-RestMethod -Uri "https://icanhazdadjoke.com/" -Headers @{Accept="text/plain"}

$joke = Invoke-RestMethod -Uri "https://icanhazdadjoke.com/" -Headers @{Accept="application/json"}
$joke.joke

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show($joke.joke, "Joke of the Day")

#Install-Module -Name BurntToast
New-BurntToastNotification -Text "Joke of the Day", $joke.joke

#Place headers in a hash table.
$headers = @{
    Accept="application/json"
    UserAgent="Fred's PowerShell JokeBot"
}
$url = "https://icanhazdadjoke.com/"
$joke=Invoke-RestMethod -Uri $url -Headers $headers
$joke.joke