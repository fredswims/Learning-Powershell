data TextMessages {
    ConvertFrom-StringData @"
Welcome = Hello, world!
Error = An error occurred.
Prompt = Please enter your name:
"@
}

$MyText = [PSCustomObject]@{
    Welcome = "Hello, world!"
    Error = "An error occurred."
    Prompt = "Please enter your name:"
}

ConvertTo-Csv $data.MyText | Out-File -FilePath "$PSScriptRoot\TextMessages.json" -Encoding utf8



$mytext.Welcome

write-host "$($MyText.Welcome)"
write-host $MyText.Error -ForegroundColor Red
$name = Read-Host $MyText.Prompt
$myNames = @($name, "Alice", "Bob")
write-host "Names: $($myNames -join ', ')" -ForegroundColor Green
$myNames