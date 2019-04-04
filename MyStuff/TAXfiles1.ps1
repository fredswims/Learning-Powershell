# another approach
#location of all my TurboTax files
$a="C:\Users\Super Computer\Documents\TurboTax"
$b="C:\Users\Super Computer\Documents\Dropbox\Private\Tax\TurboTax"
$c="C:\Users\Super Computer\Documents\Dropbox\Private\Tax\TT"

#One file that is very import
$TTFileName="2015 Jacobowitz A Form 1040  Individual Tax Return.tax2015"

#set-up the two target directories for each run.
$TtDir1=$c
$TtDir2=$b

cd $TtDir1
$TtFiles1=Get-ChildItem | Sort-Object -Property name

cd $TtDir2
$TtFiles2=Get-ChildItem | Sort-Object -Property name

#Find files in those two directories with the same name and extention.
$diff=Compare-Object -ReferenceObject $TtFiles1 -DifferenceObject $TtFiles2 -property name -IncludeEqual -excludeDifferent
$diff.count

#Compare files line by line using Compare-Object.
#Compare Filehash
$temp=$null
$badCount=0
$badHashCount=0
for($i=0
    $i-lt $diff.count
    $i++) 
    {
        echo $i
        echo $diff.name[$i]
        $ThisLeaf= $diff.name[$i]

        echo "compare-object"
        $temp=$null
        #$temp=Compare-Object -ReferenceObject $(get-content ($TtDir1 + "\" + $diff.name[$i])) -DifferenceObject $(get-content ($TtDir2 + "\" + $diff.name[$i]))
        $temp=Compare-Object -ReferenceObject $(get-content -path "$($TtDir1)\$($ThisLeaf)") -DifferenceObject $(get-content -path "$($TtDir2)\$($ThisLeaf)")
        

        if ($temp -eq $null) {echo "Compare is good for $($diff.name[$i]) "}
        else {
          echo "***************************************Files are different via Get-content bad"
          #break
          $badcount++
        }

        #echo $temp

        #Compare Filehash values
        #$hash1=get-filehash ($TtDir1 + "\" + $diff.name[$i])
        $hash1=get-filehash -path "$($TtDir1)\$($ThisLeaf)"
        #$hash1.Hash
        #$hash2=get-filehash ($TtDir2 + "\" + $diff.name[$i])
        $hash2=get-filehash -path "$($TtDir2)\$($ThisLeaf)"
        #$hash2.hash
        if ($hash1.Hash -eq $hash2.Hash) {echo "Hash    is good for $($ThisLeaf)  $($hash1.Hash) "}
        else {
         echo "***************************************Hash is bad"
         $badHashCount ++
         }
         echo "Bad Hash Count is $badHashCount"

    }
if (($temp -ne $null) -Or ($badcount -gt 0) -or ($badHashCount -gt 0)) {Echo "SHITTTTTTT"}
else {Echo "All is GOOD"}



#scratch
