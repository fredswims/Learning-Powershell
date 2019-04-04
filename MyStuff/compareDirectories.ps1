compare-object -referenceobject $(get-content "C:\Users\freds_000\Dropbox\Private\DMR\Latest MD180 plug 6-10-15 w LIMARC ContactsFredx.rdt") -differenceobject $(get-content "C:\Users\freds_000\Dropbox\Private\Ham\DMR\MD-380\Latest MD180 plug 6-10-15 w LIMARC ContactsFredx.rdt") 
compare-object -referenceobject $(get-content "C:\Users\freds_000\Dropbox\Private\DMR\Latest MD180 plug 6-25-15 w LIMARC Contacts.rdt") -differenceobject $(get-content "C:\Users\freds_000\Dropbox\Private\Ham\DMR\MD-380\Latest MD180 plug 6-25-15 w LIMARC Contacts.rdt")
 
 compare-object -referenceobject $(get-content "C:\Users\freds_000\Dropbox\Private\DMR\fred2015-07-11.rdt") -differenceobject $(get-content "C:\Users\freds_000\Dropbox\Private\Ham\DMR\MD-380\fred2015-07-11.rdt")
 compare-object -referenceobject $(get-content "C:\Users\freds_000\Dropbox\HSBCApr.xlsx") -differenceobject $(get-content "C:\Users\freds_000\Dropbox\Private\Ham\DMR\MD-380\fred.rdt")
 compare-object -referenceobject $(get-content "C:\Users\freds_000\Dropbox\HSBCApr.xlsx") -differenceobject $(get-content "C:\Users\freds_000\SkyDrive\Documents\HSBCApr1.xlsx")
$a = New-Object System.Collections.ArrayList
$a.Add("red") 
$a.Add("yellow") 
$a.Add("orange") 
$a.Add("green") 
$a.Add("blue") 
$a.Add("purple")
$myArray=(1..3)

foreach ($element in $myArray) {$element}
for $a in $myArray {$element}
$i = 1
          for (;;){Write-Host $i}

          "C:\Users\freds_000\Documents\foo"
Compare-Object -ReferenceObject "C:\Users\Super Computer\Documents\Dropbox\Private\Tax\TurboTax\2015 Jacobowitz F Form 1040  Individual Tax Return.tax2015" -DifferenceObject "C:\Users\Super Computer\Documents\Dropbox\Private\Tax\TT\2015 Jacobowitz F Form 1040  Individual Tax Return.tax2015"
help -compare-object
Compare-Object -ReferenceObject $(get-content "C:\Users\Super Computer\Documents\Dropbox\Private\Tax\TurboTax\2015 Jacobowitz F Form 1040  Individual Tax Return.tax2015") -DifferenceObject $(get-content "C:\Users\Super Computer\Documents\Dropbox\Private\Tax\TT\2015 Jacobowitz F Form 1040  Individual Tax Return.tax2015")
