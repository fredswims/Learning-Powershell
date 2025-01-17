$file=New-TemporaryFile
$folder=Split-Path $file -Parent
Start-Log -Path $file -ChildPath -LogPath $folder
get-item $file
stop-log