$Paths = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'

$software = Get-ItemProperty -Path $paths -ErrorAction Ignore |
  Select-Object -Property DisplayName, pspath, DisplayVersion, UninstallString

$software | Out-GridView


set-location $ENV:windir
$files = Get-ChildItem -Recurse
#$files.LastWriteTime
$files.Where( {$PSItem.extension -in (".txt", ".ps1", ".log", ".tmp") -and $psitem.length -eq 0 })|Remove-Item -WhatIf

$events = Get-WinEvent SYSTEM -MaxEvents 200
($events).where( {$psitem.id -eq 1001})|Select-Object -first 1 -property timecreated, id, message|Format-List

for ($i = 0; $i -lt 10; $i++) {
  New-TimeSpan -start (get-date).adddays(-1) -end (get-date) |Select-Object @{name="fdfdf";expression={$_.ticks/1000000000}}

}

(get-process *code).Path

$FRED=Get-ChildItem -recurse *.* |where-object {$_.lastwritetime.date -ge (get-date).date.addmonths(-3)}
set-loca8tion $env:HOMEPATH\downloads

$FRED=Get-ChildItem -recurse *.* |where-object {$_.lastwritetime.date -eq (get-date -date 1/17/2019).date.addmonths(0)}

$fred|sort-object -Property lastwritetime |select-object lastwritetime, name
write-host "fred"
$psEditor.Works# All your script are belong to uspace.OpenFile($profile)


# All your script are belong to us


# Insert new text replacing the user's current selection
$context = $psEditor.GetEditorContext()
$context.CurrentFile.InsertText("# All your script are belong to us", $context.SelectedRange)

#https://resources.oreilly.com/examples/0636920024132/blob/master/Select-FilteredObject.ps1
Get-Process | Select-FilteredObject | Stop-Process -WhatIf

