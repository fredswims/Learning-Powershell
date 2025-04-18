# author FAJ
# date 2025-04-18
# clean up the mess left behind by onedrive migration to version 2
try {
    $error.clear()
    Clear-Host
    $thisHostName = [system.net.dns]::gethostname()
    push-location $env:OneDrive

    # Find the crazy folders (as a result of the One Drive migration) that have the HOST-Name appended to them.
    write-host "Find the Crazy Folders"
    $CrazyFolders = Get-ChildItem -Recurse -Directory -Include "*-$($thisHostName)"  | sort-object 
    if ($CrazyFolders.count -eq 0) {
        write-host "No Crazy Folder Found - Aren't You Lucky?!"
        exit 0
    }
    # Process each Crazy Folder
    write-host "Let's work on the Crazy Folders"
    $CrazyFolders
    foreach ($CrazyFolder in $CrazyFolders) {
        write-host "Crazy folder is $Crazyfolder"
        read-host "does crazy folder appear as a link"
        $StartingDir = $CrazyFolder
        $OriginalFolder = $startingdir.fullname.Replace("-$($thishostname)", "")
        # $startingDir = "C:\Users\freds\OneDrive\Private-Book4Edge".ToLower()
        set-location $startingDir
        # find all the subfolders
        $SubFolders = Get-ChildItem -Recurse -Directory -path $StartingDir\*  | sort-object $dir.fullname
        $Dirs = @($startingDir, $subfolders) | ForEach-Object { $_.FullName } | Sort-Object
        "The directories to check"
        $Dirs
        read-host "begin processing directories"
        foreach ($Dir in $Dirs) {
            $childtarget = $dir.Remove(0, $startingDir.fullname.Length)
            $targetFolder = (join-path -path $OriginalFolder -ChildPath $childtarget)
            write-host `n`t$dir `n`t$targetFolder
            
            # rules
                # If the folder exist AND there is/are file(s) AND the hashes are different {then copy the file.}
                # if the folder does not exist AND there are files and the hashes are different {then copy the file.}
                # if the folder exists and the hashes are the same {then do nothing}
            # read-host "folders match?" 

            # Set some flags.
            $files = get-childitem -path $dir\* -File
            if ($files.count -eq 0) {$FilesFlag=$false} else {$FilesFlag=$true}
            if (test-path $targetFolder) {$TargetFolderFlag=$true} else {$TargetFolderFlag=$false}
            
            
            if (!(test-path $targetFolder)) { 
                Write-Host -ForegroundColor Red -Object ("Missing Folder {0}" -f $targetfolder)
                write-host "Create Folder - but only if files are in folder"
                # *** here is the place to fix 
            }
            else {
                Write-Host -ForegroundColor Red -Object ("Exist: Folder {0}" -f $targetfolder)
                # read-host ("Files in folder {0}" -f $dir)
                $files = get-childitem -path $dir\* -File
                write-host ("There are [{0}] files in folder [{1}]" -f $files.count, $dir)

                if ($files.count -eq 0) { write-warning ("file count {0} in {1}" -f $files.count, $dir) }
                else {
                    $counter=0
                    foreach($file in $files){
                        $counter++
                        write-host "`t $counter `t $($file.name)"
                    }
                    "now lets work on the files"
                    foreach ($file in $files) `
                    {
                        if (!(test-path (join-path $targetFolder $file.Name))) { 
                            write-host -ForegroundColor Red ("File {0} does not exist" -f (join-path $targetFolder $file.name)) 
                            write-host "Copy/Move $($file.name) to $targetfolder"
                        } 
                        else {
                            "File {0} does exist" -f (join-path $targetFolder $file.name)

                            "Now comparing File Hash"
                            if ((Get-FileHash $file).hash -eq (Get-FileHash (join-path -Path $targetFolder -ChildPath $file.name)).hash)
                            { "Hash is good" }
                            else {
                                write-warning "Hash failed"
                                write-host -ForegroundColor Red -OBJECT ("Hash is bad. Move this file {0}" -f $file.FullName)
                            }
                        }
                    }
                }
            }
        } 
    }
}
catch {
    "An error occurred that could not be resolved."
    Get-Error
}
Finally {
    set-location $startingDir
    Read-Host "Finis"
}