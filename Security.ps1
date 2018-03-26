$path="C:\Users\Super Computer\Documents\Quicken"
set-location $path
get-location
$lines=content "home.qif"
$lines.count
$end=$lines.Count
$lineCount=0
do
{$lineCount
$lines[$lineCount]
    do
    {$temp=$empty
    $tempCount=0
     $temp[$tempCount]=$lines[$lineCount]
    }
    until ($lines[$lineCount -
}
while (++$lineCount -le 100)