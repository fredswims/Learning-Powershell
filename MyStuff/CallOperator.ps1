/some things you can do with the call operator
$command = "Get-ChildItem"
& $command

$scriptBlock = { Get-Process | Where-Object { $_.Name -eq "notepad" } }
  & "notepad.exe"
  Start-Sleep -Seconds 2
  & $scriptBlock

  start-process powershell -Args " -noprofile -command & {. '$runThis' $arg -speak }"

#   https://ss64.com/ps/call.html
# 
# fred