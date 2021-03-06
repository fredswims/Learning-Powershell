function Start-Fun {
  Add-Type -AssemblyName System.Speech
  $synthesizer1 = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
  $synthesizer1.Speak("Creating event for Session Switch")
  $null = Register-ObjectEvent -InputObject ([Microsoft.Win32.SystemEvents]) -EventName "SessionSwitch" -Action {
    Add-Type -AssemblyName System.Speech 
    $synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
       switch($event.SourceEventArgs.Reason) {
    'SessionLock'    { $synthesizer.Speak("See you later $env:username!") }
    'SessionUnlock'  { $synthesizer.Speak("Hey, welcome back $env:username!") }
    }
  }
}
function End-Fun {
    $events = Get-EventSubscriber | Where-Object { $_.SourceObject -eq [Microsoft.Win32.SystemEvents] }
    $jobs = $events | Select-Object -ExpandProperty Action
    $events | Unregister-Event
    $jobs | Remove-Job
}

start-fun
end-fun
