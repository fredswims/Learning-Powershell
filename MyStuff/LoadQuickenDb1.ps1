<<<<<<< HEAD
﻿<#
.SYNOPSIS
    Short description of the script
.DESCRIPTION
    Long description of the script
.EXAMPLE
    PS C:\\> Get-WhatTimeIsItNow.ps1
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
#fred was here
param ([Parameter(Mandatory = $true,
        HelpMessage = "Enter the name of the Quicken data file; e.g., Home.qdf : ")]
    [System.IO.FileInfo]$FileName,

    [Parameter(Mandatory=$false)]
    [System.IO.FileInfo]$SourceDir =  (Split-Path -Parent -Path "$PSCommandPath"),
    [Parameter(Mandatory=$false)]
    [System.IO.FileInfo]$DestinationDir = (Join-Path $env:HOMEDRIVE$env:HOMEPATH 'Documents\Quicken'),

    [Parameter(Mandatory = $false)]
    [Switch]
    $Speak,

    [Parameter(Mandatory = $false)]
    [Switch]
    $ShowDebug,

    [Parameter(Mandatory = $false)]
    [Switch]
    $StartStop
)

write-host "the value of Filename is $Filename"
write-host "the value of DestinationDir is $Destinationdir"
write-host "the value of Speak is $Speak"
write-host "the value of ShowDebug is $ShowDebug"
write-host "the value of StartStop is $StartStop"

if ($StartStop) { Read-host "Terminating"; exit } #Just want to see how the function is invoked.
<#
Invoke like
powershell.exe -noprofile -file NameOfThisScript  -Filename "Home.qdf" -Speak
or

#>
if ($ShowDebug) { Set-PSDebug -strict -trace 2 } # I have not tested this
($ThisVersion = "V4.1.3 2020-03-16")
$ErrorActionPreference = "Stop" #failing cmdlets will jump to the 'catch' block
$Error.Clear()
<#
The name of this script is "LoadQuickenDb.ps1"
2017-08-20 - Copyright 2017 FAJ

One day I should put in the standard established for Powershell Headers.
Mod 2017-10-15 - Push *.dat files to the dat subfolder.
Mod 2017-11-19 - When Quicken exits bring this window to the foreground.
Added function 'Maximize-ThisWindow($Process, [Switch]$Maximize)'
Mod 2018-05-24 'Loop on Read-Host
2019-02-19 FAJ
    Changed launch of Powershell using an Alias in profile.ps1 as
      #function fQuickenHome {$command='C:\Users\Super` Computer\Dropbox\Private\Q\LoadQuickenDb.ps1 home.qdf -Speak';start-process powershell -argumentlist $command;remove-variable command}
      function fQuickn ($arg="home") {$command=join-path $env:HOMEPATH -ChildPath \Dropbox\Private\Q\LoadQuickenDb.ps1; `
      start-process powershell -Args "-noprofile -command & {. '$($command)' $arg.qdf -speak }";remove-variable command}
      set-alias -name Quickn -value fQuickn -Option Readonly -passthru | format-list
      or from a shortcut as C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "& 'C:\Users\Super Computer\Dropbox\Private\Q\LoadQuickenDb.ps1'  home.qdf -Speak"
    Added tracing of arguments
2019-02-23 FAJ
    If file already in destination folder show dates
    Added comment lines so they show in log.
2019-02-24 FAJ
    $SourceDir is now based on "$MyInvocation.MyCommand.Path". Assumption is the script and the files reside in the Repository Workspace.
2019-04-09 FAJ V2.15
    Are we running CORE?
    using if ($psversiontable.psedition -ne "CORE") but this may change in the future when Powershell is renamed.
    Perhaps the executable name should be tested.
    Then
        Cannot set $bSayit to $true
        Cannot load [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($DestinationPath, 'OnlyErrorDialogs', 'SendToRecycleBin')

2019-05-31 FAJ V3.0.0
    Added params to this script.
    It should be called like this
    powershell.exe -noprofile -file $FullPathToScriptFile -Filename DataFileLikeHOME.QDF [-Speak] [-DebugMessages]
    *** We assume the DataFile is in the folder (the REPOSITORY) where the script resides.

2019-06-05 FAJ V3.0.1
    Set the proper console display for "read-response" to  [Y] Yes  [N]  No"
    and if reponse was improper added Do-While loop where previously left out.
    Changed some instances of write-host to write-warning.
    Cast to [Void] calls to $oSynth.SpeakAsync($SayIt) ([Void]$oSynth.SpeakAsync($SayIt))
    to eliminate the appearance of "Compeleted" on the console

2019-06-08 FAJ V3.0.5
    Experimenting with allowing responses to be "y" or "yes", etc..
    The alias for quickn is invoking LoadQuickenDb1.ps1.
    Becareful what is commited to github.

2019-06-08 FAJ V3.0.6
    Added StartStop param. When set the function prints the params and exits.

2019-06-15 FAJ V3.0.7 and V3.0.8
    Modified responses to Read-Host.

2019-06-28 FAJ V3.0.9
    $SayIt="Do you want to replace the file in the repository?"

2019-07-09 FAJ V3.0.10
    The reverting the message to somewhat like the original.
    $Sayit="Do you want to move this file to the repository?"
    Prior to moving the file;
    #in the repository,
    make a backup of the file in the repository
    but first remove the prevous one.
        <remove-item home.qdf.old>
        <rename-item home.qdf -> home.qdf.old>

2020-01-03 FAJ V4.0.0
        Improvements in error handling.
        Use of -Verbose and $ErrorActionPreference = "Stop"
        Try,Catch,Finish embelishments for Powershell Preview 7
2020-01-04 FAJ V4.0.1
        Minor changes - eliminating audit information made redundant by -verbose.
2020-01-04 FAJ V4.0.2
        Added Parameter $DestinationDir
2020-01-10 FAJ V4.0.3
        Streamlined the function Maximize-ThisWindow and removed 2nd parameter.
2020-01-18 FAJ V4.1.0.1
        If the file is already in the working directory and you don't want to use it
        rename it (append the date and time to the basename) before copying the file from the repository.
2020-01-20 FAJ V4.1.0.2
        $SoureDir is now an input parameter that defaults to the foler where this command resides; $SourceDir =  (Split-Path -Parent -Path "$PSCommandPath"),
2020-03-11 FAJ V4.1.1
        Load assemblies at the start of the Try block.
        Show final prompt only if errors occurred.
        <#
2020-03-15 FAJ V4.1.2
        Move file to recycle bin works with Powershell 7.
        Replaced ($psversiontable.psedition -ne "CORE") with ($IsCoreClr -ne $true)
2020-03-15 FAJ V4.1.3
        replaced three lines of [console]::beep(n,m) with single line 'For"
2020-05-25 FAJ V4.1.4
        Fixed spelling, added pause to if file in repository is correct.

This script invokes Quicken and requires 2 arguments on the command line invoking it.
The first argument is the name of a Quicken data file.
The second argument is the a string with indicates if you want to enable text-to-speech prompts; Speak | NoSpeak
Here is an example of the Target property in a SHORTCUT on my Desktop;
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "& C:\Users\Super` Computer\Documents\Dropbox\Private\Q\LoadQuickenDb.ps1 home.qdf -Speak"
Notice
1)the &
2)the escape after the word 'Super' as there is a space in the path.


This script invokes Quicken with a COPY of your data file. I refer to this file as $FileName

I keep my data file(s) in a folder called Dropbox\Private\Q\. I refer to this folder and file as the repository workspace- $SourceDir and $SourcePath
The copy is placed in the run-time workspace. This workspace is on the local machine and is not in a path that uses any cloud services.
Quicken uses $env:homepath/Documents/Quicken as the run-time workspace.
I refer to this folder and file as $DestinationDir and $DestinationPath
If it already is on the desktop you can overwrite it or use the existing file on the desktop.

When Quicken exits you decide if you want to delete the copy or move it back to the repository. Moving to back to the repository OVERWRITES the original file.
If you delete the file it is moved to the RecycleBin.
#>

# Begin
#Before starting the Transcript we need to know where the run-time workspace is located.
Write-Host "**************Beginning Script" -ForegroundColor "Yellow"
Set-StrictMode -Version latest #Before careful. I don't know all the implications of this setting!

#Find the run-time workspace.
#$DestinationDir = Join-Path $env:HOMEDRIVE$env:HOMEPATH "Documents\Quicken" #This is where Quicken likes the run-time file to be.
write-host "Does destination folder exist?"
if (test-path $DestinationDir) {
    #it exists
    write-host "Destination folder $DestinationDir exists"
}
else { #destination folder does not exist
    #it may be better to exit the program then to create this Folder.
    Read-host "the destination folder $DestinationDir does not exist;'Enter' will create it. Otherwise control-C to quit."
    write-host "creating destination folder"
    new-item -verbose -path $DestinationDir -itemtype directory # was it created?
}
$TranscriptName = "Powershell.out"
$TranscriptFullName=Join-path $DestinationDir $TranscriptName
$TranscriptNameOld = $TranscriptName + ".old"
$TranscriptFullNameOld=Join-path $DestinationDir $TranscriptNameOld
if (test-path $TranscriptFullNameOld) { remove-item -Verbose $TranscriptFullNameOld }
if (test-path $TranscriptFullName) { rename-item -verbose -path $TranscriptFullName -newname $TranscriptFullNameOld }
Start-Transcript -path $TranscriptFullName -IncludeInvocationHeader

#Write-Host "**************Beginning Script**************" -ForegroundColor yellow
"Location of Powershell is {0}" -f $PSHome
write-host (get-process -id $pid).processname
get-process -id $pid | format-list -property *
write-host $(Get-Date)
write-host -foregroundColor yellow "Version:$ThisVersion"
"The current directory is {0}" -f (get-location)
"The Process Id is {0}" -f $pid
"MyInvocation follows"
$MyInvocation
"MyInvocation.MyCommand.path follows"
$MyInvocation.MyCommand.path
#Set-PSDebug -Step


$ToneGood = 500
$ToneBad = 100
$ToneDuration = 500

Try {
    $sig = '
        [DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
        [DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hwnd);
        '
        write-host "Load the Type libraries"
        $TimeTemp=get-date
        $type = Add-Type -MemberDefinition $sig -Name WindowAPI -PassThru
        write-host "Load took" (New-TimeSpan -start $timetemp).totalseconds "seconds"
        $process=Get-Process -Id $pid
        $hwnd = $process.MainWindowHandle
<#
    function Maximize-ThisWindow($Process) {
        #https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-showwindow
        $sig = '
        [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
        [DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hwnd);
        '
        #This next line takes a long time to execute
        $type = Add-Type -MemberDefinition $sig -Name WindowAPI -PassThru
        $hwnd = $process.MainWindowHandle
        $null = $type::ShowWindow($hwnd, 9) #SW_RESTORE 9 Activates and displays the window.
        $null = $type::SetForegroundWindow($hwnd) #puts cursor in windows
    }
    #Maximize-ThisWindow -Process (get-process -id $pid)  #Will this work for CORE?
#>
    if ($speak -and $IsCoreClr -ne $True) {
            [bool]$bSayit = $true
        #https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer(v=vs.110).aspx
        add-type -assemblyname system.speech
        $oSynth = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
        $oSynth.rate = 3 # range -10 to 10
        $SayIt = "Quicken"
        $SayIt = "$env:USERNAME     you are invoking Quicken"
        #$oSynth.SpeakAsync($SayIt)
    }
    else { [bool]$bSayit = $false }

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
        $FileIn=get-item $SourcePath | Select-Object Fullname, CreationTime, LastWriteTime, LastAccessTime, Length
        $FileIn | format-list Fullname, CreationTime, LastWriteTime, LastAccessTime,@{ Name = 'Size in Megabytes';  Expression = {$psitem.length/(1Mb)}}
        read-host "check last modified time"
    }

    [System.IO.FileInfo]$DestinationPath = Join-Path $DestinationDir $FileName #fullpath to Quicken data file.
    # Is the file already in the working folder?
    if (test-path $DestinationPath) {
        $Sayit = "The data file is already in the working folder '$($DestinationDir)'. Do you want to use it? "
        if ($bSayit) {[Void]$oSynth.SpeakAsync($Sayit)}
        Write-Warning  $SayIt
        get-item $DestinationPath | format-list Fullname, CreationTime, LastWriteTime, LastAccessTime, @{ Name = 'Size in Megabytes';  Expression = {$psitem.length/(1Mb)}}
        Do {
            $MyResponse = Read-host "$SayIt [Y] Yes  [N]  No"
        } until ($MyResponse -like 'y*' -or $MyResponse -like 'n*')

        if ( $MyResponse.tolower() -like "n*") {
            # Rename existing file (file.ext -> file-2020-01-18T14:20:22.ext) and
            # Use a copy of the file that is in the repository.
            $Sayit = "Renaming the file in the working directory and using a copy of the file that is in the repository."
            if ($bSayit) { [Void]$oSynth.SpeakAsync($Sayit) }
            Write-Warning  $SayIt
            Rename-Item -Verbose $DestinationPath -NewName "$($DestinationPath.basename)-$(get-date -format "yyyy-MM-ddTHH-mm-ss")$($DestinationPath.extension)"
            Copy-Item -verbose $SourcePath $DestinationDir
        }
        else {
            $Sayit = "Using the file that is already in the working directory."
            if ($bSayit) {[Void]$oSynth.SpeakAsync($Sayit)}
            Write-Warning  $SayIt
        }
    }
    else {
        # The file was not in the working folder.
        # Use a copy of the file that is in the repository.
        Copy-Item -verbose $SourcePath $DestinationDir
    }
    $BeginTime=get-item $DestinationPath | Select-Object Fullname, CreationTime, LastWriteTime, LastAccessTime, Length
    $BeginTime | format-list Fullname, CreationTime, LastWriteTime, LastAccessTime,@{ Name = 'Size in Megabytes';  Expression = {$psitem.length/(1Mb)}}

    Write-Warning  "Information::Launching Quicken by referencing the data file in $DestinationPath"
    $ExitCode = 1
    do {
        #$LastExitCode = 0
        if ($bSayit) { [Void]$oSynth.SpeakAsync(("{0}     you are invoking Quicken with {1}" -f $env:USERNAME, $Filename)) }

        cmd /C "$DestinationPath" #launch Quicken using file association and WAIT for it to exit.
        #Start-Process -wait "$DestinationPath" #launch Quicken using file association and WAIT for it to exit.

        $ExitCode = $LastExitCode
        write-host "LastExitCode $ExitCode"
        if ($ExitCode -ne 0) {
            $Sayit = "Oops, Quicken stopped with code $ExitCode Do you want to restart Quicken"
            if ($bSayit){[Void]$oSynth.SpeakAsync($SayIt)}
            write-host -ForegroundColor "Red" $SayIt
            Do { $MyResponse = Read-Host "$SayIt [Y] Yes  [N]  No" }
            until ($MyResponse -like 'y*' -or $MyResponse -like 'n*')
            if ($MyResponse -like "n*") { $ExitCode = 0 }
        }
    } until ($ExitCode -eq 0)

    "Maximize this window and give it the focus"
    # Originally the function was called but it was slow.
    # Now the methods are called inline.
    #Maximize-ThisWindow -Process (get-process -id $pid)  #Will this work for CORE?
    
    $null = $type::ShowWindowAsync($hwnd, 3) #SW_RESTORE 9 Activates and displays the window.
    $null = $type::SetForegroundWindow($hwnd) #puts cursor in windows
<#
    Alternate code to bring this windows back to the foreground.
    sleep -Seconds 2
    [void][reflection.assembly]::loadwithpartialname("system.windows.forms")
    $altkeys = @(0xA4, 0x09)
    [system.windows.forms.sendkeys]::sendwait('%{TAB}')
 #>
    #At this point Quicken has exited. Now decide what to do with the data file we where working with.
    write-warning "INFORMATION::The file in the runtime workspace is $DestinationPath"
    $DoneTime=get-item $DestinationPath | Select-Object Fullname, CreationTime, LastWriteTime, LastAccessTime,Length
    $DoneTime | format-list Fullname, CreationTime, LastWriteTime, LastAccessTime,@{ Name = 'Size in Megabytes';  Expression = {$psitem.length/(1Mb)}}
    [timespan]$ElapsedTime=($DoneTime.LastWriteTime -$BeginTime.LastAccessTime)
    "You worked on this file for:"
    $ElapsedTime|format-list *
    $NewSize=($DoneTime.Length - $BeginTime.Length)/1Mb
    "File increased by {0} Mb" -f $NewSize
    $SayIt = "Do you want to move this file to the repository?"
    if ($bSayit) { [void]$oSynth.SpeakAsync($SayIt) }
    Do { $MyResponse = Read-host "$SayIt [Y] Yes  [N]  No" }
    until ( ($MyResponse -like "y*" ) -or ($MyResponse -like "n*") )

    if ($MyResponse -like "y*") {
        $Sayit = "Moving '$Filename' to the repository "
        if ($bSayIt) { [void]$oSynth.SpeakAsync($SayIt) }
        # The previous run created a copy (SourcePath.old) in the repository.
        # Remove the copy and create a copy of the current file before replacing it with the working copy.
        # Future enhancement: The .old file should not be discarded until the working copy is successfully moved into the repository.
        "Moving the working file to the Repository - Housekeeping"
        if (Test-Path "$SourcePath.old") {get-date;remove-item -verbose -Force "$SourcePath.old"}
        Get-Date;rename-item -verbose -force $SourcePath "$Sourcepath.old"
        Get-Date;move-Item -verbose $DestinationPath $SourceDir -force
        if ($?) {"Moving the working file to the Repository - Completed"}
        write-host  -foregroundColor Yellow "$($Sayit) at $(Get-Date) " # "V2.15.3"
        [console]::beep($ToneGood, 500)
        Write-Warning "INFORMATION:: The updated file in the Repository is $SourcePath"
        get-item $SourcePath | format-list Fullname, CreationTime, LastWriteTime, LastAccessTime,@{ Name = 'Size in Megabytes';  Expression = {$psitem.length/(1Mb)}}
    }
    else { #chose to keep the working file in the repository.
        $SayIt = "Do you want to move $($Filename) to the recycle-bin?"
        if ($bSayit) { [Void]$oSynth.SpeakAsync($SayIt) }
        Do { $MyResponse = Read-host "$($SayIt) [Y] Yes  [N]  No" }
        until ( ($MyResponse -like "y*" ) -or ($MyResponse -like "n*") )
        if ($MyResponse -like "y*") {
            $SayIt = "MOVING $($Filename) to the recycle-bin  "
            write-host  -foregroundColor Yellow "$SayIt at $(Get-Date) " # "V2.15.3"
            if ($bSayIt) { $oSynth.Speak($SayIt) }
            Add-Type -AssemblyName Microsoft.VisualBasic
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($DestinationPath, 'OnlyErrorDialogs', 'SendToRecycleBin')
            if ($?) {Write-Warning "$($DestinationPath) file sent to recycle bin"} else {remove-item $DestinationPath}
            [console]::beep($ToneGood, $ToneDuration)
        }
        else { #keep the working file stays in the runtime workspace.
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
    if ($IsCoreCLR) {get-error}
    $error[0]
    $Sayit = "Something went wrong!"
    write-host -ForegroundColor Red $SayIt
    if ($bSayIt) { $oSynth.Speak($SayIt) }
    for ($i=1;$i -le 3;$i++ ){[console]::beep($ToneBad, $ToneDuration)}

    Read-Host -prompt "This gives you a chance to see what went wrong."
    write-warning "'Catch' block ends"
}
Finally {
    write-warning "'Finally' block starts"
    $SayIt="Completed with {0} errors." -f $error.count
    Write-Warning $SayIt
    If ($bSayIt) {$oSynth.Speak($SayIt)}
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
    if ($error.count -gt 0){Read-Host -prompt "'Enter' to quit"}
    explorer.exe $DestinationDir #spawn file-manager
}

=======
﻿<#
.SYNOPSIS
    Short description of the script
.DESCRIPTION
    Long description of the script
.EXAMPLE
    PS C:\\> Get-WhatTimeIsItNow.ps1
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

param ([Parameter(Mandatory = $true,
        HelpMessage = "Enter the name of the Quicken data file; e.g., Home.qdf : ")]
    [System.IO.FileInfo]$FileName,

    [Parameter(Mandatory=$false)]
    [System.IO.FileInfo]$SourceDir =  (Split-Path -Parent -Path "$PSCommandPath"),
    [Parameter(Mandatory=$false)]
    [System.IO.FileInfo]$DestinationDir = (Join-Path $env:HOMEDRIVE$env:HOMEPATH 'Documents\Quicken'),

    [Parameter(Mandatory = $false)]
    [Switch]
    $Speak,

    [Parameter(Mandatory = $false)]
    [Switch]
    $ShowDebug,

    [Parameter(Mandatory = $false)]
    [Switch]
    $StartStop
)

write-host "the value of Filename is $Filename"
write-host "the value of DestinationDir is $Destinationdir"
write-host "the value of Speak is $Speak"
write-host "the value of ShowDebug is $ShowDebug"
write-host "the value of StartStop is $StartStop"

if ($StartStop) { Read-host "Terminating"; exit } #Just want to see how the function is invoked.
<#
Invoke like
powershell.exe -noprofile -file NameOfThisScript  -Filename "Home.qdf" -Speak
or

#>
if ($ShowDebug) { Set-PSDebug -strict -trace 2 } # I have not tested this
($ThisVersion = "V4.1.3 2020-03-16")
$ErrorActionPreference = "Stop" #failing cmdlets will jump to the 'catch' block
$Error.Clear()
<#
The name of this script is "LoadQuickenDb.ps1"
2017-08-20 - Copyright 2017 FAJ

One day I should put in the standard established for Powershell Headers.
Mod 2017-10-15 - Push *.dat files to the dat subfolder.
Mod 2017-11-19 - When Quicken exits bring this window to the foreground.
Added function 'Maximize-ThisWindow($Process, [Switch]$Maximize)'
Mod 2018-05-24 'Loop on Read-Host
2019-02-19 FAJ
    Changed launch of Powershell using an Alias in profile.ps1 as
      #function fQuickenHome {$command='C:\Users\Super` Computer\Dropbox\Private\Q\LoadQuickenDb.ps1 home.qdf -Speak';start-process powershell -argumentlist $command;remove-variable command}
      function fQuickn ($arg="home") {$command=join-path $env:HOMEPATH -ChildPath \Dropbox\Private\Q\LoadQuickenDb.ps1; `
      start-process powershell -Args "-noprofile -command & {. '$($command)' $arg.qdf -speak }";remove-variable command}
      set-alias -name Quickn -value fQuickn -Option Readonly -passthru | format-list
      or from a shortcut as C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "& 'C:\Users\Super Computer\Dropbox\Private\Q\LoadQuickenDb.ps1'  home.qdf -Speak"
    Added tracing of arguments
2019-02-23 FAJ
    If file already in destination folder show dates
    Added comment lines so they show in log.
2019-02-24 FAJ
    $SourceDir is now based on "$MyInvocation.MyCommand.Path". Assumption is the script and the files reside in the Repository Workspace.
2019-04-09 FAJ V2.15
    Are we running CORE?
    using if ($psversiontable.psedition -ne "CORE") but this may change in the future when Powershell is renamed.
    Perhaps the executable name should be tested.
    Then
        Cannot set $bSayit to $true
        Cannot load [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($DestinationPath, 'OnlyErrorDialogs', 'SendToRecycleBin')

2019-05-31 FAJ V3.0.0
    Added params to this script.
    It should be called like this
    powershell.exe -noprofile -file $FullPathToScriptFile -Filename DataFileLikeHOME.QDF [-Speak] [-DebugMessages]
    *** We assume the DataFile is in the folder (the REPOSITORY) where the script resides.

2019-06-05 FAJ V3.0.1
    Set the proper console display for "read-response" to  [Y] Yes  [N]  No"
    and if reponse was improper added Do-While loop where previously left out.
    Changed some instances of write-host to write-warning.
    Cast to [Void] calls to $oSynth.SpeakAsync($SayIt) ([Void]$oSynth.SpeakAsync($SayIt))
    to eliminate the appearance of "Compeleted" on the console

2019-06-08 FAJ V3.0.5
    Experimenting with allowing responses to be "y" or "yes", etc..
    The alias for quickn is invoking LoadQuickenDb1.ps1.
    Becareful what is commited to github.

2019-06-08 FAJ V3.0.6
    Added StartStop param. When set the function prints the params and exits.

2019-06-15 FAJ V3.0.7 and V3.0.8
    Modified responses to Read-Host.

2019-06-28 FAJ V3.0.9
    $SayIt="Do you want to replace the file in the repository?"

2019-07-09 FAJ V3.0.10
    The reverting the message to somewhat like the original.
    $Sayit="Do you want to move this file to the repository?"
    Prior to moving the file;
    #in the repository,
    make a backup of the file in the repository
    but first remove the prevous one.
        <remove-item home.qdf.old>
        <rename-item home.qdf -> home.qdf.old>

2020-01-03 FAJ V4.0.0
        Improvements in error handling.
        Use of -Verbose and $ErrorActionPreference = "Stop"
        Try,Catch,Finish embelishments for Powershell Preview 7
2020-01-04 FAJ V4.0.1
        Minor changes - eliminating audit information made redundant by -verbose.
2020-01-04 FAJ V4.0.2
        Added Parameter $DestinationDir
2020-01-10 FAJ V4.0.3
        Streamlined the function Maximize-ThisWindow and removed 2nd parameter.
2020-01-18 FAJ V4.1.0.1
        If the file is already in the working directory and you don't want to use it
        rename it (append the date and time to the basename) before copying the file from the repository.
2020-01-20 FAJ V4.1.0.2
        $SoureDir is now an input parameter that defaults to the foler where this command resides; $SourceDir =  (Split-Path -Parent -Path "$PSCommandPath"),
2020-03-11 FAJ V4.1.1
        Load assemblies at the start of the Try block.
        Show final prompt only if errors occurred.
        <#
2020-03-15 FAJ V4.1.2
        Move file to recycle bin works with Powershell 7.
        Replaced ($psversiontable.psedition -ne "CORE") with ($IsCoreClr -ne $true)
2020-03-15 FAJ V4.1.3
        replaced three lines of [console]::beep(n,m) with single line 'For"

This script invokes Quicken and requires 2 arguments on the command line invoking it.
The first argument is the name of a Quicken data file.
The second argument is the a string with indicates if you want to enable text-to-speech prompts; Speak | NoSpeak
Here is an example of the Target property in a SHORTCUT on my Desktop;
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "& C:\Users\Super` Computer\Documents\Dropbox\Private\Q\LoadQuickenDb.ps1 home.qdf -Speak"
Notice
1)the &
2)the escape after the word 'Super' as there is a space in the path.


This script invokes Quicken with a COPY of your data file. I refer to this file as $FileName

I keep my data file(s) in a folder called Dropbox\Private\Q\. I refer to this folder and file as the repository workspace- $SourceDir and $SourcePath
The copy is placed in the run-time workspace. This workspace is on the local machine and is not in a path that uses any cloud services.
Quicken uses $env:homepath/Documents/Quicken as the run-time workspace.
I refer to this folder and file as $DestinationDir and $DestinationPath
If it already is on the desktop you can overwrite it or use the existing file on the desktop.

When Quicken exits you decide if you want to delete the copy or move it back to the repository. Moving to back to the repository OVERWRITES the original file.
If you delete the file it is moved to the RecycleBin.
#>

# Begin
#Before starting the Transcript we need to know where the run-time workspace is located.
Write-Host "**************Beginning Script" -ForegroundColor "Yellow"
Set-StrictMode -Version latest #Before careful. I don't know all the implications of this setting!

#Find the run-time workspace.
#$DestinationDir = Join-Path $env:HOMEDRIVE$env:HOMEPATH "Documents\Quicken" #This is where Quicken likes the run-time file to be.
write-host "Does destination folder exist?"
if (test-path $DestinationDir) {
    #it exists
    write-host "Destination folder $DestinationDir exists"
}
else { #destination folder does not exist
    #it may be better to exit the program then to create this Folder.
    Read-host "the destination folder $DestinationDir does not exist;'Enter' will create it. Otherwise control-C to quit."
    write-host "creating destination folder"
    new-item -verbose -path $DestinationDir -itemtype directory # was it created?
}
$TranscriptName = "Powershell.out"
$TranscriptFullName=Join-path $DestinationDir $TranscriptName
$TranscriptNameOld = $TranscriptName + ".old"
$TranscriptFullNameOld=Join-path $DestinationDir $TranscriptNameOld
if (test-path $TranscriptFullNameOld) { remove-item -Verbose $TranscriptFullNameOld }
if (test-path $TranscriptFullName) { rename-item -verbose -path $TranscriptFullName -newname $TranscriptFullNameOld }
Start-Transcript -path $TranscriptFullName -IncludeInvocationHeader

#Write-Host "**************Beginning Script**************" -ForegroundColor yellow
"Location of Powershell is {0}" -f $PSHome
write-host (get-process -id $pid).processname
get-process -id $pid | format-list -property *
write-host $(Get-Date)
write-host -foregroundColor yellow "Version:$ThisVersion"
"The current directory is {0}" -f (get-location)
"The Process Id is {0}" -f $pid
"MyInvocation follows"
$MyInvocation
"MyInvocation.MyCommand.path follows"
$MyInvocation.MyCommand.path
#Set-PSDebug -Step


$ToneGood = 500
$ToneBad = 100
$ToneDuration = 500

Try {
    $sig = '
        [DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
        [DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hwnd);
        '
        write-host "Load the Type libraries"
        $TimeTemp=get-date
        $type = Add-Type -MemberDefinition $sig -Name WindowAPI -PassThru
        write-host "Load took" (New-TimeSpan -start $timetemp).totalseconds "seconds"
        $process=Get-Process -Id $pid
        $hwnd = $process.MainWindowHandle
<#
    function Maximize-ThisWindow($Process) {
        #https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-showwindow
        $sig = '
        [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
        [DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hwnd);
        '
        #This next line takes a long time to execute
        $type = Add-Type -MemberDefinition $sig -Name WindowAPI -PassThru
        $hwnd = $process.MainWindowHandle
        $null = $type::ShowWindow($hwnd, 9) #SW_RESTORE 9 Activates and displays the window.
        $null = $type::SetForegroundWindow($hwnd) #puts cursor in windows
    }
    #Maximize-ThisWindow -Process (get-process -id $pid)  #Will this work for CORE?
#>
    if ($speak -and $IsCoreClr -ne $True) {
            [bool]$bSayit = $true
        #https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer(v=vs.110).aspx
        add-type -assemblyname system.speech
        $oSynth = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
        $oSynth.rate = 3 # range -10 to 10
        $SayIt = "Quicken"
        $SayIt = "$env:USERNAME     you are invoking Quicken"
        #$oSynth.SpeakAsync($SayIt)
    }
    else { [bool]$bSayit = $false }

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
        $FileIn=get-item $SourcePath | Select-Object Fullname, CreationTime, LastWriteTime, LastAccessTime, Length
        $FileIn | format-list Fullname, CreationTime, LastWriteTime, LastAccessTime,@{ Name = 'Size in Megabytes';  Expression = {$psitem.length/(1Mb)}}
    }

    [System.IO.FileInfo]$DestinationPath = Join-Path $DestinationDir $FileName #fullpath to Quicken data file.
    # Is the file already in the working folder?
    if (test-path $DestinationPath) {
        $Sayit = "The data file is already in the working folder '$($DestinationDir)'. Do you want to use it? "
        if ($bSayit) {[Void]$oSynth.SpeakAsync($Sayit)}
        Write-Warning  $SayIt
        get-item $DestinationPath | format-list Fullname, CreationTime, LastWriteTime, LastAccessTime, @{ Name = 'Size in Megabytes';  Expression = {$psitem.length/(1Mb)}}
        Do {
            $MyResponse = Read-host "$SayIt [Y] Yes  [N]  No"
        } until ($MyResponse -like 'y*' -or $MyResponse -like 'n*')

        if ( $MyResponse.tolower() -like "n*") {
            # Rename existing file (file.ext -> file-2020-01-18T14:20:22.ext) and
            # Use a copy of the file that is in the repository.
            $Sayit = "Renaming the file in the working directory and using a oopy of the file that is in the repository."
            if ($bSayit) { [Void]$oSynth.SpeakAsync($Sayit) }
            Write-Warning  $SayIt
            Rename-Item -Verbose $DestinationPath -NewName "$($DestinationPath.basename)-$(get-date -format "yyyy-MM-ddTHH-mm-ss")$($DestinationPath.extension)"
            Copy-Item -verbose $SourcePath $DestinationDir
        }
        else {
            $Sayit = "Using the file that is already in the working directory."
            if ($bSayit) {[Void]$oSynth.SpeakAsync($Sayit)}
            Write-Warning  $SayIt
        }
    }
    else {
        # The file was not in the working folder.
        # Use a copy of the file that is in the repository.
        Copy-Item -verbose $SourcePath $DestinationDir
    }
    $BeginTime=get-item $DestinationPath | Select-Object Fullname, CreationTime, LastWriteTime, LastAccessTime, Length
    $BeginTime | format-list Fullname, CreationTime, LastWriteTime, LastAccessTime,@{ Name = 'Size in Megabytes';  Expression = {$psitem.length/(1Mb)}}

    Write-Warning  "Information::Launching Quicken by referencing the data file in $DestinationPath"
    $ExitCode = 1
    do {
        #$LastExitCode = 0
        if ($bSayit) { [Void]$oSynth.SpeakAsync(("{0}     you are invoking Quicken with {1}" -f $env:USERNAME, $Filename)) }

        cmd /C "$DestinationPath" #launch Quicken using file association and WAIT for it to exit.
        #Start-Process -wait "$DestinationPath" #launch Quicken using file association and WAIT for it to exit.

        $ExitCode = $LastExitCode
        write-host "LastExitCode $ExitCode"
        if ($ExitCode -ne 0) {
            $Sayit = "Oops, Quicken stopped with code $ExitCode Do you want to restart Quicken"
            if ($bSayit){[Void]$oSynth.SpeakAsync($SayIt)}
            write-host -ForegroundColor "Red" $SayIt
            Do { $MyResponse = Read-Host "$SayIt [Y] Yes  [N]  No" }
            until ($MyResponse -like 'y*' -or $MyResponse -like 'n*')
            if ($MyResponse -like "n*") { $ExitCode = 0 }
        }
    } until ($ExitCode -eq 0)

    "Maximize this window and give it the focus"
    # Originally the function was called but it was slow.
    # Now the methods are called inline.
    #Maximize-ThisWindow -Process (get-process -id $pid)  #Will this work for CORE?
    
    $null = $type::ShowWindowAsync($hwnd, 3) #SW_RESTORE 9 Activates and displays the window.
    $null = $type::SetForegroundWindow($hwnd) #puts cursor in windows
<#
    Alternate code to bring this windows back to the foreground.
    sleep -Seconds 2
    [void][reflection.assembly]::loadwithpartialname("system.windows.forms")
    $altkeys = @(0xA4, 0x09)
    [system.windows.forms.sendkeys]::sendwait('%{TAB}')
 #>
    #At this point Quicken has exited. Now decide what to do with the data file we where working with.
    write-warning "INFORMATION::The file in the runtime workspace is $DestinationPath"
    $DoneTime=get-item $DestinationPath | Select-Object Fullname, CreationTime, LastWriteTime, LastAccessTime,Length
    $DoneTime | format-list Fullname, CreationTime, LastWriteTime, LastAccessTime,@{ Name = 'Size in Megabytes';  Expression = {$psitem.length/(1Mb)}}
    [timespan]$ElapsedTime=($DoneTime.LastWriteTime -$BeginTime.LastAccessTime)
    "You worked on this file for:"
    $ElapsedTime|format-list *
    $NewSize=($DoneTime.Length - $BeginTime.Length)/1Mb
    "File increased by {0} Mb" -f $NewSize
    $SayIt = "Do you want to move this file to the repository?"
    if ($bSayit) { [void]$oSynth.SpeakAsync($SayIt) }
    Do { $MyResponse = Read-host "$SayIt [Y] Yes  [N]  No" }
    until ( ($MyResponse -like "y*" ) -or ($MyResponse -like "n*") )

    if ($MyResponse -like "y*") {
        $Sayit = "Moving '$Filename' to the repository "
        if ($bSayIt) { [void]$oSynth.SpeakAsync($SayIt) }
        # The previous run created a copy (SourcePath.old) in the repository.
        # Remove the copy and create a copy of the current file before replacing it with the working copy.
        # Future enhancement: The .old file should not be discarded until the working copy is successfully moved into the repository.
        "Moving the working file to the Repository - Housekeeping"
        if (Test-Path "$SourcePath.old") {get-date;remove-item -verbose -Force "$SourcePath.old"}
        Get-Date;rename-item -verbose -force $SourcePath "$Sourcepath.old"
        Get-Date;move-Item -verbose $DestinationPath $SourceDir -force
        if ($?) {"Moving the working file to the Repository - Completed"}
        write-host  -foregroundColor Yellow "$($Sayit) at $(Get-Date) " # "V2.15.3"
        [console]::beep($ToneGood, 500)
        Write-Warning "INFORMATION:: The updated file in the Repository is $SourcePath"
        get-item $SourcePath | format-list Fullname, CreationTime, LastWriteTime, LastAccessTime,@{ Name = 'Size in Megabytes';  Expression = {$psitem.length/(1Mb)}}
    }
    else { #chose to keep the working file in the repository.
        $SayIt = "Do you want to move $($Filename) to the recycle-bin?"
        if ($bSayit) { [Void]$oSynth.SpeakAsync($SayIt) }
        Do { $MyResponse = Read-host "$($SayIt) [Y] Yes  [N]  No" }
        until ( ($MyResponse -like "y*" ) -or ($MyResponse -like "n*") )
        if ($MyResponse -like "y*") {
            $SayIt = "MOVING $($Filename) to the recycle-bin  "
            write-host  -foregroundColor Yellow "$SayIt at $(Get-Date) " # "V2.15.3"
            if ($bSayIt) { $oSynth.Speak($SayIt) }
            Add-Type -AssemblyName Microsoft.VisualBasic
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($DestinationPath, 'OnlyErrorDialogs', 'SendToRecycleBin')
            if ($?) {Write-Warning "$($DestinationPath) file sent to recycle bin"} else {remove-item $DestinationPath}
            [console]::beep($ToneGood, $ToneDuration)
        }
        else { #keep the working file stays in the runtime workspace.
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
    if ($IsCoreCLR) {get-error}
    $error[0]
    $Sayit = "Something went wrong!"
    write-host -ForegroundColor Red $SayIt
    if ($bSayIt) { $oSynth.Speak($SayIt) }
    for ($i=1;$i -le 3;$i++ ){[console]::beep($ToneBad, $ToneDuration)}

    Read-Host -prompt "This gives you a chance to see what went wrong."
    write-warning "'Catch' block ends"
}
Finally {
    write-warning "'Finally' block starts"
    $SayIt="Completed with {0} errors." -f $error.count
    Write-Warning $SayIt
    If ($bSayIt) {$oSynth.Speak($SayIt)}
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
    if ($error.count -gt 0){Read-Host -prompt "'Enter' to quit"}
    explorer.exe $DestinationDir #spawn file-manager
}

>>>>>>> 83675e6e927b6920cf09f5e571fdb4d095b8cbab
