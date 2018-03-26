add-Type -TypeDefinition  (Get-content -raw .\test.cs)
$obj=New-Object test

"Add"
1..5 | ForEach-Object { $obj.Add($_,($_ + 1))}
"`nMult"
1..5 | ForEach-Object {$obj.Mult($_, $_)}
Get-ChildItem

