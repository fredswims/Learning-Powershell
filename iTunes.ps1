start-job -name itunes -scriptblock {
$iTunes = New-Object -ComObject iTunes.Application
$LibrarySource = $iTunes.sources.ItemByName('Library')
$libraryplaylist = $librarysource.playlists.itembyname('Jason M')
#$songstoplay = (1..4) | %{ $libraryplaylist.tracks |get-random}
$songstoplay =  $libraryplaylist.tracks

foreach($song in $songstoplay){
$song.play()
$host.ui.rawui.windowtitle = "Now playing -- " + $song.name
start-sleep -seconds $song.duration
$host.ui.rawui.windowtitle = "Windows Powershell"
}
}
"Creating Object"
$timer = new-object timers.timer
$action = {
$Global:windowtitle = receive-job -name itunes -Keep 
}
$timer.Interval = 10000
$Timer.Enabled = $True
Register-ObjectEvent -InputObject $timer -EventName elapsed `
–SourceIdentifier ItunesTimer2 -Action $action | Out-Null
"Ready to start timer"
$Timer.Start()
"Timer started"