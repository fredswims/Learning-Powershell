#Get two tables from excel and do a vlookup.
# Givin two tables from excel use the second (sheettwo) as a lookup table that contains a value.
# jump down to the bottom for the solution.
#Version 2019-10-15.0
push-location $env:OneDrive/swimclub
$sheetone=Import-Excel -path .\testBook.xlsx -StartColumn 1  -WorksheetName three
$sheettwo=Import-Excel -path .\testBook.xlsx -StartColumn 1  -WorksheetName four

#
#foreach ($name in $sheetone){if ($sheettwo -match $name){"In sheettwo $name"}}
#find the items in sheetone that are in sheettwo.
# (sidenote - this validates the items in sheetone)
$thisFound = 0
$thisNotFound = 0
foreach ($item in $sheetone) {
     if ($sheettwo.first -match $item.first -and $sheettwo.last -match $item.last ) {
        $thisFound++
        "$($thisFound): found $($item.first) $($item.last)"
    }
    else {
        $thisNotFound++
        "$($thisnotfound): Did not find $($item.first) $($item.last)"
    }
}
#turn it around
#find the items in sheettwo that are in ( and not in sheetone)
$thisFound = 0
$thisNotFound = 0
$NotFound=@{}
foreach ($item in $sheettwo) {
    if ($sheetone.first -match $item.first -and $sheetone.last -match $item.last ) {
        $thisFound++
        #"{0}: found {1} {2}" -f $thisFound, $item.first,$item.last
    }
    else {
        $thisNotFound++
        "$($thisNotFound): Did not find $($item.first) $($item.last)"
        $NotFound.Add($Item.first+" "+$item.Last,$thisNotFound)
    }
}
"Found:{0} Not Found: {1}" -f $thisFound, $thisNotFound

#Use Sheettwo is a look-up table.$
#for each item in sheetone that is in sheettwo, return the value-colunn in Sheettwo.
#put each of the objects in Sheettwo into a hast table.
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
$sheettwo | foreach-object {if($sheetone.first -like $psitem.first -and $sheetone.last -like $psitem.last ){$psitem, $psitem.value}else {"..........Did not find $($psitem.first)"}}
"# ******** can i build a custom object? "
$sheettwo | foreach-object {if($sheetone.first -like $psitem.first -and $sheetone.last -like $psitem.last ){"{1} {0}" -f $psitem.value,$psitem.first}}
$customobject=$sheettwo | `
foreach-object {if($sheetone.first -like $psitem.first -and $sheetone.last -like $psitem.last ){$psitem.first, $psitem.last, $psitem.value}}
"# *********and return a custom object"
#
$customobject=$sheettwo | where-object {$sheetone.first -like $psitem.first -and $sheetone.last -like $psitem.last}
$customobject
pop-location

$customobject=$sheettwo | where-object {!($sheetone.first -like $psitem.first -and $sheetone.last -like $psitem.last)}
$customobject


$object=$sheettwo | where-object {$sheetone.first+$sheetone.last -like $psitem.first+$pstime.last}

$object=$sheettwo | where-object { $psitem.first+$pstime.last -notlike $sheetone.first+$sheetone.last}
#make an array out of sheetone
#use it in where-object
#
###***************this is the best way to do it
push-location $env:OneDrive/swimclub
$SignedUpSheet=Import-Excel -path .\testBook.xlsx -StartColumn 1  -WorksheetName three
$PendingReturnSheet=Import-Excel -path .\testBook.xlsx -StartColumn 1  -WorksheetName four
#make an explicit list of those signedup.
$Call=$PendingReturnSheet|Where-Object {($psitem.first+$psitem.last) -notin $SignedUpCollection}
$SignedUpCollection=foreach($item in $SignedUpSheet) {$item.first+$item.last}
$NoCall=$PendingReturnSheet|Where-Object {($psitem.first+$psitem.last) -in $SignedUpCollection}
#Which items on the SignedUpSheet are new?
$PendingReturnCollection=foreach($item in $PendingReturnSheet){$item.first+$item.last}
$NewMembers=$SignedUpSheet|Where-Object{($psitem.first+$psitem.last) -notin $PendingReturnCollection}
###
$call|where-object {!($customobject.first -like $psitem.first -and $customobject.last -like $psitem.last)}

push-location $env:OneDrive/swimclub
$sheeta=Import-Excel -path .\testBook.xlsx -StartColumn 1 -EndColumn 2 -WorksheetName "fred"
#$sheetaone=$sheetone|Sort-Object -Property last,first
$sheetb=Import-Excel -path .\testBook.xlsx -StartColumn 1 -EndColumn 2 -WorksheetName "ellen"
#$sheetb=$sheettwo|Sort-Object -Property last,first
$diffobj=Compare-Object -ReferenceObject $sheeta -DifferenceObject $sheetb -IncludeEqual
"The difference count is {0} " -f $diffobj.count
"here is output from the obj"
$diffobj
"The end "

$diff1=Compare-Object -ReferenceObject (get-content temp.txt) -DifferenceObject (Get-Content .\temp1.txt) -IncludeEqual
"The difference count is {0} " -f $diff1.count
"here is output from the obj"
$diff1
"end of diff"

$laurie
CopyHistoryById
