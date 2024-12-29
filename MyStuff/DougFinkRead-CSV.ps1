# Doug is working on this
$url = 'https://github.com/mattharrison/datasets/raw/master/data/vehicles.csv.zip'
$data = Read-CSV -url $url

"Total
rows: $($data.Count)"
$data |Select-Object -First 10 | Format-Table