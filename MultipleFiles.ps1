


#1..10 | Foreach-Object {New-Item -ItemType Directory C:\Users\freds_000\Documents\TEST_1\Folder_"$_"}

Get-ChildItem -path $path -Recurse | Where-Object {$_.PsIsContainer} |Group-Object {$_.FullName.Split('_')[0] }$folders= Get-ChildItem -path $path -Recurse | Where-Object {$_.PsIsContainer} |Group-Object {$_.FullName.Split('_')[0] }