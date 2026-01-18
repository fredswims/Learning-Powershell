#FAJ January 2026
#Wrapper for fjunAIme.ps1 to run as scheduled task and pop-up a BurntToast notification.
#Use Task Scheduler to run this script at desired intervals.

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$TaskName # Name of scheduled task
)
    <#
        .SYNOPSIS
        Frees up AI memory.
        AUTHOR:FAJ January 2026
        REVISION HISTORY:FAJ 2026.01.17 Version 1.1.2
    #>

function PopBurntToast {
    param(
        [Int64]$PSReadLineVersion=9,
        [string]$mode,
        [double]$TriggerGB,
        [double]$AIusedGB,
        [string]$Url = ''  # file:///C:/Users/Freds/mystuff/logs/fjUnAImeTranscript.log
    )
    <# 
        Burnt Toast MAY not work with PWSH app INSTALLED from the STORE.
        It works with an '.msi' installation. Documented as such for the PREVIEW."
    #>
    Write-Host "In function $($MyInvocation.MyCommand.Name):"
    Write-Host "`$mode is $Mode"

    $IsElevated=$([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $Process=get-process -id $PID
    # Determine if we have a parent process.
    $HasParent = if ([System.String]::IsNullOrEmpty($Process.parent.id)) {$false} else {$true}

    write-host "`$PSHOME is $psHome"
    write-host ("***The process path is '{0}{1}{2}'" -f $psStyle.Blink, $Process.Path, $psStyle.BlinkOff)
    if ($HasParent) {
        write-host ("***The parent path is '{0}{1}{2}'" -f $psStyle.Blink, $Process.Parent.Path, $psStyle.BlinkOff)
        $Preview= if ($Process.parent.path.Contains('Preview')) {" Preview"} else {""}
    }
    
    $btn = New-BTButton -Content 'See Log' -Arguments $Url
    # Build BTtext
    # $BTtext = @()
    # $BTtext += "[AI Used: $([math]::Round($AIUsedGB,3)) GB]"
    # $BTtext += "[Trigger $TriggerGB GB]"
    # $BTtext += "[PWSH $($psversiontable.PSEdition) $($psversiontable.PSVersion)]"
    if ($HasParent) {$BTtext += "`n[Parent: {0}]" -f $($Process.parent.name + $Preview)}
    if ($IsElevated) {$BTtext += " [Admin]"} else {$BTtext += ""}
    $BTtext += "`n$Mode"

    # Create and show the toast notification
    # Build Header
    $id ='001'
    $myString1 = "BurntToast Version $((get-installedpsresource -name burntToast)[0].version.tostring())"
    $MyString2 = "Scheduled Task: $($TaskName)"

    $header = New-BTHeader -Id $id -Title $MyString2
        
    $parameters = @{       
        Attribution = $myString1
        Header      = $header
        Text        = $BTtext
        Silent      = $true
        Button      = $btn
    }
    new-BurntToastNotification @parameters 
    write-host $BTtext
    Write-Output "Leaving function $($MyInvocation.MyCommand.Name):"

} #end PopBurntToast

function Test-IsScheduledTask {
    # Method A: parent process
    Write-Host "In function [$($MyInvocation.MyCommand.Name)] [$(Get-Date -format o)]"

    # get parent process name using CIM because $process.parent.name is not always available.
    $parent = (Get-CimInstance Win32_Process -Filter "ProcessId = $PID").ParentProcessId
    $parentName = (Get-Process -Id $parent).Name
    write-host "Parent Process Name: [$parentName]"
    write-host "Session Name: [$env:SESSIONNAME]"

    # One of these methods should indicate if we are running under Task Scheduler.
    # Method A: parent process name
    if ($parentName -in 'taskeng', 'svchost') {
        return $true
    }
    # Method B: session name
    if ($env:SESSIONNAME -eq 'Service') {
        return $true
    }
    return $false
}#end Test-IsScheduledTask

#region Script Body
#task scheduler call example:
#   set working directory to $home\mystuff
#   Program/script: pwsh
#   arguments: -w Hidden -nonInteractive -noProfile -noLogo `
            -file "C:\Users\freds\OneDrive\PowershellScripts\MyStuff\fjUnAIme1.ps1" 
#dot source and then call the function
$TranscriptPath= (join-path $home MyStuff Logs "$($TaskName)Transcript.log")
$Url = [System.Uri]::new($TranscriptPath).AbsoluteUri # convert to file:// URI for BurntToast link
# $TranscriptPath= (join-path  Logs fjUnAImeTranscript.log) # relative to current directory set in task scheduler.     

Start-Transcript -Path $TranscriptPath -Append
Write-warning "`n[$(Get-Date -format o)]`nIn Script [$($PSCommandPath)]"
# Write-warning "In Script [$($PSCommandPath)]: [$(Get-Date -Format o)] "
$WorkingDir = (get-location).path
write-host -msg ("Working Directory [$WorkingDir]")

$IsScheduledTask = Test-IsScheduledTask
if ($IsScheduledTask) {
    Write-host -msg "`tRunning under Task Scheduler"
    Write-host -msg "`tThe Scheduled Task Name is [$($TaskName)]"
} else {
    Write-Host -msg "Running interactively"
}

# dot source fjUnAIme.ps1 (function fjUnAIme)
# . C:\Users\freds\MyStuff\fjUnAIme.ps1
. (Join-Path $HOME 'mystuff' 'fjunaime.ps1') # alternate but not preferred -> [Invoke-Expression ". '$HOME/mystuff/fjunaime.ps1'"]
# fjunaime -stop -LeaveServiceRunning
#fjunaime returns a string object with a property 'mode' that contains what was done. 
$Mymode=$(fjunaime -Auto)
PopBurntToast -mode $Mymode.mode.tostring() -TriggerGB $Mymode.Trigger -AIusedGB $Mymode.AIUsed -Url $Url
Stop-Transcript
Write-Host "Exiting Script $($PSCommandPath): [$(Get-Date -Format o)]"