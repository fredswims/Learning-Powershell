# [cmdletbinding()]
param (
    [Parameter(Mandatory = $false,
        ValueFromPipeline = $true)]
    # Can be a string to speak, or file to read, or if empty than read the clipboard.
    [String]$SayThis = "",

    [ValidateSet(-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)]
    [ValidateRange(-10, 10)]
    [Int32]$ThisRate = 2,

    [Parameter(Mandatory=$false)]
    [switch]$AsJob = $false
)
#2021-02-23 FAJ.
#2021-03-23 FAJ added SAPI.SPVoice for PWSH 
#2021-10-09 FAJ Core now supports Add-Type -AssemblyName System.Speech
# https://www.pdq.com/blog/powershell-text-to-speech-examples/
# Param($thisrate = 2)
Write-Warning "In script $($MyInvocation.MyCommand.Name): "
write-warning "Current Location is $(get-location)"
"Powershell is {0}" -f (get-process -pid $pid).Path
"Version is "
($PSVersionTable)
"** Argument SayThis contains [{0}]" -f $SayThis
"** Argument ThisRate contains [{0}]" -f $ThisRate

if ([System.String]::IsNullOrEmpty($SayThis)) { $SayThis = Get-Clipboard } 
else {
    if (Test-path $SayThis ) { $SayThis = Get-Content $SayThis }
}
# Do we run this as a job?
if ($AsJob) {
    Write-Warning "Using AssemblyName System.Speech in a Job"
    $parameters = @{
        ScriptBlock  = { Param ($Rate, $Phrase)
            try {
                Add-Type -AssemblyName System.Speech;
                $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer;
                $speak.Rate = $Rate
                $speak.Speak("Running as a Job")
                $speak.Speak($Phrase)
                # $speak.SpeakAsync($Phrase)
            }
            Finally {
                $speak.Dispose()
                $speak = $null
            }
        }
        ArgumentList = $ThisRate, $SayThis
    }
    # If starting as a job there is no way to stop it.
    start-job @parameters
}
else {
    # "SayThis >{0}<" -f $SayThis
    <# assembly system.speech is back in CORE
    if ($IsCoreClr ) { 
        write-host "Running Pwsh Core using SAPI.SPVoice"
        ${PromptTTS} = New-Object -ComObject SAPI.SPVoice
        $promptTTs.rate = $ThisRate 
        $promptTTs.speak($Saythis) 

    }
    else {
    #>
    
    
    "Running Powershell using system.speech"
    add-type -assemblyname system.speech
    #https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer(v=vs.110).aspx
    #https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer_methods(v=vs.110).aspx
    $synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
    #foreach ($voice in $synthesizer.GetInstalledVoices()){ $voice.voiceinfo}
    #$synthesizer.rate = 2 # range -10 to 10
    $synthesizer.rate = $thisrate

    # if ($null -eq $SayThis){$SayThis="There is nothing on the clipboard"}
    # [void]$synthesizer.Speak("Assemblyname system.speech") #cannot use .speakasync if script called from powershell.exe
    [void]$synthesizer.Speak($SayThis) #cannot use .speakasync if script called from powershell.exe
    $synthesizer.Dispose()
    $synthesizer = $null
    # }
}
Write-Warning "End function $($MyInvocation.MyCommand.Name):"
