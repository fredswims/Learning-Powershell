( [System.Diagnostics.Process]::GetCurrentProcess() ).PriorityClass = "AboveNormal"

Add-Type -AssemblyName System.Speech
  $synthesizer1 = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
  if ($env:USERNAME -eq "Mara"){
  	$synthesizer1.Speak("No soup for $env:username!")
	exit}
  #$synthesizer1.Speak("Creating event for Session Switch")
  $voice=$synthesizer1.GetInstalledVoices()	
  #$voice
  #Anna is the only one installed
  #$synthesizer1.selectVoiceByHints('Neutral')
  #$synthesizer1.SelectVoice("Microsoft Mike" )
  if ($env:USERNAME -eq "Super Computer"){$synthesizer1.Speak("Hi Fred, you came back!")} 
	else { $synthesizer1.Speak("We are glad you are back $env:username!") }
  $null = Register-ObjectEvent -InputObject ([Microsoft.Win32.SystemEvents]) -EventName "SessionSwitch" -Action {
    Add-Type -AssemblyName System.Speech 
    $synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
       switch($event.SourceEventArgs.Reason) {
	'SessionLock' {if ($env:USERNAME -eq "Super Computer"){$synthesizer.Speak("See you later Fred!")} 
	else { $synthesizer.Speak("See you later $env:username!") } }
	#'SessionLock'    { $synthesizer.Speak("See you later $env:username!") }
	'SessionUnlock' {if ($env:USERNAME -eq "Super Computer"){$synthesizer.Speak("Hey, welcome back Fred!")} 
	else { $synthesizer.Speak("Hey, welcome back $env:username!") } }
    #'SessionUnlock'  { $synthesizer.Speak("Hey, welcome back $env:username!") }
    }
  }

$voice.Name
