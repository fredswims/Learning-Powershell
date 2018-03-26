function global:prompt {
    "! "
}
prompt

$HarrietDir=$env:Homedrive + $env:homepath  + "\dropbox\Private\HarrietTrust\MedicaidPreparation\IncomeOnlyWellsDirector"
push-location -path  $HarrietDir

$thisYear=get-item 2017*
foreach ($file in $thisyear) {
$file.name
$newName=$(($file.name).Substring(0,12))
$newname}

$thisYear

foreach ($file in $thisyear) {
$file.name
$newName=$(($file.name).Substring(0,$(($file.name).Length-4)))
$newname}

$filelist=get-item -path "*-Checking*.pdf"
foreach ($file in $filelist) {
rename-item -confirm $file.name $file.name.replace("-Checkingx8340","Checkingx8340")


}

$file.BaseName.replace("Director","-PortfolioChecking") + $file.Extension


$file.name.