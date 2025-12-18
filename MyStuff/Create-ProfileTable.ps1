write-warning $PSCommandPath
$profileTable = @{}

$PROFILE.PSObject.Properties | ForEach-Object {
    $profileTable[$_.Name] = $_.Value
}

$profileTable