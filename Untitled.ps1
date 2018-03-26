
$file = new-object system.io.streamreader -arg "test.log"
while ($line=$file.readline()) {
    $line
}
$file.Close


"
$ellen=get-childitem
foreach ($file in $ellen) { " `n`t the name of this 'file' is $($file.basename)"}
"

$ellen=gci;foreach ($file in $ellen){Write-host "the name of the file is $($ellen.basename) "}