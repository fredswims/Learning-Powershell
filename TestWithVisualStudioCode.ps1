$fred=Get-ChildItem
$fred.count
foreach ($file in $fred){Write-Output "The name of the file is   $($file.FullName) and the directory is c $($file.Directory)"}