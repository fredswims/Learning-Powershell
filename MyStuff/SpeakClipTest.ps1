add-type -assemblyname system.speech
#https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer(v=vs.110).aspx
#https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer_methods(v=vs.110).aspx
$synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$synthesizer.rate = 2 # range -10 to 10
#$SayThis="hello world"
$SayThis = Get-Clipboard
if ($SayThis -eq $null){$SayThis="There is nothing on the clipboard"}
$synthesizer.Speak($SayThis)
#$synthesizer.Speak("fred-arthur jacobowitz")
#$synthesizer.Speak("goodbye $env:username")
#foreach ($ellen in $synthesizer.GetInstalledVoices()){ $ellen.voiceinfo}
#$synthesizer = $null
#$synthesizez.Dispose()
    

