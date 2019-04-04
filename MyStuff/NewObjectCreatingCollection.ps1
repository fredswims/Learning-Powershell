#https://stackoverflow.com/questions/19402629/powershell-compare-text-files-and-show-differences
#look how a collection of objects is made in line one and two.
$abc = gc .\z.txt | %{$i = 1} { new-object psobject -prop @{LineNum=$i;Text=$_}; $i++}
$cde = gc .\x.txt | %{$i = 1} { new-object psobject -prop @{LineNum=$i;Text=$_}; $i++}
Compare-Object $abc $cde -Property Text -PassThru -IncludeEqual