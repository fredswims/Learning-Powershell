[CmdletBinding()]
param (
    [String]
    $FutureParameterName
)
# FAJ 2021-02-04
# find the quicken files that changed today
# $changeList = get-childitem -recurse -path $env:ProgramData\quicken  -Include *.* | Where-Object { $_.LastWriteTime -GE [DATETIME]::TODAY }
# Get all the files
Write-Warning "In function $($MyInvocation.MyCommand.Name): "
$ChangeList=get-childitem -recurse -file -Path "$env:ProgramData\quicken","$env:APPDATA\Quicken" -exclude "*.html", "*.png", "*.exe"
    # -exclude "$env:ProgramData\quicken\OfflineHelp\*.*"

if ($changeList.count -eq 0) { "No new files." }
else {
    # $sizeKb=$ChangeList|Measure-Object -Property Length -AllStats|Select-Object @{name="SizeInKb";e={$psitem.sum/1mb}}
    $size=$ChangeList|Measure-Object -Property Length -AllStats|Select-Object sum
    "Making a zip file with {0:n0} files and {1} mb before compression" -f $changelist.Count, [math]::round($size.sum/1mb,3)
    read-host "[RETURN] to continue"
    # $changelist|Select-Object   -Property Mode,LastWriteTime,Length,FullName  |Out-GridView
    "Making a zip file with {0} file(s)." -f $changeList.count
    # create a zipfile
    # $zipName="QdiffZip$(get-date -Format "yyyy-MM-ddTHH-mm-ss").zip"
    $zipName="QdiffZip-{0}.zip" -f $(get-date -Format "yyyy-MM-ddTHH-mm-ss")
    $zipFullPath=(join-path $env:temp $zipName) 
    $changeList | `
        Compress-Archive `
        -DestinationPath $zipFullPath `
        -CompressionLevel Fastest -Confirm -Update  
    "Making a zip file with {0:n0} files and {1} mb before compression" -f $changelist.Count, [math]::round($size.sum/1mb,3)
    # "Made a zip file with {0:n0} file(s)." -f $changeList.count
    "Zip file {0} is compressed to {1} mb" -f $zipFullPath, [math]::round( (get-item $zipFullPath).Length/1mb,3)
}