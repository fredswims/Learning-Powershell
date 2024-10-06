# from doug
2..8 |%{$d='1'*$_;$s=$d+' * '+$d;$s+' = '+(iex $s)}



# $Windows = Get-ChildItem C:\Windows | Select-Object -First 116
$Windows = Get-ChildItem * | Select-Object -First 116

$Total = $Windows.Count
 
$i = 1
$Windows.ForEach({
    Write-Progress -Activity "Iterating through files" -Status "File $i of $Total <$($_.basename)>" -PercentComplete (($i / $Total) * 100)  -CurrentOperation "Moving"
    $i++
    Start-Sleep -Milliseconds 60
})