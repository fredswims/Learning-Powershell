# refactor faj
Set-Location $env:onedrive
Set-Location swimclub\2018
$2018 = import-csv -path .\Roster.csv

$myarray = @()
foreach ($item in $2018) {
    $IntAge = [int]$item.ClubAge
    if ($intage -lt 8) { [int]$Group = 8 }
    elseif ($intage -lt 10) { [int]$Group = 10 }
    elseif ($intage -lt 12) { [int]$Group = 12 }
    elseif ($intage -lt 16) { [int]$Group = 16 }

    $myObject = [PSCustomObject]@{
        PSTypeName = 'My.Object'
        Group      = $Group
        Gender     = $item.Gender
        ClubAge    = $item.ClubAge
        LastName   = $item.LastName
        FirstName  = $item.FirstName
    }
    $myarray += $myobject #$myarray has pointers to $myobject data. That is why we create the custom object repeatedly.
}