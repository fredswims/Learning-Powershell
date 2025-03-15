function Get-SecondToken {
    $history = (Get-History -Count 1).CommandLine
    $tokens = $history -split ' '
    if ($tokens.Length -ge 2) {
        return $tokens[1]
    }
    else {
        return $null
    }
}
# Usage example
$secondToken = Get-SecondToken
if ($secondToken) {
    Write-Host "The second token is: $secondToken"
} else {
    Write-Host "No second token found in the last command."
}
