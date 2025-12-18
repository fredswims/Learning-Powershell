function Get-LibraryFolders {
    $libraryPath = "$env:APPDATA\Microsoft\Windows\Libraries"
    $libraryFiles = Get-ChildItem -Path $libraryPath -Filter *.library-ms -ErrorAction SilentlyContinue

    foreach ($file in $libraryFiles) {
        try {
            $xmlDoc = New-Object System.Xml.XmlDocument
            $xmlDoc.Load($file.FullName)

            # Create namespace manager
            $nsmgr = New-Object System.Xml.XmlNamespaceManager($xmlDoc.NameTable)
            $nsmgr.AddNamespace("lib", "http://schemas.microsoft.com/windows/2009/library")

            # Select folder nodes
            $folderNodes = $xmlDoc.SelectNodes("//lib:folder", $nsmgr)

            $folders = @()
            foreach ($node in $folderNodes) {
                $urlNode = $node.SelectSingleNode("lib:url", $nsmgr)
                if ($urlNode -and $urlNode.InnerText -like "file:///*") {
                    $decoded = $urlNode.InnerText -replace '^file:///', '' -replace '%20', ' '
                    $folders += $decoded
                }
            }

            [PSCustomObject]@{
                LibraryName     = $file.BaseName
                IncludedFolders = $folders
            }
        } catch {
            Write-Warning "Failed to parse $($file.Name): $_"
        }
    }
}
# Example usage:
Get-LibraryFolders | Format-Table -AutoSize

#Get-LibraryFolders | Export-Csv -Path "$env:USERPROFILE\Desktop\LibraryFolders.csv" -NoTypeInformation