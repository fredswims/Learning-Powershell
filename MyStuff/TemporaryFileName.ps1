

start-transcript

$tmp=new-temporaryfile
$tmp.FullName
Get-ChildItem | out-file  $tmp.FullName
notepad $tmp.FullName
Get-Content $tmp.FullName
Get-DiskUsage | out-file -FilePath $tmp.FullName
Get-ChildItem | out-file -FilePath $tmp.fullName -Append
write-host "fred" | out-file $tmp.fullname ; get-content -Path $tmp.FullName
Remove-Item $tmp.FullName
New-Item $tmp.FullName
get-item $tmp.FullName

Stop-Transcript

