# how to find things...
# see members; methods and properties
#what members are there for a string
$ellen="fred"
$fred=$ellen|get-member -Verbose -view all
$fred
#lines get truncated - too get the full string of each Property/Method

foreach ($def in $fred) {write-host "$($def.name) ->$($def.definition)"}

foreach ($def in $fred) {if ($def.name -like "Compare*") {write-host $def.definition}}
foreach ($def in $fred) {if ($def.name -like "compare*"){
write-host $($def.name)  
write-host $($def.MemberType)
write-host $($def.Definition)
}}

$fred | Where-Object {$_.name -like "compare*"} # still short
$fred | Where-Object -property name -like -value "compare*"

#this is the best
$fred | Select-Object  -property name, MemberType, Definition | Format-list





#see items; loop thru array   $fred[$i]

(new-object -comobject WScript.Network).addprinterconnection

#for inter32
$fred=132
$fred | gm


# see how to call a particular method. truncates like above.
$fred="ellen"
$fred.Substring # no parens ()

# use TypeName instead of an object.
[system.math] | gm -Static 

[System.DateTime]::new # without the () shows overloadDefinitions (Constructors)
$fred=[System.DateTime]::new(2016,9,2)



see file called   Get-Constructor.ps1

#------------------------------------------
Get-Command -name mkdir -ShowCommandInfo
get-command -noun "item"
get-command -Noun "computerrestorepoint"
get-command -Syntax New-Item
show-command New-Item

Get-ComputerInfo
Get-ComputerRestorePoint

$fred=Get-ChildItem
Show-Object $fred


Get-ComputerRestorePoint


@'Fred this is a long line
this is the second lime
this is the third line'@
Get-ChildItem