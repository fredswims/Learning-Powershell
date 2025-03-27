[cmdletbinding()] #Can use -Verbose, -Debug, -ErrorAction, -ErrorVariable, -WarningAction, -WarningVariable, -OutVariable, -OutBuffer
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-clipboard?view=powershell-7.2
param (
    [Parameter(Mandatory = $false,
        ValueFromPipeline = $true)]
    # Can be a string to speak or filepath to read, or if EmptyorNull read the clipboard.
    [String]$SayThis = "",

    # [ValidateSet(-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)]
    [ValidateRange(-10, 10)]
    [Int32]$ThisRate = 2,

    [ValidateSet('Zira','David')]    
    [string]$voice="David",

    [Parameter(Mandatory=$false)]
    [switch]$AsJob = $false
)
#2025-03-27 FAJ - Added line to show parameter $AsJob is set to $true or $false. 
#2025-03-14 FAJ.
#2021-02-23 FAJ.
# https://www.pdq.com/blog/powershell-text-to-speech-examples/
Write-Warning "In script $($MyInvocation.MyCommand.Name): "
write-warning "Current Location is $(get-location)"
"Powershell is {0}" -f (get-process -pid $pid).Path

#Set $Voice to Proper Case.
$textInfo = [System.Globalization.CultureInfo]::CurrentCulture.TextInfo
$voice = $textInfo.ToTitleCase($voice.ToLower())
$pcVoice="Microsoft {0} Desktop" -f $Voice

'** Parameter $SayThis contains [{0}]' -f $SayThis
'** Parameter $ThisRate contains [{0}]' -f $ThisRate
'** Parameter $pcVoice contains [{0}]' -f $pcVoice
'** Parameter $AsJob contains [{0}]' -f $AsJob

# Where is the string to speak? Passed as a parameter or on the clipboard or a file?
if ([System.String]::IsNullOrEmpty($SayThis)) { $SayThis = Get-Clipboard } 
else {
    if (Test-path $SayThis ) { $SayThis = Get-Content $SayThis }
}
# Do we run this as a job?
if ($AsJob.IsPresent) {
    Write-Warning "Using AssemblyName System.Speech in a Job"
    $parameters = @{
        ScriptBlock  = { Param ($Rate, $SayIt, $Voice )
            try {
                Add-Type -AssemblyName System.Speech;
                $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer;
                $speak.Rate = $Rate
                [void]$speak.SelectVoice($Voice) # like "Microsoft Zira Desktop"  
                $speak.Speak("Running as a Job")
                $speak.Speak($SayIt)
                # $speak.SpeakAsync($SayThis)
            }
            Finally {
                $speak.Dispose()
                $speak = $null
            }
        }
        ArgumentList = $ThisRate, $SayThis, $pcVoice #the order of the variables use in the scriptblock param statement.
    } #end of parameters (hash table?).
    start-job @parameters
}
else {
    "Run Powershell using system.speech assembly"
    add-type -assemblyname system.speech
    #https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer(v=vs.110).aspx
    #https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer_methods(v=vs.110).aspx
    $synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
    
    #foreach ($voice in $synthesizer.GetInstalledVoices()){ $voice.voiceinfo}
    $synthesizer.SelectVoice($pcVoice) # "Microsoft Zira Desktop"  
    $synthesizer.rate = $thisrate
    [void]$synthesizer.Speak($SayThis) #cannot use .speakasync if script called from powershell.exe
    $synthesizer.Dispose()
    $synthesizer = $null
    # }
}
Write-Warning "End function $($MyInvocation.MyCommand.Name):"
write-verbose "the verbose end"