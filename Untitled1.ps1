$myDir = $env:HOMEPATH+"\Downloads"
$myFiles=gci $myDir  *.wav
$myFiles | ForEach-Object {
  $zip =  $_.fullname -replace "\.wav",".zip";
  new-item -type File $zip -force;
  ((new-object -com shell.application).namespace($zip)).copyhere($_.fullname)
}

$myFiles | ForEach-Object {
  $zip =  $_.fullname -replace "\.jpg",".zip";
  remove-item $zip
}
