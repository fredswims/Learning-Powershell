function Remove-PSReadLineHistoryEntry {
    param (
        $ThisString
    )

    $historyPath = (Get-PSReadLineOption).HistorySavePath
    $history = Get-Content $historyPath

    # first find $ThisString
    $ThisString="cls;"
    $history | Where-Object { $_ -like "cls;" }

    $newHistory = $history | Where-Object { $_ -notmatch $ThisString }

    $newHistory | Set-Content $historyPath
}

# Example usage to remove entries matching a specific string or ID
Remove-PSReadLineHistoryEntry -ThisString "cls"
