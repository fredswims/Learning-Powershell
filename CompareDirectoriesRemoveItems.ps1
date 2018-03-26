cd "c:\Users\Super Computer\Pictures\SONYa6000"
$ellen=get-childitem
$ellen.count

cd "c:\Users\Super Computer\Pictures\SONYa6000\a6000Dump2016Dec2\DCIM\100MSDCF"
 
$fred=Get-ChildItem
$fred.Count


$diff=Compare-Object -ReferenceObject $fred -DifferenceObject $ellen -property name -IncludeEqual -excludeDifferent
$diff.count

ForEach-Object -Process {echo $_.name} -InputObject $diff

# delete files from the this directory.
cd "c:\Users\Super Computer\Pictures\SONYa6000"

ForEach-Object -Process {remove-item $_.name} -InputObject $diff

#run the first step again to check that it worked.

# find my turbo tax duplicated files

$TTDir="C:\Users\Super Computer\Documents\Dropbox\Private\Tax\TT"
$TTDir="C:\Users\freds_000\Dropbox\Private\Tax\TT"
$TurboTaxDir="C:\Users\Super Computer\Documents\Dropbox\Private\Tax\TurboTax"
$TurboTaxDir="C:\Users\freds_000\Dropbox\Private\Tax\TurboTax"
# get file names
$TTfiles=get-childitem -path $TTDir
$TTfiles.count
# get file names
$TurboTaxFiles=get-childitem -path $TurboTaxDir
$TurboTaxFiles.count

ForEach-Object -InputObject $TTfiles -process {compare-object -referenceobject $(get-content ($ttdir+"\"+$_.name)) -differenceobject $(get-content ($turbotaxDir+"\"+$_.name))}



ForEach-Object -InputObject $TTfiles -process {echo ($ttdir+"\")}
ForEach-Object -InputObject $TTfiles -process {echo $_.name}

foreach ($element in $ttfiles) {$element}
$TTfiles=get-childitem -path $TTDir -name * | ForEach-Object {echo $_}




# GOOD ^^^^^^^


ForEach-Object  -Process {compare-object -referenceobject $(get-content $_) -differenceobject $(get-content $_) -IncludeEqual -ExcludeDifferent} -InputObject $diff.name

get-process | ForEach-Object -process {echo ("fred "  + $_.ProcessName)}

$ellen=Get-Process
ForEach-Object -process {echo ("fred "  + $_)} -InputObject $ellen

1,2,$null, 4 | ForEach-Object -Process {("Hello" + $_)}
$irv=1,2,$null,4
$irv | ForEach-Object -Process {("Hello" + $_)}

ForEach-Object -Process {("Hello" + $_)}




# another approach
# find my turbo tax duplicated files

#$TTDir="C:\Users\Super Computer\Documents\Dropbox\Private\Tax\TT"
$TTDir="C:\Users\freds_000\Dropbox\Private\Tax\TT"
#$TurboTaxDir="C:\Users\Super Computer\Documents\Dropbox\Private\Tax\TurboTax"
$TurboTaxDir="C:\Users\freds_000\Dropbox\Private\Tax\TurboTax"

cd $ttdir
$ttfiles=Get-ChildItem
cd $TurboTaxDir
$TurboTaxFiles=Get-ChildItem

$diff=Compare-Object -ReferenceObject $ttfiles -DifferenceObject $turbotaxfiles -property name -IncludeEqual -excludeDifferent
$diff.count


for($i=0
    $i-lt $diff.count
    $I++) 
    {
        echo $i
        echo $diff.name[$i]
        echo "FileHash"
        $Hash1=$null
        $Hash2=$null
        $Hash1=Get-FileHash -Path ($ttdir + "\" + $diff.name[$i])
        $Hash2=Get-FileHash -Path ($TurboTaxDir + "\" + $diff.name[$i])

        if ($Hash1.Hash -eq $Hash2.Hash) {echo "good"}
        else {echo "bad"
                break}

        
        }


for($i=0
    $i-lt $diff.count
    $I++) 
    {
        echo $i
        echo $diff.name[$i]
        echo "compare-object"

        #$Hash=Get-FileHash -Path ($ttdir + "\" + $diff.name[$i])
        $temp=$null
        $temp=Compare-Object -ReferenceObject $(get-content ($ttdir + "\" + $diff.name[$i])) -DifferenceObject $(get-content ($TurboTaxDir + "\" + $diff.name[$i]))
        if ($temp -eq $null) {echo "good"}
        else {echo "bad"
                break}

        #echo $temp
        }
if ($temp -ne $null) {Echo "SHITTTTTTT"}


