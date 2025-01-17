<# 
$dirs=($env:PSModulePath).Split(";")
foreach ($dir in $dirs) {
    (test-path $dir) ? ($(set-location $dir;read-host "[$(get-location)]";$(get-item *).Name ;read-host "[pause]")) : "false"}

#>
Clear-Host
$dirs = ($env:PSModulePath).Split(";")
foreach ($dir in $dirs) {
    if (test-path $dir) {
        # set-location $dir
        read-host "[$dir]"
        $(get-item -path (Join-Path $dir "*")).Name
        read-host "[^ $dir]"
    }
    else { read-host "[$dir] Folder does not exist" }
}
    