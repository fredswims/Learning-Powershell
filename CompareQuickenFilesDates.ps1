Clear-Host
#set-location 'C:\Users\Super Computer\Documents\dropbox\private\q'
#'Location of repository for Quicken files'
set-location (join-path $env:HOMEPATH 'Documents\Dropbox\Private\q')
CompareQFiles "harriet.qdf"
#'Location of working Directory'
set-location (join-path $env:HOMEPATH 'Documents\Quicken')
CompareQFiles "harriet.qdf"
#'Location of backup Directory'
set-location (join-path $env:OneDrive 'Documents\QBACKUP')
$thisfile = (get-item "harriet*.QDF-backup" | Sort-Object lastwritetime -Descending | Select-Object -First 1).name
CompareQFiles $thisfile




function CompareQFiles ($filename) {
    write-host $pwd -ForegroundColor Red
    $properties = (get-item $filename | Get-Member -MemberType Property | Where-Object {$_.name -match "^Last.*Time$" -or $_.name -match "length"}).name
    $file = get-item $filename
    foreach ($property in $properties) {$file.name + " " + $property + " " + $file.$property}
}