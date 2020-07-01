#I want to compare the current (new) file with the one I sent to bob.

$oldfile='C:\Users\Super Computer\Downloads\SussexContacts2020Bob.xlsx'
$newfile='C:\Users\Super Computer\Dropbox\Private\Sussex\SussexContacts2020.xlsx'
$NewX=import-excel -path $newfile
$BobX=import-excel -path $oldfile
#get rid of null or white space becae import-excel seems to be added 2 rows at the end of the last valid row.
$Bob=$bobx|where-object {![string]::IsNullOrWhiteSpace($psitem.name)}
#little trick that is equivalent to [string]::IsNullOrWhiteSpace($psitem.name)
$fred=$bobx|where-object {$psitem.name}
$New=$Newx|where-object {![string]::IsNullOrWhiteSpace($psitem.name)}

#There should be more records in the new file.
$Bob.Count
$New.count

#which email addresses where added to the new list?
$new|foreach-object  { if($psitem.email -notin $bobx.email ){"new item {0}" -f $psitem.name}  }
#Sanity check - all of the email address in the bob file should be in the new file.
$Bob|foreach-object  { if($psitem.email -notin $newx.email ){"new item {0}" -f $psitem.name}  }


#Looking for nulls or whitespace in email field
foreach ($item in $new) {if([string]::IsNullOrWhiteSpace($item.email) ){write-warning "found an empty email for $($item.name)" }}
foreach ($item in $new) {if(!$item.email){write-warning "found an empty email for $($item.name)" }}
foreach ($item in $new) {if([string]::IsNullOrWhiteSpace($item.email) ){write-warning "found an empty email for $($item.name)"} else {"good email {0} for {1}" -f $item.email, $item.name}}
