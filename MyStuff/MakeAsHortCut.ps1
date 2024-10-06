<#
Managing Shortcut Files (Part 1)
https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/managing-shortcut-files-part-1
Managing Shortcut Files (Part 2)
https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/managing-shortcut-files-part-2
Managing Shortcut Files (Part 3)
https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/managing-shortcut-files-part-3?fbclid=IwAR1mpyn25I49DqfyENQD4LC41j73uihEUlptlainsEoxYTbq5rSXXATcyps
#>

$path = [Environment]::GetFolderPath('Desktop') | Join-Path -ChildPath 'myLink.lnk'
$scut = (New-Object -ComObject WScript.Shell).CreateShortcut($path)
$scut.TargetPath = 'powershell.exe'
$scut.IconLocation = 'powershell.exe,0'
$scut.Save()


# launch LNK file as Administrator
# THIS PATH MUST EXIST (use previous script to create the LNK file or create one manually)
$path = [Environment]::GetFolderPath('Desktop') | Join-Path -ChildPath 'myLink.lnk'
# read LNK file as bytes...
$bytes = [System.IO.File]::ReadAllBytes($path)
# flip a bit in byte 21 (0x15)
$bytes[0x15] = $bytes[0x15] -bor 0x20 
# update the bytes
[System.IO.File]::WriteAllBytes($path, $bytes) 