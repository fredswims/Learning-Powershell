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


    #Launch Quicken and monitor its exit code.
    do {
        #$LastExitCode = 0
        if ($bSayit) { [Void]$oSynth.SpeakAsync(("{0}     you are invoking Quicken with {1}" -f $env:USERNAME, $Filename)) }

        # Launch Quicken using file association and WAIT for it to exit.
        $myprocess = start-process -FilePath $DestinationPath -passthru -Verbose
        if ($Priority) {
            write-host "PriorityClass: [$($MyProcess.PriorityClass)]"
            write-host "BasePriority:  [$($MyProcess.BasePriority)]"
            write-warning "Setting Quicken Process Priority to AboveNormal"
            start-sleep -Milliseconds 500; 
            $MyProcess.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::AboveNormal
        }
        start-sleep -Milliseconds 500; 
        "PriorityClass: $($MyProcess.PriorityClass)"
        "BasePriority:  $($MyProcess.BasePriority)"
        Write-Warning ("{0}{1}DO NOT CLOSE THIS WINDOW DO NOT CLOSE THIS WINDOW DO NOT CLOSE THIS WINDOW{2}" -f $PSStyle.Blink, $PSStyle.foreground.red, $psstyle.Reset)
        $Myprocess.WaitForExit()
        # Waiting for Quicken to exit
        $exitCode = $myprocess.ExitCode
        # Read-Host -Prompt "Last Exit Code  $($ExitCode)"

        "You worked with Quicken this long."
        New-TimeSpan -Start $myprocess.StartTime -End $myprocess.ExitTime # references $myprocess object.
        write-host "LastExitCode $ExitCode"
        if ($ExitCode -ne 0) {
            [console]::beep($ToneBad, $ToneDuration) #works for all versions
            $Sayit = "Oops, Quicken stopped with code $ExitCode Do you want to restart Quicken"
            if ($bSayit) { [Void]$oSynth.SpeakAsync($SayIt) }
            write-host -ForegroundColor "Red" $SayIt
            Do { $MyResponse = Read-Host "$SayIt [Y] Yes  [N]  No" }
            until ($MyResponse -like 'y*' -or $MyResponse -like 'n*')
            if ($MyResponse -like "n*") { $ExitCode = 0 }
        }
    } until ($ExitCode -eq 0)

Start-Process notepad -PassThru | Tee-Object -Variable myProcess
Start-Sleep -Seconds 2
$procDotNet = [System.Diagnostics.Process]::GetProcessById($myProcess.Id)
        $procDotNet = [System.Diagnostics.Process]::GetProcessById($MyProcess.Id)
        $procDotNet.PriorityClass
        $procDotNet.BasePriority
