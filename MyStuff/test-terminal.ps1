function Test-Terminal ($id) {
$process=get-process -id $id
if($null -eq $process.Parent){return $false}
if($process.Name -eq 'WindowsTerminal'){return $true}
Test-Terminal -id $Process.Parent.$id
}

function test-this ($input) {
    if (1 -eq $input){return $true}
    if (1 -ne $input ){return $false}
}