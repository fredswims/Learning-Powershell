Param($thisrate = 2)
add-type -assemblyname system.speech
$synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
$synthesizer.rate = $thisrate
$SayThis = Get-Clipboard
if ($null -eq $SayThis){$SayThis="There is nothing on the clipboard"}
$synthesizer.Speak($SayThis)
$synthesizer = $null
#$synthesizez.Dispose()
   
$SayThis = Get-Clipboard
$Say = @"
write-host $saythis;
Add-Type -AssemblyName System.speech;
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer;                          
$speak.Speak($sayit)  
"@
start-process powershell -Args "-noprofile -noexit -command {$say}" 

$name = "Graham"
$HereString = @"
My name is $name.
I live in the 'UK'.
The current date is: `n`t$(Get-Date)
"@
$HereString
$arg=Get-Clipboard
$arg="this is a test"
$runthis="C:\Users\freds_000\MyStuff\SpeakClipBoard1.ps1"
start-process powershell -Args "-noprofile -noexit -command & {. '$runThis' $arg  }"