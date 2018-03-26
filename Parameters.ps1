param (
    [string]$price = 100, 
    [string]$ComputerName = $env:computername,    
    #[string]$username = $(throw "-username is required."),
    [string]$password = $( Read-Host -asSecureString "Input password" ),
    [switch]$SaveData = $false
)
write-output "First argument is $price"
write-output "Second argument is $ComputerName"
write-output "The True/False switch argument is $SaveData"