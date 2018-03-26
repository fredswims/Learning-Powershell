$RootFolder = "c:\"
$ErrorLog = "$home\Documents\WindowsPowerShell\countfolders.log" 
$ifolders = 0
$Error.Clear()
$MyError = 0
clear-host
If (Test-Path $RootFolder) {
    Try {
        $ErrorActionPreference = "Continue"
        Get-ChildItem $RootFolder -recurse -Force | Where-Object {$_.psiscontainer} | ForEach-Object {
            $ifolders ++
            Write-Progress  -Activity "Counting Folders" -Status "Counting" -CurrentOperation "Count: $ifolders - Name: $_.Fullname"
            $error.Count
            if ($error.count -ne $MyError) {
                Write-Host "an error occurred"
                $MyError = $Error.Count

                $DateTime = (Get-Date).ToShortDateString() + " " + (Get-Date).ToShortTimeString()
                $Target = $_.TargetObject
                $e = $_
                Add-Content -Path $ErrorLog -Value "$DateTime - $e $Target"
                Write-Host "$e $Target"
            }
                                            
        }
    }
    Catch {
        $DateTime = (Get-Date).ToShortDateString() + " " + (Get-Date).ToShortTimeString()
        $Target = $_.TargetObject
        $e = $_
        Add-Content -Path $ErrorLog -Value "$DateTime - $e $Target"
        Write-Host "$e $Target"
        $ErrorActionPreference = "Continue"
    }
}
Else {
    Write-Host "Path not found: $RootFolder."
}
Write-Host "`nScript complete."
Write-Host "Folder: $RootFolder"
Write-Host "Number of SubFolders: $ifolders`n"