/some things you can do with the call operator
$command = "Get-ChildItem"
& $command

  & "notepad.exe"
  $scriptBlock = { Get-Process | Where-Object { $_.Name -eq "notepad" } }
  & $scriptBlock

  start-process powershell -Args " -noprofile -command & {. '$runThis' $arg -speak }"

#   https://ss64.com/ps/call.html
# 