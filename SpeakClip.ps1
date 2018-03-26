#Start-Transcript -path "c:/Users/Super Computer/Documents/SpeakClipOut.txt"
#get-childitem
$args.Count
$args
add-type -assemblyname system.speech
#https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer(v=vs.110).aspx
#https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer_methods(v=vs.110).aspx
$oSynth = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$oSynth.rate = 0 # range -10 to 10

# $SayThis="hello world"
$SayThis = Get-Clipboard
if ($SayThis -eq $null) {$SayThis = "There is nothing on the clipboard"}
$oSynth.Speak($SayThis)
#$oSynth.Speak("fred-arthur jacobowitz")
#$oSynth.Speak("goodbye $env:username")
#foreach ($Voice in $oSynth.GetInstalledVoices()) { $Voice.voiceinfo;$voice.Enabled}
#$oSynth = $null
$oSynth.Dispose() 
#Stop-Transcript
