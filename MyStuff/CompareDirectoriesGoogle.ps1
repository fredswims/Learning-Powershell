# Test is the same files are present in a folder(s).
# Author FAJ 2022-12-14
function FileCount { param ($target)
    $xfiles = New-Object System.Collections.ArrayList
    Set-Location $home
    set-location (join-path ".\Google Drive (not syncing)\" $target)
    ($OldFolder=get-location)
    $oldfiles=Get-ChildItem -path * -File
    $oldfiles.Count 
    
    Set-Location $home
    set-location (join-path G: "My Drive" $target)
    ($NewFolder=get-location)
    $Newfiles=Get-ChildItem -path * -File
    $Newfiles.Count 
    
    $filecount=0
    $filescountmissing=0
    foreach ($file in $oldfiles) {
        if($file.name -in $newfiles.name) {$filecount++}
        else {$filescountmissing++
        "shit $($file.name)"
        $xfiles.Add($file) > $null
        }
    }
    "there are {0} files in {1}" -f $oldfiles.count, $OldFolder
    "there are {0} files in {1}" -f $newfiles.count, $newFolder
    "there are {0} that match by name in both files" -f $filecount
    "there are {0} files not found  in {1}" -f $filescountmissing, $newFolder
    "these files are missing from {0}" -f (get-location)
    $xfiles.name
    "eof"
}

Set-Location $home
Set-Location ".\Google Drive (not syncing)\"
# Get all the folders
$OldFolders=Get-ChildItem -Directory -Recurse
foreach ($folder in $oldFolders){
    $target=$folder.FullName.substring(($folder.FullName.IndexOf("ing)\"))+5) 
    $target
    filecount $target
}
