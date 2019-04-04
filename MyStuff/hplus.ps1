#Executing multiple history commands at once
function hplus{
        Get-History |
        Out-GridView -Title "Press CTLR, select multiple and Hit OK" -OutputMode Multiple |
        ForEach-Object {
                Write-Output "PS> $($_.commandline)`n"
                Invoke-Expression $($_.CommandLine)
                "`n`n"
        }        
}
