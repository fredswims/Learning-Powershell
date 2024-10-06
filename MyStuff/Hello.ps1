param(
[string]$firstName,
[string]$lastName
)

Write-Host "Starting test script"
try
{
   Write-Host "Hello $firstName $lastName"        
}
catch
{
    Write-Error "Error. Exception: $_"
}

write-host "Script done"