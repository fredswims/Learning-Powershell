<#2017-08-20 - Copyright 2017 FAJ
I just added this to GIT
I have not a clue what i am doing.
another change
ok i got it.
One day I should put in the standard established for Powershell Headers.
Mod 2017-10-15 - Push *.dat files to the dat subfolder.
Mod 2017-11-19 - When Quicken exits bring this window to the foreground.
Added function 'Show-Process($Process, [Switch]$Maximize)'

The name of this script is "LoadQuickenDb.ps1"

This script invokes Quicken and requires 2 arguments on the command line invoking it.
The first argument is the name of a Quicken data file.
The second argument is the a string with indicates if you want to enable text-to-speech prompts; Speak | NoSpeak
Here is an example of the Target property in a SHORTCUT on my Desktop;
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "& C:\Users\Super` Computer\Documents\Dropbox\Private\Q\LoadQuickenDb.ps1 home.qdf -Speak"
Notice
1)the &
2)the escape after the word 'Super' as there is a space in the path.


This script invokes Quicken with a COPY of your data file. I refer to this file as $FileName

I keep my data file(s) in a folder called Dropbox\Private\Q\. I refer to this folder and file as the repository - $SourceDir and $SourcePath
The copy is placed on the DESKTOP. I refer to this folder and file as $DestinationDir and $DestinationPath
If it already is on the desktop you can overwrite it or use the existing file on the desktop.

When Quicken exits you decide if you want to delete the copy or move it back to the repository. Moving to back to the repository OVERWRITES the original file.
If you delete the file it is moved to the RecycleBin.
#>

# Begin
Set-StrictMode -Version latest #Before careful. I don't know all the implications of this setting!
#The data file is copied to the User's Quicken Data Directory.
$DestinationDir = Join-Path $env:HOMEDRIVE$env:HOMEPATH "Documents\Quicken"
write-host "Does destination folder exist?"
if (test-path $DestinationDir) {#it exists
    write-host "destination folder $DestinationDir exists"
}
else {#destination folder does not exist
    #it may be better to exit the program then to create this Folder.
    write-host "the destination folder does not exist"
    write-host "creating destination folder"
    new-item -path $DestinationDir -itemtype directory # was it created?
}
$TranscriptName="Powershell.out"
$TranscriptNameOld=$TranscriptName + ".old"

if (test-path (Join-path $DestinationDir $TranscriptNameold)) {remove-item (Join-path $DestinationDir $TranscriptNameold)}
if (test-path (Join-path $DestinationDir $TranscriptName)) {rename-item -path (Join-path $DestinationDir $TranscriptName) -newname (Join-path $DestinationDir $TranscriptNameold)}
Start-Transcript -path (join-path $DestinationDir $TranscriptName) -IncludeInvocationHeader #-OutputDirectory $DestinationDir
Get-Date
# *****
Write-Host "**************Beginning Script" -ForegroundColor "Yellow"
"The working directory is $(get-location)"
"The Process Id is $pid"
$MyInvocation
$MyInvocation.MyCommand.path
#Set-PSDebug -Step

[bool]$TestMode=$false
#if ($MyInvocation.CommandOrigin -eq "Runspace") {$TestMode = $false}
#if ($MyInvocation.CommandOrigin -eq "Internal") {$TestMode = $true} #if debugging in VSCode - can't use this because you can pass parameters in the debugger.

[bool]$bSayit = $True #Only effective if $TestMode=$True

$ToneGood = 500
$ToneBad = 100
$ToneDuration = 500

Try {
    add-type -assemblyname system.speech
    #https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer(v=vs.110).aspx
    $oSynth = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
    $oSynth.rate = 3 # range -10 to 10
    $SayIt = "Quicken"
    $SayIt = "$env:USERNAME     you are invoking Quicken"
    #$oSynth.SpeakAsync($SayIt)

    #Is Quicken running?
    #$ProcessActive=get-process "qw"-ErrorAction SilentlyContinue
    #if ($ProcessActive.ProcessName -eq "qw" ){write-host -ForegroundColor Red "Quicken is running";read-host "enter anything to exit";exit}
    #ANOTHER WAY TO SAY IT IN ONE LINE
    if ((get-process "qw"-ErrorAction SilentlyContinue) -ne $null) {write-host -ForegroundColor Red "Quicken is running"; read-host "press RETURN to exit"; exit}

    If (!($TestMode)) {
        if ($args.count -ne 2) {read-host "You must supply 2 arguments; data file name and '-Speak' | '-Silent'"; exit}
        #[string]$FileName = $args[0] #cast the arg into a string!!!
        [System.IO.FileInfo]$FileName = $args[0]
        if ($args[1] -eq "-Speak") {[bool]$bSayit = $true} else {[bool]$bSayit = $false}
        #Set-PSDebug -Step
        #$SayIt = "Data file is $($Filename.split(".")[0]) "
        $SayIt = " $($Filename.BaseName))"
        write-host -ForegroundColor yellow $SayIt
        if ($bSayIt) {$oSynth.SpeakAsync($SayIt)}
    }
    else {
        # Testing - supply a name.
        [System.IO.FileInfo]$FileName = "home.qdf"
        $SayIt = "Running in Test Mode with $Filename"
        if ($bSayIt) {$oSynth.SpeakAsync($SayIt)}
        Write-Host $SayIt
    }

    #Assumption that the Source Directory / Repository is located on Dropbox.
    #Where is Dropbox located on this machine?
    #Assumption is one of these two places
    #First Place
    $SourceDir = join-path $env:homedrive$env:homepath  "Dropbox\Private\Q"
    If (test-path $SourceDir) {
        #found it
    }
    else {#Assume it is here
        $SourceDir = join-path $env:homedrive$env:homepath  "Documents\Dropbox\Private\Q"
    }
    #Now test the SourceDir exists. If it doesn't then exit.
    if (!(Test-Path $SourceDir)) {read-host "The specified path $SourceDir is incorrect"; exit}

    #Does the Quicken data file exist?
    $SourcePath = Join-Path $SourceDir $FileName
    if (!(Test-Path $SourcePath)) {read-host "The specified path $SourcePath does not exist."; exit}


    $DestinationPath = Join-Path $DestinationDir $FileName #full path to Quicken data file.
    if (test-path $DestinationPath) {
        $TempFolderName = Split-path $DestinationDir -leaf
        $Sayit = "The data file is already in the $tempFolderName folder. Overwrite It? "
        $oSynth.SpeakAsync($Sayit)
        get-item $DestinationPath | format-list CreationTime, LastAccessTime, Lastwritetime
        $MyResponse = read-host "$Filename exists in folder $DestinationDir - Overwrite? [y(es)/n(o)]"
        if ( $MyResponse.tolower() -eq "y") {
            write-host -ForegroundColor Yellow "Overwriting as requested"
            Copy-Item $SourcePath $DestinationDir
        }
        else {write-host -ForegroundColor Yellow "Using existing file"}
    }
    else {
        write-host -ForegroundColor Yellow "copying $SourcePath to $DestinationDir ."
        Copy-Item $SourcePath $DestinationDir
    }

    "Launch Quicken by referencing the data file on the desktop"
    $ExitCode = 1
    do {
        #$LastExitCode = 0
        if ($bSayit) {$oSynth.SpeakAsync("$env:USERNAME     you are invoking Quicken with $Filename")}
        cmd /C "$DestinationPath" #launch Quicken using file association and WAIT for it to exit.
        #Start-Process -wait "$DestinationPath" #launch Quicken using file association and WAIT for it to exit.

        $ExitCode = $LastExitCode
        write-host "LastExitCode $ExitCode"
        if ($ExitCode -ne 0) {
            $Sayit = "Oops, Quicken stopped with code $ExitCode "
            $oSynth.SpeakAsync($SayIt)
            write-host -ForegroundColor "Red" $SayIt
            $MyResponse = Read-Host "Do you want to restart Quicken? 'Y[es]/N[o]'"
            if ($MyResponse -eq "n") {
                $ExitCode = 0
            }

        }
    } until ($ExitCode -eq 0)

    #Bring this windows back to the foreground.
    function Show-Process($Process, [Switch]$Maximize) {
        $sig = '
        [DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
        [DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hwnd);
        '

        if ($Maximize) { $Mode = 3 } else { $Mode = 4 }
        $type = Add-Type -MemberDefinition $sig -Name WindowAPI -PassThru
        $hwnd = $process.MainWindowHandle
        $null = $type::ShowWindowAsync($hwnd, $Mode)
        $null = $type::SetForegroundWindow($hwnd)
    }
    #Set-PSDebug -Step
    #start-sleep -Seconds 1
    Show-Process -Process (get-process -id $pid) #-Maximize

    #At this point Quicken has exited. Now decide what to do with the data file we where working with.
    if ($bSayit) {$oSynth.SpeakAsync("Do you want to move $($Filename.basename) to the repository?")}
    $MyResponse = read-host "Move $Filename to reposity [y(es)/n(o)]"
    if ( $MyResponse.tolower() -eq "y") {
        $Sayit = "Moving '$Filename' to the repository "
        if ($bSayIt) {$oSynth.SpeakAsync($SayIt)}
        write-host  -foregroundColor Yellow $Sayit
        move-Item $DestinationPath $SourceDir -force
        [console]::beep($ToneGood, 500)
    }
    else {
        if ($bSayit) {$oSynth.SpeakAsync("Do you want to move $($Filename.basename) to the recycle-bin?")}
        $MyResponse = read-host "Move $($Filename.basename) to the recycle-bin? [y(es)/n(o)]"
        if ( $MyResponse.tolower() -eq "y") {
            $SayIt = "MOVING $($Filename.basename) to the recycle-bin  "
            write-host  -foregroundColor Yellow $SayIt
            if ($bSayIt) {$oSynth.Speak($SayIt)}
            Add-Type -AssemblyName Microsoft.VisualBasic
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($DestinationPath, 'OnlyErrorDialogs', 'SendToRecycleBin')
            [console]::beep($ToneGood, $ToneDuration)
        }
        else {
            $SayIt = "Leaving the working file"
            if ($bSayIt) {$oSynth.Speak($SayIt)}
            #Read-Host "$SayIt"
            [console]::beep($ToneBad, $ToneDuration)
        }
    }
    #Push *.dat files to subdirectory


    $DatFolder=join-path $DestinationDir "Dat"
    if (!(test-path $DatFolder)) {New-Item -ItemType "directory" -path $DatFolder}
    $SayIt = "moving D A T files to subdirectory"
    if ($bSayIt) {$oSynth.Speak($SayIt)}
    write-host $SayIt
    copy-Item -path (join-path $DestinationDir ($filename.basename + "*.dat")) -destination $DatFolder
    remove-Item -path (join-path $DestinationDir ($filename.basename + "*.dat"))

    explorer.exe $DestinationDir #spawn file-manager
}  #end try
catch {
    $Sayit = "Something went wrong!"
    write-host -ForegroundColor Red $SayIt
    if ($bSayIt) {$oSynth.Speak($SayIt)}
    [console]::beep($ToneBad, $ToneDuration)
    [console]::beep($ToneBad, $ToneDuration)
    [console]::beep($ToneBad, $ToneDuration)
}
Finally {
    $Sayit = "That's all folks"
    write-host -ForegroundColor yellow $SayIt
    if ($bSayIt) {if ($bSayIt) {$oSynth.Speak($SayIt)}}
    #$oSynth = $null
    $oSynth.Dispose()
    Stop-Transcript
}

