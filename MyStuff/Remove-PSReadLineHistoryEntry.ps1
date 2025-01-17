# function Remove-PSReadLineHistoryEntry {
[CmdletBinding()]    
param (
    [Parameter(Mandatory=$true, ParameterSetName="SetA")]
    [string[]]$ThisString,
    [Parameter(Mandatory=$true, ParameterSetName="SetB")]
    [switch]$RemoveDuplicates
)

if ($RemoveDuplicates) {
    write-host "Removing duplicates from history"
    $historyPath = (Get-PSReadLineOption).HistorySavePath
    $history = Get-Content $historyPath
    $history | Sort-Object -Unique | Set-Content $historyPath
    return
}

$historyPath = (Get-PSReadLineOption).HistorySavePath
$history = Get-Content $historyPath

# first find $ThisString
# $ThisString = "cls;"
write-host "Removing history entries matching [$ThisString]"
$count=$history | Where-Object { $_ -like $ThisString }
if($count.Count -eq 0) {
    write-host "No history entries found matching [$ThisString]"
    return
}
write-host "Found $($count.Count) history entries matching [$ThisString]"
$newHistory = $history | Where-Object { $_ -notmatch $ThisString }

$newHistory | Set-Content $historyPath
# }

# Example usage to remove entries matching a specific string or ID
# Remove-PSReadLineHistoryEntry -ThisString "cls"
# Remove-PSReadLineHistoryEntry -Sort
