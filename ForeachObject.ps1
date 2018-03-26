Get-Content -path "C:\Users\freds_000\Documents\test.txt" | gm


$address |  ForEach {Write-Host $_}
<#
Set-ChildItem -Force | ForEach-Object -Begin {

    Write-Verbose "Begin block" -Verbose

} -Process {

    If ($_.length -gt 555) {

        Write-Verbose "Process block" -Verbose

        $_

    }

} -End {

    Write-Verbose "End block" -Verbose

}
#>