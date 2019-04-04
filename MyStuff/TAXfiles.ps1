# another approach
#location of all my TurboTax files
$a="C:\Users\Super Computer\Documents\TurboTax"
$b="C:\Users\Super Computer\Documents\Dropbox\Private\Tax\TurboTax"
$c="C:\Users\Super Computer\Documents\Dropbox\Private\Tax\TT"

#One file that is very import
$TTFileName="2015 Jacobowitz A Form 1040  Individual Tax Return.tax2015"

#set-up the two target directories for each run.
$ttdir=$c
$TurboTaxDir=$b

cd $ttdir
$ttfiles=Get-ChildItem | Sort-Object -Property name

cd $TurboTaxDir
$TurboTaxFiles=Get-ChildItem | Sort-Object -Property name

#Find files in those two directories with the same name and extention.
$diff=Compare-Object -ReferenceObject $ttfiles -DifferenceObject $turbotaxfiles -property name -IncludeEqual -excludeDifferent
$diff.count

#Compare files line by line using Compare-Object.
#Compare Filehash
$temp=$null
$badCount=0
$badHashCount=0
for($i=0
    $i-lt $diff.count
    $I++) 
    {
        echo $i
        echo $diff.name[$i]
        $ThisLeaf= $diff.name[$i]

        echo "compare-object"
        $temp=$null
        #$temp=Compare-Object -ReferenceObject $(get-content ($ttdir + "\" + $diff.name[$i])) -DifferenceObject $(get-content ($TurboTaxDir + "\" + $diff.name[$i]))
        $temp=Compare-Object -ReferenceObject $(get-content -path "$($ttdir)\$($ThisLeaf)") -DifferenceObject $(get-content -path "$($TurboTaxDir)\$($ThisLeaf)")

        if ($temp -eq $null) {echo "Compare is good for $($diff.name[$i]) "}
        else {
          echo "***************************************Files are different via Get-content bad"
          #break
          $badcount+=1
        }

        #echo $temp

        #Compare Filehash values
        #$hash1=get-filehash ($ttdir + "\" + $diff.name[$i])
        $hash1=get-filehash -path "$($ttdir)\$($ThisLeaf)"
        #$hash1.Hash
        #$hash2=get-filehash ($TurboTaxDir + "\" + $diff.name[$i])
        $hash2=get-filehash -path "$($TurboTaxDir)\$($ThisLeaf)"
        #$hash2.hash
        if ($hash1.Hash -eq $hash2.Hash) {echo "Hash    is good for $($ThisLeaf)  $($hash1.Hash) "}
        else {
         echo "***************************************Hash is bad"
         $badHashCount +=1
         }

    }
if (($temp -ne $null) -Or ($badcount -gt 0) -or ($badHashCount -gt 0)) {Echo "SHITTTTTTT"}
else {Echo "All is GOOD"}



#scratch
