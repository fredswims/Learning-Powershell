# [cmdletbinding()]
    param (
        [Parameter(Mandatory=$false,
        ValueFromPipeline=$true)]
        [String]$SayThis="",

        [ValidateSet(-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9,10)]
        [ValidateRange(-10,10)]
        [Int32]$ThisRate = 2
    )
#2021-02-23 FAJ 
# Param($thisrate = 2)
Write-Warning "In function $($MyInvocation.MyCommand.Name): "
"Path is {0}" -f (get-process -pid $pid).Path
"Version is "
($PSVersionTable)
"SayThis >{0}<" -f $SayThis

if ($SayThis -eq "") { $SayThis = Get-Clipboard } else {
    if (Test-path $SayThis -ErrorAction SilentlyContinue) { $SayThis = Get-Content $SayThis }
}
# "SayThis >{0}<" -f $SayThis

add-type -assemblyname system.speech
#https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer(v=vs.110).aspx
#https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer_methods(v=vs.110).aspx
$synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
#foreach ($voice in $synthesizer.GetInstalledVoices()){ $voice.voiceinfo}
#$synthesizer.rate = 2 # range -10 to 10
$synthesizer.rate = $thisrate

# if ($null -eq $SayThis){$SayThis="There is nothing on the clipboard"}
[void]$synthesizer.Speak($SayThis) #cannot use .speakasync if script called from powershell.exe
#synthesizer = $null
#$synthesizez.Dispose()

Write-Warning "End function $($MyInvocation.MyCommand.Name): "
    

