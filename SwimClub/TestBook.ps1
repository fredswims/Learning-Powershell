#Get two tables from excel and do a vlookup.
# Givin two tables from excel use the second (sheettwo) as a lookup table that contains a value.
# jump down to the bottom for the solution.
#Version 2019-10-15.0
push-location $env:OneDrive/swimclub
$sheetone=Import-Excel -path .\testBook.xlsx -StartColumn 1  -WorksheetName one
$sheettwo=Import-Excel -path .\testBook.xlsx -StartColumn 1  -WorksheetName two
<#
#foreach ($name in $sheetone){if ($sheettwo -match $name){"In sheettwo $name"}}
#find the members in sheetone that are in sheettwo.
foreach ($item in $sheetone){if ($sheettwo.first -match $item.first -and $sheettwo.last -match $item.last ){"I found it $($item.first) $($item.last)"}else{"Did not find $($item.first) $($item.last)"}}
#for each member of sheetone that is in sheettwo, return the value in sheettwo. Sheettwo is a look-up table.
#put each of the objects in sheettwo into a hast table.
$sheettwoarry=@{} #create empty hash table
#fill the hash table
foreach ($item in $sheettwo){$sheettwoarry.add($item.first+$item.last,$item.value)}
"# retrieve the value"
foreach ($item in $sheetone){$sheettwoarry[$item.first+$item.last]}
"# show the key and the value."
foreach ($item in $sheetone){if($sheettwoarry[$item.first+$item.last]){"The value of $($item.first) $($Item.last) is $($sheettwoarry[$item.first+$item.last]) "}}
"# do the same using a pipe. "
$sheetone | ForEach-Object {if($sheettwoarry[$_.first+$_.last]){"The value of $($psitem.first) $($psItem.last) is $($sheettwoarry[$psitem.first+$psitem.last]) "}}
" # DON'T need a hash table - just use the two objects.
$sheettwo | foreach-object {if($sheetone.first -like $psitem.first -and $sheetone.last -like $psitem.last ){$psitem, $psitem.value}}
"# ******** can i build a custom object? "
$sheettwo | foreach-object {if($sheetone.first -like $psitem.first -and $sheetone.last -like $psitem.last ){"{1} {0}" -f $psitem.value,$psitem.first}}
$customobject=$sheettwo | `
foreach-object {if($sheetone.first -like $psitem.first -and $sheetone.last -like $psitem.last ){$psitem.first, $psitem.last, $psitem.value}}
"# *********and return a custom object"
#>
$customobject=$sheettwo | where-object {$sheetone.first -like $psitem.first -and $sheetone.last -like $psitem.last}
$customobject
pop-location


#Get two tables from excel and do a vlookup.
# Givin two tables from excel use the second (sheettwo) as a lookup table that contains a value.
# jump down to the bottom for the solution.
push-location $env:OneDrive/swimclub
$sheetone=Import-Excel -path .\testBook.xlsx -StartColumn 1  -WorksheetName one
$sheettwo=Import-Excel -path .\testBook.xlsx -StartColumn 1  -WorksheetName two
<#
#foreach ($name in $sheetone){if ($sheettwo -match $name){"In sheettwo $name"}}
#find the members in sheetone that are in sheettwo.
foreach ($item in $sheetone){if ($sheettwo.first -match $item.first -and $sheettwo.last -match $item.last ){"I found it $($item.first) $($item.last)"}else{"Did not find $($item.first) $($item.last)"}}
#for each member of sheetone that is in sheettwo, return the value in sheettwo. Sheettwo is a look-up table.
#put each of the objects in sheettwo into a hast table.
$sheettwoarry=@{} #create empty hash table
#fill the hash table
foreach ($item in $sheettwo){$sheettwoarry.add($item.first+$item.last,$item.value)}
"# retrieve the value"
foreach ($item in $sheetone){$sheettwoarry[$item.first+$item.last]}
"# show the key and the value."
foreach ($item in $sheetone){if($sheettwoarry[$item.first+$item.last]){"The value of $($item.first) $($Item.last) is $($sheettwoarry[$item.first+$item.last]) "}}
"# do the same using a pipe. "
$sheetone | ForEach-Object {if($sheettwoarry[$_.first+$_.last]){"The value of $($psitem.first) $($psItem.last) is $($sheettwoarry[$psitem.first+$psitem.last]) "}}
" # DON'T need a hash table - just use the two objects.
$sheettwo | foreach-object {if($sheetone.first -like $psitem.first -and $sheetone.last -like $psitem.last ){$psitem, $psitem.value}}
"# ******** can i build a custom object? "
$sheettwo | foreach-object {if($sheetone.first -like $psitem.first -and $sheetone.last -like $psitem.last ){"{1} {0}" -f $psitem.value,$psitem.first}}
$customobject=$sheettwo | `
foreach-object {if($sheetone.first -like $psitem.first -and $sheetone.last -like $psitem.last ){$psitem.first, $psitem.last, $psitem.value}}
"# *********and return a custom object"
#>
$customobject=$sheettwo | where-object {$sheetone.first -like $psitem.first -and $sheetone.last -like $psitem.last}
$customobject
pop-location


