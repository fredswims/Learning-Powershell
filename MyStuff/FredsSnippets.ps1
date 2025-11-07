# $PSVersionTable | ConvertTo-Json -Depth 3
# $PSVersionTable | ConvertTo-Json -Depth 3
# $PSBoundParameters | ConvertTo-Json -Depth 3
# $MyInvocation | ConvertTo-Json -Depth 5


Write-host "====== [Enumerating `$PSVerstionTable] Begins ======" -ForegroundColor "Yellow"
foreach ($entry in $PSVersionTable.GetEnumerator()) {
    "{0,-30}: {1}" -f $entry.Key, $entry.Value
}

write-host "Host is `n`t[$($host.Name)] Version [$($host.Version)]"
write-host "Process is `n`t[$((get-process -id $pid).path)]" #like $PSHome 
write-host "[`$psversiontable.GitCommitId] is [$($($psversiontable).GitCommitId)]"
write-host "[`$PSCommandPath] is `n`t[$($PSCommandPath)]"
write-host "`[[System.Environment]::commandline] is `n`t[$([System.Environment]::commandline)]"

Write-host "=== [get-process -id `$pid | format-list -property *] Begins ===" -ForegroundColor "Yellow"
get-process -id $pid | format-list -property *
Write-host "=== [get-process -id `$pid | format-list -property *] Ends ===" -ForegroundColor "Yellow"

write-host -foregroundColor yellow "Version of script:$ThisVersion"

"The current directory is [$(get-location)]"
"The Process Id is [$pid]"

Write-host "=== [`$MyInvocation] Begins ===" -ForegroundColor "Yellow"
$MyInvocation
Write-host "=== [`$MyInvocation]Ends ===" -ForegroundColor "Yellow"

Write-host "=== [`$MyInvocation.MyCommand.Path] Begins ===" -ForegroundColor "Yellow"
$MyInvocation.MyCommand.path
Write-host "=== [`$MyInvocation.MyCommand.Path] Ends ===" -ForegroundColor "Yellow"


function ShowTestAdministrator {
    Write-Warning "In function $($MyInvocation.MyCommand.Name):2020-11-13 "
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
$isElevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($isElevated) {
    Write-Host "Running as administrator"
} else {
    Write-Host "Not running as administrator"
}