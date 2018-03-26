[System.Math]::Sqrt(36)
$DateTime= New-Object System.DateTime -ArgumentList 1953, 04, 04
$DateTime.DayOfYear

0 ..4 |  foreach-object -process { 
$year= 1950 + $_ 
$year
$DateTime= New-Object System.DateTime -ArgumentList $year, 04, 04
$DateTime.DayOfYear
}

"Begin - Create an object using a constructor and then make use of a method to perform an action."
$Year=1950
$Year
# $DateTime= new System.DateTime -ArgumentList $Year, 04, 04
# Alternative  
# See all constructors of Object
[System.DateTime]::New
$DateTime= [System.DateTime]::New( $Year, 04, 04)
0 ..4 |  % { 
$MyDateTIme= $Datetime.AddYears($_)
# $MyDateTIme.Year
# $MyDateTime.DayOfYear
"For the year {0} the day is {1}" -f $MyDateTIme.Year, $MyDateTIme.DayOfYear

}
"End"
