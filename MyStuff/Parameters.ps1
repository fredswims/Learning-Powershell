param (
    [string]$price = 100,
    [string]$ComputerName = $env:computername,
    #[string]$username = $(throw "-username is required."),
    #[string]$password = $( Read-Host -asSecureString "Input password" ),
    [switch]$SaveData = $false
)
get-location
remove-item fred -whatif
"First argument is {0}" -f $price
write-host "Second argument is $ComputerName"
write-host "The True/False switch argument is $SaveData"
read-host "pause"