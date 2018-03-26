
$MyPath="D:\"
$MyPath="D:\PRIVATE\AVCHD\BDMV\STREAM\"
$musicfiles = Get-ChildItem -Path $MyPath -Recurse
#start-sleep -second 5 #allows time to start debugging via ctrl-B

foreach ($song in $musicfiles)
{
#$song.FullName
if ($song.PSIsContainer) {Write-host  "DIRECTORY--------------------------------------------------------- " $song.FullName}
else{ write-host $song.FullName}
#if ($song.Extension -eq ".jpg" )
#{
#Copy-Item $song -Destination "D:\Documents\MP3PlayerMusic\SongsToConvert"
write-host "Got a jpg - " $song.FullName
#}
#else
#{
##Copy-Item $song -Destination "D:\Documents\MP3PlayerMusic"
#Write-Host "Got a what ****************************** - " $song.FullName
#}
}
