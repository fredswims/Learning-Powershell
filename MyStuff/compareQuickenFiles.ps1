#2017-09-29
#Quick test to determine is the Quicken file
#on the desktop is the same as the one in the repository.
Set-StrictMode -Version latest
Clear-Host
$Qfile = "Harriet.qdf"
#$Qfile="Home.qdf"

$DesktopQ = join-path $env:homedrive (join-path $env:homepath  (join-path "Documents\Quicken\"  $Qfile))
if (test-path $DesktopQ) {write-host "Desktop Q -> $Desktopq"}
else {write-host "can't locate $Desktopq"; exit}

#where is Dropbox located on this machine
#assumption is one of these two places
$respositoryFolder = join-path $env:homedrive (Join-Path $env:homepath  "Dropbox")
If (test-path $respositoryFolder) {}
else {$respositoryFolder = join-path $env:homedrive (join-path $env:homepath  "Documents\Dropbox")}
if (test-path $respositoryFolder) {write-host "repository folder -> $respositoryfolder"}
else {write-host "can't locate Dropbox Folder"; exit}
$respositoryQ = join-path $respositoryFolder (join-path "Private\Q\" $Qfile)
if (test-path $respositoryQ) {
    write-host "Repository Q -> $respositoryQ"
}
else {"can't find file in repository"}

$desktopHash = Get-FileHash $desktopQ
write-host "$($desktopHash.Hash) <-Desktop Q"

$respositoryHash = Get-FileHash $respositoryQ
write-host "$($respositoryHash.Hash) <-Repository Q"

if ($desktopHash.Hash -eq $respositoryHash.Hash) {Write-Output "the files are the same"}
else {Write-Output "The files are different"}
#Compare-Object -ReferenceObject $desktopHash -DifferenceObject $respositoryHash