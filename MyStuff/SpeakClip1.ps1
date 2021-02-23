#Start-Transcript -path "c:/Users/Super Computer/Documents/SpeakClipOut.txt"
#get-childitem
$args.Count
$args
add-type -assemblyname system.speech
#https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer(v=vs.110).aspx
#https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer_methods(v=vs.110).aspx
$oSynth = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$oSynth.rate = 0 # range -10 to 10
$oSynth.Speak("This voice is set to " + $oSynth.voice.name) 
<#
The Voice names shown in Settings-Speech Text-to-speech are not the 
same as those returned from .voice.name And only two of them are enabled.
See details https://msdn.microsoft.com/en-us/library/system.speech.synthesis.speechsynthesizer.selectvoice(v=vs.110).aspx
#>
$oSynth.SelectVoice("Microsoft David Desktop")

# $SayThis="hello world"
$SayThis = Get-Clipboard
if ($null -eq $SayThis) {$SayThis = "There is nothing on the clipboard"}
$oSynth.Speak($SayThis)
#$oSynth.Speak("fred-arthur jacobowitz")
#$oSynth.Speak("goodbye $env:username")
foreach ($Voice in $oSynth.GetInstalledVoices()) { $Voice.voiceinfo;$voice.Enabled}
#$oSynth = $null
#$oSynth.Dispose() 
#Stop-Transcript

$VoiceIWant=($osynth.getinstalledvoices())[1].VoiceInfo.name

 $oSynth.SelectVoice($VoiceIwant)
 $oSynth.Speak("This voice is set to " + $oSynth.voice.name) 

 $oSynth.speak("I think I did it")

 