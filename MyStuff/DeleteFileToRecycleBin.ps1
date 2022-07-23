# Clear-RecycleBin
Add-Type -AssemblyName Microsoft.VisualBasic
[Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($DestinationPath, 'OnlyErrorDialogs', 'SendToRecycleBin')
