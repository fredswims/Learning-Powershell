function PopBurntToast {
    param(
        [Int64]$PSReadLineVersion=9,
        [string]$mode
    )
    <# 
        Burnt Toast MAY not work with PWSH app INSTALLED from the STORE.
        It works with an '.msi' installation. Documented as such for the PREVIEW."
    #>
    Write-Host "In function $($MyInvocation.MyCommand.Name):"
    Write-Host "`$mode is $Mode"
    # [string[]]$BTtext=@()
    $IsElevated=$([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $IsOnline=test-connection www.microsoft.com -count 1 -ping -quiet
    $Process=get-process -id $PID
    # Determine if we have a parent process.
    $HasParent = if ([System.String]::IsNullOrEmpty($Process.parent.id)) {$false} else {$true}

    write-host "`$PSHOME is $psHome"
    write-host ("***The process path is '{0}{1}{2}'" -f $psStyle.Blink, $Process.Path, $psStyle.BlinkOff)
    if ($HasParent) {
        write-host ("***The parent path is '{0}{1}{2}'" -f $psStyle.Blink, $Process.Parent.Path, $psStyle.BlinkOff)
        $Preview= if ($Process.parent.path.Contains('Preview')) {" Preview"} else {""}
    }
    
    # Build BTtext
    $BTtext += "[PWSH $($psversiontable.PSEdition) $($psversiontable.PSVersion)]"
    # fix this. Use fjgpp.  foreach ..name like "terminal" ) | split-path -leaf ($p.processpath.split -leaf)
    if ($HasParent) {$BTtext += "`n[Parent: {0}]" -f $($Process.parent.name + $Preview)}
    # $BTtext += "`n[PSReadline: $($PSReadLineVersion)]"
    # if ($IsOnline) {$BTtext += "`n[Online]"} else {$BTtext += "`n[Not Online]"}
    if ($IsElevated) {$BTtext += " [Elevated]"} else {$BTtext += " [Not Elevated]"}
    $BTtext += $Mode
    $header = New-BTHeader -Id '001' -Title "BurntToast Version $((get-installedpsresource -name burntToast)[0].version.tostring())"
    $parameters = @{       
        Attribution = "Scheduled Task fjUnAIme1.ps1"
        Header      = $header
        Text        = $BTtext
        Silent      = $true
    }
    new-BurntToastNotification @parameters 
    write-host $BTtext
    Write-Output "Leaving function $($MyInvocation.MyCommand.Name):"

} #end PopBurntToast

function Test-IsScheduledTask {
    # Method A: parent process
    Write-Host "In function $($MyInvocation.MyCommand.Name):"

    $parent = (Get-CimInstance Win32_Process -Filter "ProcessId = $PID").ParentProcessId
    $parentName = (Get-Process -Id $parent).Name
    write-host "Parent Process Name: $parentName"
    write-host "Session Name: $env:SESSIONNAME"

    if ($parentName -in 'taskeng', 'svchost') {
        return $true
    }

    # Method B: session name
    if ($env:SESSIONNAME -eq 'Service') {
        return $true
    }

    return $false
}

#region Script Body
#task scheduler call example:
# Program/script: pwsh
# arguments: -w Hidden -nonInteractive -noProfile -noLogo -file "C:\Users\freds\OneDrive\PowershellScripts\MyStuff\fjUnAIme1.ps1" *> "C:\Users\freds\OneDrive\PowershellScripts\MyStuff\fjUnAiMe1.log"
#dot source and then call the function
$TranscriptPath= (join-path $home MyStuff Logs fjUnAImeTranscript.log)
Start-Transcript -Path $TranscriptPath -Append
Write-warning "`PScommandpath In Script $($PSCommandPath): [$(Get-Date -Format o)] "
Write-host "Write-host In Script $($PSCommandPath): [$(Get-Date -Format o)] "

"UserName: $env:USERNAME" 
"UserProfile: $env:USERPROFILE" 
Write-Host "Script started at $(Get-Date)"
Write-Error "Write-Error This is an error test"
Write-Verbose "Verbose test" -Verbose
Write-Host "In function $($MyInvocation.MyCommand.Name): [$(Get-Date -Format o)] "
$IsScheduledTask = Test-IsScheduledTask
if ($IsScheduledTask) {
    Write-host "Using Write Host Running under Task Scheduler"
} else {
    Write-Host "Running interactively"
}
write-host "IsScheduledTask: $IsScheduledTask"

# [string]$MyMode=$null
. C:\Users\freds\MyStuff\fjUnAIme.ps1
# fjunaime -stop -LeaveServiceRunning 
$Mymode=$(fjunaime -auto -limitgb 2.77)
write-host "`$myMode is $mymode.mode"
PopBurntToast -mode $Mymode.mode
Stop-Transcript
Write-Host "Exiting Script $($PSCommandPath): [$(Get-Date -Format o)]"