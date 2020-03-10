Param($thisrate = 2)
Write-Warning "In function $($MyInvocation.MyCommand.Name): "
add-type -assemblyname system.speech
#https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer(v=vs.110).aspx
#https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer_methods(v=vs.110).aspx
$synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
#foreach ($voice in $synthesizer.GetInstalledVoices()){ $voice.voiceinfo}
#$synthesizer.rate = 2 # range -10 to 10
$synthesizer.rate = $thisrate
$SayThis = Get-Clipboard
if ($null -eq $SayThis){$SayThis="There is nothing on the clipboard"}
[void]$synthesizer.Speak($SayThis) #cannot use .speakasync if script called from powershell.exe
#synthesizer = $null
#$synthesizez.Dispose()
Write-Warning "End function $($MyInvocation.MyCommand.Name): "
    

