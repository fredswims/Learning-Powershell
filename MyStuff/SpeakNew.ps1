# One of my favorite custom PS functions calls the Windows Speech API. I tack that to the end of a long running script (or after the Wait-Job cmdlet) so that I don't have to monitor if the script is still running.
Add-Type -AssemblyName System.Speech;
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer;
function Start-VISpeech {
    Param(
        [Parameter(Mandatory=$true)][String] $Phrase
    )
    $speak.Speak($Phrase);
}
Start-VISpeech -Phrase "Script tasks have started";
start-sleep -Seconds 5
Start-VISpeech -Phrase "Script tasks have completed";

$parameters = @{
    ScriptBlock = { Param ($Phrase)
        Add-Type -AssemblyName System.Speech;
        $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer;
        $speak.Speak($Phrase)
         }
    ArgumentList= "Hello there"
}
start-job @parameters

