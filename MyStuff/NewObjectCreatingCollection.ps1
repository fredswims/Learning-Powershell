# https://stackoverflow.com/questions/19402629/powershell-compare-text-files-and-show-differences
#look how a collection of objects is made in line one and two.

$book1=$env:homepath\mystuff\books

$abc = Get-Content .\z.txt | ForEach-Object {$i = 1} { new-object psobject -prop @{LineNum=$i;Text=$_}; $i++}
$cde = Get-Content .\x.txt | % {$i = 1} { new-object psobject -prop @{LineNum=$i;Text=$_}; $i++}
Compare-Object $abc $cde -Property Text -PassThru -IncludeEqual