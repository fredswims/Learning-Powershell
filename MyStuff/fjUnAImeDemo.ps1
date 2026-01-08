# FAJ 2026-01-08
Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
set-location $env:MyStuffPath
"dot source and call fjUnAIme"
. .\mystuff\fjUnAIMe.ps1
"Get Current Memory Usage"
fjUnAiMe
"Start it up"
fjUnAiMe -start
"See how much memory is used."
fjUnAiMe
"Start 'click to do'"
fjstartthisapp -name 'click to do' ; start-sleep -seconds 20
"See how much memory is consumed"
fjUnAiMe
"shut it down"
fjUnAiMe -stop
Write-Verbose "[END Leaving: $($MyInvocation.Mycommand)"

