# https://slai.github.io/posts/powershell-and-external-commands-done-right/
[CmdletBinding()]
param (
    [Parameter(ValueFromPipeline = $true)]
    [Int32]$Delay=360,
    [Parameter(Mandatory = $false)]
    [String]$Once = 'N',
    [Parameter(Mandatory = $false)]
    [switch]$AsFSInfo = $false
)
Write-Warning "In module $($MyInvocation.MyCommand.Name): "
$host.UI.RawUI.WindowTitle = 'RunFan'
$exec = (join-path -path ${env:ProgramFiles(x86)} -ChildPath "Sony\VAIO System Diagnostic\CPU Fan Diagnostic\FDU.exe")
if ($Once -like 'Y') { 
    "In run 'Once' mode"    
    &$exec # invoke fan program using call operator and return immediately.
}
else {
    "Running continuously - kill process {0}" -f $pid
    for ($i = 1; $true; $i++) {
        write-warning $delay
        write-warning $i
        write-warning $pid
        write-warning 'running Fan'
        &$exec
        Start-Sleep -seconds $delay
    }
}
