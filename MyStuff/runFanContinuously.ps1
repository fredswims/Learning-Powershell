# 2023-06-8
# https://slai.github.io/posts/powershell-and-external-commands-done-right/
[CmdletBinding()]
param (
    [Parameter(ValueFromPipeline = $true)]
    [Int32]$Delay=360,
    [Parameter(Mandatory=$false)]
    [switch]$Once
)
Write-Warning "In module $($MyInvocation.MyCommand.Name): "
$host.UI.RawUI.WindowTitle = "RunFan Delay {0} Id {1}" -f $Delay, $pid
$exec = (join-path -path ${env:ProgramFiles(x86)} -ChildPath "Sony\VAIO System Diagnostic\CPU Fan Diagnostic\FDU.exe")
if ($Once.IsPresent) { 
    "In run 'Once' mode"    
    & $exec # invoke fan program using call operator and return immediately.
}
else {
    "Run interval on {1} seconds. - Kill process {0}" -f $pid, $Delay
    for ($i = 1; $true; $i++) {
        # write-warning $delay
        # write-warning "Count $($i)"
        # $Speed=& (Join-path $env:OneDrive "PowershellScripts\MyStuff\GetClockSpeed.ps1")
        $Speed=invoke-expression (Join-path $env:OneDrive "PowershellScripts\MyStuff\GetClockSpeed.ps1")
        $host.UI.RawUI.WindowTitle = "RunFan [{2} GHz] Delay {0} Id {1}" -f $Delay, $pid, $speed
        # if ($speed[0] -eq "-"){New-BurntToastNotification -text $speed -Silent}
        # $Time=Get-Date -DisplayHint Time
        $Time=get-date -UFormat '%I:%M:%S %p'
        "<{3}> - Running Fan - Count {0}{1}{2}" -f $PSStyle.Formatting.Warning,$i,$psstyle.reset,$Time
        # write-warning $pid
        # write-warning ' Running Fan'
        # &$exec
        start-process -WindowStyle Minimized -FilePath (resolve-path (join-path -path ${env:ProgramFiles(x86)} -ChildPath "Sony\VAIO System Diagnostic\CPU Fan Diagnostic\FDU.exe")).path
        # start /min "C:\Program Files (x86)\Desktop Secretary"
        # start /min "C:\Program Files (x86)\Desktop Secretary"
        # cmd /c start /MIN 'C:\Program Files (x86)\Sony\VAIO System Diagnostic\CPU Fan Diagnostic\FDU.exe'
        # ./getclockspeed.ps1
        Start-Sleep -seconds $delay
    }
}
