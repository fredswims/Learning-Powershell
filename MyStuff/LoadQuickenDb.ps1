<#
.SYNOPSIS
Copyright 2017-2025 Fred-Arthur Jacobowitz (FAJ)
($ThisVersion = "Revision 2025-11-07 FAJ") # Refactoring for readability.

    Short description of the script
.DESCRIPTION
    Long description of the script
.EXAMPLE
    LoadQuickenDb1.ps1
    To asynchronously with 'conhost.exe' do the following
    $parameters = @{
            Filepath     = "conhost.exe"
            ArgumentList = "pwsh $($noexits) -noprofile -command `&  '$runThisScript' -Filename $arg -SourceDir $SourceDir -DestinationDir $DestinationDir -Priority"
        }
    start-process @parameters
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
    Transcript (start-transcription) output file is C:\Users\freds\Documents\Quicken\Powershell.out
    Start-Transcript -path $TranscriptFullName -IncludeInvocationHeader
.NOTES
    General notes
Revision History
Find this line "($ThisVersion = "2017-07-21 FAJ")" and update it to the current version.
2017-07-21 Function fjQuicken added Parameterset Names.
        Oh my, its been two years since last modification. Redo launching quicken and retrieving $lasterrorcode.
    2021-06-11 FAJ V4.1.6
    2024-11-08 FAJ Add sleep is changing priority (probably not needed.) Added Write-Warning NOT TO CLOSE THIS WINDOWS.
    2025-07-17 FAJ Fixed: Sometimes when Quicken exits this process does not come to foreground. See Function Restore-FocusShellWindow
    2025-08-20 FAJ Minimize the windows to expedite the type-ahead buffer going to Quicken. 
    #>
[CmdletBinding()]
param ([Parameter(Mandatory = $false,
        HelpMessage = "Enter the name of the Quicken data file; e.g., Home.qdf : ")]
    [System.IO.FileInfo]$FileName='Home.qdf',

    [Parameter(Mandatory = $false)]
    [System.IO.FileInfo]$SourceDir = (Join-Path -Path $env:Dropbox -ChildPath 'Private\Q'),
    
    [Parameter(Mandatory = $false)]
    [System.IO.FileInfo]$DestinationDir = (Join-Path -path $env:UserProfile -ChildPath 'Documents\Quicken'),

    [Parameter(Mandatory = $false)]
    [Switch]$Speak,

    [Parameter(Mandatory = $false)]
    [Switch]$Priority = $false,

    [Parameter(Mandatory = $false)]
    [Switch]$ShowDebug,

    [Parameter(Mandatory = $false)]
    [Switch]$StartStop,

    [Parameter(Mandatory = $false)]
    [Switch]$Pause
)
Function StartTranscript{ [CmdletBinding()] param (
    [Parameter(Mandatory)]
    [System.IO.FileInfo]$SourceDir,
    [Parameter(Mandatory = $false)]
    [Switch]$Pause
)
write-warning "Setting up Transcript file."
$TranscriptName ="QuickenTranscript.out"
$TranscriptNameOld = $TranscriptName + ".old"

$TranscriptFolder = $SourceDir #You need change only this line to change the location of the Transcript file.

# set the full path to the Transcript files.
($TranscriptFullName = Join-path $TranscriptFolder $TranscriptName)
($TranscriptFullNameOld = Join-path $TranscriptFolder $TranscriptNameOld)

Write-verbose "TranscriptFullName is [$TranscriptFullName]"
Write-verbose "TranscriptFullNameOld is [$TranscriptFullNameOld]"

# If the old transcript exists remove it.
if (test-path $TranscriptFullNameOld) { remove-item -Verbose $TranscriptFullNameOld }
# If the current transcript exists rename it to old.
if (test-path $TranscriptFullName) { rename-item -verbose -path $TranscriptFullName -newname $TranscriptFullNameOld }

write-host "Call [Start-Transcript] with path `n`t[$TranscriptFullName]"
if ($Pause) {Read-Host -Prompt "Press 'Enter' to start Transcript"} # for examining this process
Start-Transcript -path $TranscriptFullName -IncludeInvocationHeader
Write-host "=== Transcript Preamble Complete ===" -ForegroundColor "Yellow"
write-host $(Get-Date -Format "dddd yyyy-MM-dd HH:mm:ss K")
} # end function StartTranscript
function ShowTestAdministrator {
    Write-Warning "In function $($MyInvocation.MyCommand.Name):2020-11-13 "
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# Main Script begins here
if (! (Test-Path $SourceDir)) { read-host "The path to the Repository Workspace $SourceDir is incorrect"; exit }
StartTranscript -SourceDir $SourceDir -Pause:$Pause

($ThisVersion = "Revision 2025-11-07 FAJ") # Refactoring for readability.
Write-Host "Copyright 2017-2025 Fred-Arthur Jacobowitz (FAJ)"
# Write-Warning "In module `n`t[$($MyInvocation.MyCommand.Name)] $(Get-Date -format "dddd yyyy-MM-dd HH:mm:ss K")"
Write-Warning "In module `n`t[$($PSCommandPath)] `n`t$(Get-Date -format "dddd yyyy-MM-dd HH:mm:ss K")"
write-warning "Current Path `n`t[$(Get-Location)]"

Write-host "=== Invoked with Parameters ==="
write-host "the value of Filename is $Filename"
write-host "the value of SourceDir is $Sourcedir"
write-host "the value of DestinationDir is $Destinationdir"
write-host "the value of Speak is $Speak"
write-host "the value of Priority is $Priority"
write-host "the value of ShowDebug is $ShowDebug"
write-host "the value of StartStop is $StartStop"
write-host "the value of Pause is $Pause"

if ($StartStop) { Read-host "Terminating"; exit } #Just want to see how the function is invoked.
<#
This must be updated to reflect the current way to start the script.
Invoke like this:
powershell.exe -noprofile -file NameOfThisScript  -Filename "Home.qdf" -Speak
#>
if ($ShowDebug) { Set-PSDebug -strict -trace 2 } # I have not tested this
$ErrorActionPreference = "Stop" #failing cmdlets will jump to the 'catch' block
$Error.Clear()

#Before starting the Transcript we need to know where the run-time workspace is located.
Write-host "=== Beginning Script ===" -ForegroundColor "Yellow"
Set-StrictMode -Version latest #Be careful. I don't know all the implications of this setting!

# Set Window Title
$host.UI.RawUI.WindowTitle = 'DoNotCloseThisWindow'
if (test-path $DestinationDir) {
    write-host "Destination folder [$DestinationDir] exists"
}
else {
    #destination folder does not exist
    #it may be better to exit the program then to create this Folder.
    Read-host "the destination folder [$DestinationDir] does NOT exist.`n`t'Enter' will create it. Use control-C to quit."
    write-host "creating destination folder"
    new-item -verbose -path $DestinationDir -itemtype directory # was it created?
}

write-host "The current directory is `n`t[$(get-location)]" 
write-host "Setting location to `n`t[$DestinationDir]" #no compelling reason to change directory.
(set-location $DestinationDir -Verbose)
write-host "Directory changed to `n`t[$(get-location)]"

if (ShowTestAdministrator) { write-warning "*** Process is Elevated ***" } else { write-warning "Process not Elevated" }
write-warning ("Base Priority is [{0}]" -f (get-process -id $pid).BasePriority) 
Write-host "====== [Enumerating `$PSVerstionTable] Begins ======" -ForegroundColor "Yellow"
foreach ($entry in $PSVersionTable.GetEnumerator()) {
    "{0,-30}: {1}" -f $entry.Key, $entry.Value
}
Write-host "====== [Enumerating `$PSVerstionTable] Ends ======" -ForegroundColor "Yellow"

# $PSVersionTable | ConvertTo-Json -Depth 3

write-host "`$Host.Name is `n`t[$($host.Name)] and `$Host.Version is Version [$($host.Version)]" #does't show preview number
write-host "Process is `n`t[$((get-process -id $pid).path)]" #like $PSHome 
write-host "[`$psversiontable.GitCommitId] is [$($($psversiontable).GitCommitId)]" # best way to get PWSH Version.
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
$MyInvocation.MyCommand.path # eqiuvalent to $PSCommandPath
Write-host "=== [`$MyInvocation.MyCommand.Path] Ends ===" -ForegroundColor "Yellow"

$ToneGood = 500
$ToneBad = 250
$ToneDuration = 200

# Calls to these libraries will be used in Function Restore-FocusShellWindow
$signature = @"
[DllImport("user32.dll")] 
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll")] 
public static extern int SetForegroundWindow(IntPtr hwnd);
"@

$addTypeParams = @{
    MemberDefinition = $signature
    Name             = 'WindowAPI'
    Namespace        = 'Win32'  #optional Defines the logical container (namespace) that wraps your C# code.
    Language         = 'CSharp' #optional Language used in the member definition. Just keeps things explicit and reliable.
    PassThru         = $true
}

Try {
    write-host "Load the Type libraries"
    $TimeTemp = get-date
        $type = Add-Type @addTypeParams
    write-host "Load took" (New-TimeSpan -start $TimeTemp).totalseconds "seconds"
    
    $process = Get-Process -Id $Pid
    [IntPtr]$hwnd = $process.MainWindowHandle
    "[Process Id: {0}] [Name: {1}] [MainWindowHandle: {2}]" -f $process.Id, $process.name, $hwnd
    # read-host -Prompt "pause"

    if ($speak -and $IsCoreClr -ne $True) {
        [bool]$bSayit = $true
        #https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer(v=vs.110).aspx
        "Create object for System.speech"
        add-type -assemblyname system.speech
        $oSynth = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
        $oSynth.rate = 3 # range -10 to 10
        $SayIt = "Quicken"
        $SayIt = "$env:USERNAME     you are invoking Quicken"
        #$oSynth.SpeakAsync($SayIt)
    }
    else { [bool]$bSayit = $false; "No Speech" }

    if ( $null -ne (Get-Process "qw"-ErrorAction Ignore) ) {
        $SayIt = "Quicken is running"
        if ($bSayIt) { [Void]$oSynth.SpeakAsync($SayIt) }
        write-host -ForegroundColor Red $SayIt
        read-host "press RETURN to exit"
        exit #invoke Catch Block.
    }

    $SayIt = "Using {0}" -f $Filename
    write-host -ForegroundColor yellow $SayIt
    if ($bSayIt) { [Void]$oSynth.SpeakAsync($SayIt) }
    Write-host -ForegroundColor yellow "The path to the Repository is $SourceDir"
    #Now test the SourceDir exists. If it doesn't then exit.
    if (! (Test-Path $SourceDir)) { read-host "The path to the Repository Workspace $SourceDir is incorrect"; exit }

    #Is the file in the Repository?
    $SourcePath = Join-Path $SourceDir $FileName
    if (!(Test-Path $SourcePath)) {
        read-host "The Repository file path $SourcePath does not exist."; exit
    }
    else {
        write-warning "The file in the Repository is $SourcePath"
        $FileIn = get-item $SourcePath | Select-Object Fullname, CreationTime, LastWriteTime, LastAccessTime, Length
        $FileIn | format-list Fullname, CreationTime, LastWriteTime, LastAccessTime, @{ Name = 'Size in Megabytes'; Expression = { $psitem.length / (1Mb) } }
        #read-host "check last modified time"
    }

    [System.IO.FileInfo]$DestinationPath = Join-Path $DestinationDir $FileName #fullpath to Quicken data file.
    # Is the file already in the working folder?
    if (test-path $DestinationPath) {
        $Sayit = "The data file is already in the working folder '$($DestinationDir)'. Do you want to use it? "
        if ($bSayit) { [Void]$oSynth.SpeakAsync($Sayit) }
        Write-Warning  $SayIt
        get-item $DestinationPath | format-list Fullname, CreationTime, LastWriteTime, LastAccessTime, @{ Name = 'Size in Megabytes'; Expression = { $psitem.length / (1Mb) } }
        Do {
            $MyResponse = Read-host "$SayIt [Y] Yes  [N]  No"
        } until ($MyResponse -like 'y*' -or $MyResponse -like 'n*')

        if ( $MyResponse.tolower() -like "n*") {
            # Rename existing file (file.ext -> file-2020-01-18T14:20:22.ext) and
            # Get a copy of the file that is in the repository.
            $Sayit = "Renaming the file in the working directory and replacing it with a copy in the repository."
            if ($bSayit) { [Void]$oSynth.SpeakAsync($Sayit) }
            Write-Warning  $SayIt
            
            # append the date and time to the current file.S
            $tempTime=$(get-date -format "yyyy-MM-ddTHH-mm-ss")
            Rename-Item -force -verbose `
                -path $DestinationPath `
                -NewName "$($DestinationPath.basename)-$tempTime$($DestinationPath.extension)"
            Copy-Item -verbose $SourcePath $DestinationDir
        }
        else {
            $Sayit = "Using the file that is already in the working directory."
            if ($bSayit) { [Void]$oSynth.SpeakAsync($Sayit) }
            Write-Warning  $SayIt
        }
    }
    else {
        # The file was not in the working folder.
        # Use a copy of the file that is in the repository.
        Copy-Item -verbose $SourcePath $DestinationDir
    }
    $BeginTime = get-item $DestinationPath | Select-Object Fullname, CreationTime, LastWriteTime, LastAccessTime, Length
    $BeginTime | format-list Fullname, CreationTime, LastWriteTime, LastAccessTime, @{ Name = 'Size in Megabytes'; Expression = { $psitem.length / (1Mb) } }

    Write-Warning  "Information::Launching Quicken by referencing the data file in $DestinationPath"
    # minize the window to expidite the type-ahead buffer going to quicken.
    $null = $type::ShowWindowAsync($hwnd, 6) # Minimize it first so that Maximize will make Z-order top window if other windows are maximized.

    $ExitCode = 1
    do {
        #$LastExitCode = 0
        if ($bSayit) { [Void]$oSynth.SpeakAsync(("{0}     you are invoking Quicken with {1}" -f $env:USERNAME, $Filename)) }

        # Launch Quicken using file association and WAIT for it to exit.
        $MyProcess = start-process -FilePath $DestinationPath -passthru -Verbose
        if ($Priority) {
            write-host "PriorityClass: [$($MyProcess.PriorityClass)]"
            write-host "BasePriority:  [$($MyProcess.BasePriority)]"
            write-warning "Setting Quicken Process Priority to AboveNormal"
            start-sleep -Milliseconds 1000; 
            $MyProcess.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::AboveNormal
        }
        start-sleep -Milliseconds 2000 
        "PriorityClass: $($MyProcess.PriorityClass)"
        "BasePriority:  $($MyProcess.BasePriority)"
        $procDotNet = [System.Diagnostics.Process]::GetProcessById($MyProcess.Id)
        $procDotNet.PriorityClass
        $procDotNet.BasePriority

        Write-Warning ("{0}{1}DO NOT CLOSE THIS WINDOW DO NOT CLOSE THIS WINDOW DO NOT CLOSE THIS WINDOW{2}" -f $PSStyle.Blink, $PSStyle.foreground.red, $psstyle.Reset)
        $MyProcess.WaitForExit()
        # Waiting for Quicken to exit
        $exitCode = $MyProcess.ExitCode
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

    "Maximize this window and give it the focus"
    function Restore-FocusShellWindow {
        param([IntPtr]$hwnd)
        # param($hwnd)
        $null = $type::ShowWindowAsync($hwnd, 6) # Minimize it first so that Maximize will make Z-order top window if other windows are maximized.
        Start-Sleep -Milliseconds 150
        $null = $type::ShowWindowAsync($hwnd, 3) # Maximize
        $null = $type::SetForegroundWindow($hwnd)
    }
    Restore-FocusShellWindow $hwnd
 
    #At this point Quicken has exited. Now decide what to do with the data file we where working with.
    [console]::beep($ToneGood, $ToneDuration) #works for all versions
    write-warning "INFORMATION::The file in the runtime workspace is $DestinationPath"
    $DoneTime = get-item $DestinationPath | Select-Object Fullname, CreationTime, LastWriteTime, LastAccessTime, Length
    $DoneTime | format-list Fullname, CreationTime, LastWriteTime, LastAccessTime, @{ Name = 'Size in Megabytes'; Expression = { $psitem.length / (1Mb) } }
    [timespan]$ElapsedTime = ($DoneTime.LastWriteTime - $BeginTime.LastAccessTime)
    "You worked on this file for:"
    $ElapsedTime | format-list *
    $NewSize = ($DoneTime.Length - $BeginTime.Length) / 1Mb
    "File increased by {0} Mb" -f $NewSize
    $SayIt = "Do you want to move this file to the repository?"
    if (TEST-PATH VARIABLE:\PSSTYLE) { "{0}We are back{0}" -f $psstyle.BlinkOff, $psstyle.Blink }
    if ($bSayit) { [void]$oSynth.SpeakAsync($SayIt) }
    Do { $MyResponse = Read-host "$SayIt [Y] Yes  [N]  No" }
    until ( ($MyResponse -eq "yes" ) -or ($MyResponse -like "n*") )

    if ($MyResponse -like "y*") {
        $Sayit = "Moving '$Filename' to the repository "
        if ($bSayIt) { [void]$oSynth.SpeakAsync($SayIt) }
        # The previous run created a copy (SourcePath.old) in the repository.
        # Remove the copy and create a copy of the current file before replacing it with the working copy.
        # Future enhancement: The .old file should not be discarded until the working copy is successfully moved into the repository.
        "Moving the working file to the Repository - Housekeeping"
        if (Test-Path "$SourcePath.old") { get-date; remove-item -verbose -Force "$SourcePath.old" }
        Get-Date; rename-item -verbose -force $SourcePath "$Sourcepath.old"
        Get-Date; move-Item -verbose $DestinationPath $SourceDir -force
        if ($?) { "Moving the working file to the Repository - Completed" }
        write-host  -foregroundColor Yellow "$($Sayit) at $(Get-Date) " # "V2.15.3"
        [console]::beep($ToneGood, $ToneDuration)
        Write-Warning "INFORMATION:: The updated file in the Repository is $SourcePath"
        get-item $SourcePath | format-list Fullname, CreationTime, LastWriteTime, LastAccessTime, @{ Name = 'Size in Megabytes'; Expression = { $psitem.length / (1Mb) } }
    }
    else {
        #chose to keep the working file in the repository.
        $SayIt = "Do you want to move $($Filename) to the recycle-bin?"
        if ($bSayit) { [Void]$oSynth.SpeakAsync($SayIt) }
        Do { $MyResponse = Read-host "$($SayIt) [Y] Yes  [N]  No" }
        until ( ($MyResponse -eq "yes" ) -or ($MyResponse -like "n*") )
        if ($MyResponse -like "y*") {
            $SayIt = "MOVING $($Filename) to the recycle-bin  "
            write-host  -foregroundColor Yellow "$SayIt at $(Get-Date) " # "V2.15.3"
            if ($bSayIt) { $oSynth.Speak($SayIt) }
            Add-Type -AssemblyName Microsoft.VisualBasic
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($DestinationPath, 'OnlyErrorDialogs', 'SendToRecycleBin')
            if ($?) { Write-Warning "[$($DestinationPath)] moved to the recycle bin" } else { remove-item $DestinationPath }
            [console]::beep($ToneGood, $ToneDuration)
        }
        else {
            #keep the working file stays in the runtime workspace.
            $SayIt = "Leaving the working file"
            if ($bSayIt) { $oSynth.Speak($SayIt) }
            write-host  -foregroundColor Yellow $SayIt
            #Read-Host "$SayIt"
            [console]::beep($ToneBad, $ToneDuration)
        }
    }
    #Push *.dat files to subdirectory
    # $DatFolder=join-path $DestinationDir "Dat"
    # if (!(test-path $DatFolder)) {New-Item -ItemType "directory" -path $DatFolder}
    # $SayIt = "moving D A T files to subdirectory"
    # if ($bSayIt) {$oSynth.Speak($SayIt)}
    # write-host $SayIt
    # copy-Item -path (join-path $DestinationDir ($filename.basename + "*.dat")) -destination $DatFolder
    # remove-Item -path (join-path $DestinationDir ($filename.basename + "*.dat"))

} #end try
catch {
    write-warning "'Catch' block begins"
    if ($IsCoreCLR) { get-error }
    $error[0]
    $Sayit = "Something went wrong!"
    write-host -ForegroundColor Red $SayIt
    if ($bSayIt) { $oSynth.Speak($SayIt) }
    for ($i = 1; $i -le 3; $i++ ) { [console]::beep($ToneBad, $ToneDuration) }

    Read-Host -prompt "This gives you a chance to see what went wrong."
    write-warning "'Catch' block ends"
}
Finally {
    write-warning "'Finally' block starts"
    $SayIt = "Completed with {0} errors." -f $error.count
    Write-Warning $SayIt
    If ($bSayIt) { $oSynth.Speak($SayIt) }
    Foreach ($item in $error) { $item }
    $Sayit = "Fin E"
    write-host -ForegroundColor yellow $SayIt
    if ($bSayIt) {
        $oSynth.Speak($SayIt)
        $oSynth.Dispose()
    }
    write-warning "'Finally' block ends"
    Get-History -Verbose
    Stop-Transcript
    #if ($error.count -ge 1) {Read-Host -prompt "'Enter' to quit"}
    if ($error.count -gt 0) { Read-Host -prompt "'Enter' to quit" }
    explorer.exe $DestinationDir #spawn file-manager
}