function fjStart.ThisApp {
    [CmdletBinding()]
    param (
        [String]$Name,
        [switch]$List
    )

    if ($List) {
        Get-StartApps -SortOrder Name
        return [pscustomobject]@{
            Name    = $Name
            Success = $true
            Message = "Listed all apps."
        }
    }

    $obj = Get-StartApps -Name $Name
    if (-not $obj) {
        return [pscustomobject]@{
            Name    = $Name
            Success = $false
            Message = "App not found."
        }
    }

    foreach ($app in $obj) {
        if ($app.Name -eq $Name) {
            Write-Verbose ("Launching {0} with AppId {1}" -f $app.Name, $app.AppID)
            Start-Process "shell:AppsFolder\$($app.AppID)"
            if ($?) {
                return [pscustomobject]@{
                    Name    = $Name
                    Success = $true
                    Message = "App launched successfully."
                }
            }
        }
    }

    return [pscustomobject]@{
        Name    = $Name
        Success = $false
        Message = "App matched but failed to launch."
    }
}
#region example invocation
<#
# Define a list of app names to test
$appsToTest = @('YouTube TV', 'Netflix', 'Spotify', 'NotARealApp')

# Run the function for each app and collect results
$results = foreach ($app in $appsToTest) {
    fjStartThisApp -Name $app -Verbose
}

# Display results in a neat table
$results | Format-Table Name, Success, Message 
#>
#endregion