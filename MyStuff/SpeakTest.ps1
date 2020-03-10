Write-Warning "In function $($MyInvocation.MyCommand.Name): "
$arg=Get-Clipboard
"this is a test"|Set-Clipboard 
$runthis="C:\Users\freds_000\MyStuff\SpeakClipBoard.ps1"
#start-process powershell -Args "-noprofile  -command & {. '$runThis' 2  }"
powershell.exe -noprofile -nologo -file "C:\Users\freds_000\MyStuff\SpeakClipBoard.ps1"
Write-Warning "End function $($MyInvocation.MyCommand.Name): "
