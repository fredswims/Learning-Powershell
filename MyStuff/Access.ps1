($Copyright = "'SwimRiteNow' Copyright 2018 FAJ")
# find all the properties and methods
$l_accessApp = new-object -ComObject access.application
$l_accessApp | Get-Member
# https://stackoverflow.com/questions/44682487/use-powershell-to-create-queries-in-ms-access

Set-Location $env:onedrive\swimclub\2018
$Database="SwimRiteNow.accdb"
$DatabasePath=join-path $pwd -childpath $Database
$l_outputFile = join-path $pwd -childpath "output.csv"

<#
            $l_dbPath = $DatabasePath
            $l_accessApp = new-object -com access.application
            $l_accessApp.OpenCurrentDatabase($l_dbPath)

            $l_query = "SELECT Roster.FirstName,Lastname From Roster;"
            $l_queryName = "Export_Query1"
            $l_accessApp.CurrentDB().CreateQueryDef($l_queryName, $l_query)

            $e_acExportDelim = 2 #$l_accessApp.Enumerations.AcTextTransferType.acExportDelim #arg.  this does not seem to exist...
            $e_HasFieldNamesYes=-1
            $l_exportSpec = ""
            $l_accessApp.DoCmd.TransferText($e_acExportDelim,$l_exportSpec,$l_queryName,$l_outputFile,$e_HasFieldNamesYes)
            $l_accessApp.CloseCurrentDatabase()
#>


$l_dbPath = $DatabasePath
            $l_accessApp = new-object -com access.application
            $l_accessApp.OpenCurrentDatabase($l_dbPath)

            #$l_query = "SELECT Roster.FirstName,Lastname From Roster;"
            $l_queryName = "aqMeetEvents"
            #$l_accessApp.CurrentDB().CreateQueryDef($l_queryName, $l_query)

            if (test-path $l_outputFile) {remove-item $l_outputFile }
            #$l_outputFile = join-path $pwd -childpath "output.csv"
            $e_acExportDelim = 2 #$l_accessApp.Enumerations.AcTextTransferType.acExportDelim #arg.  this does not seem to exist...
            $e_HasFieldNamesYes=-1
            $l_exportSpec = ""
            $l_accessApp.DoCmd.TransferText($e_acExportDelim,$l_exportSpec,$l_queryName,$l_outputFile,$e_HasFieldNamesYes)
            $l_accessApp.CloseCurrentDatabase()
            $Records=import-csv -path $l_outputFile





<#
            $these=$records.where({($_.lastname.trim() -like "Ginsberg") -and ([int]$_.clubage -eq 10)})
            $these=$records.where({[int]$psitem.clubage -eq 10})
            $these=$records.where({$_.lastname -like "*Rovner*"})
            $these |Select-Object @{name="Gender";expression={$_.gender.toupper()}}, lastname, firstname, @{name="Age";expression={[int]$_.clubage}}

 #>

$TimeSplat = @{name = "Time"; expression = {$_.ftime}}
$TimeSplat = @{name = "Time"; expression = {"{0}:{1}.{2}" -f [convert]::toint64($_.time,10).tostring("D6").substring(0,2), [convert]::toint64($_.time,10).tostring("D6").substring(2,2), [convert]::toint64($_.time,10).tostring("D6").substring(4,2)}}
$MeetSplat = @{name = "Meet"; expression = {($_.meet).substring(0, 20)}}
$HeatSplat = @{name = "Heat"; expression = {($_.heat).substring(1)}}
$SwimmerMeetSplat = @{name = "SwimmerMeat"; expression = { + $_Swimmer + " " + ($_.meet).substring(0, 20)}}
$GenderSplat=@{name="G";expression={$_.gender.toupper()}}
$ClubAgeSplat=@{name="Age";expression={[int]$_.clubage}}
$BirthdaySplat=@{name="Birthday";expression= `
{(get-date -date ("{0}-{1:d2}-{2:d2}" -f ($_.birthday).substring(0,4), $_.birthday.substring(4,2),$_.birthday.substring(6,2))).toshortdatestring()}}
$BirthdaySplat=@{name="Birthday";expression= `
{(get-date -uformat "%b-%d-%Y" -date ("{0}-{1}-{2}" -f ($_.birthday).substring(0,4), $_.birthday.substring(4,2),$_.birthday.substring(6,2)))}}
$ReportPath=join-path $pwd -childpath "EligibleForChamps.txt"
<#
# sort for submission to champs
if(test-path $ReportPath) {remove-item $ReportPath}
 "Report Generated on {0} by {1}" -f (get-date).Date.ToShortDateString(), $Copyright | Out-File -FilePath $ReportPath
 "To swim in Champs you must have participated in at least two Division-1 Dual Meets" | Out-File -FilePath $ReportPath -append
($Records).where( {($_.heat -notlike "'U*") -and `
 ($_.swimmer.substring(0, 6) -notin ("Lane 1", "Lane 2", "Lane 3", "Lane 4", "Lane 5", "Lane 6")) -and `
 ($_.Meet -notin ("2018-11-19 Time Trials","2019-01-01 Time Trials 2"))} ) | `
    Sort-Object -Property Gender, "Age Group", Swimmer, Meet -Unique | `
    Format-Table -autosize -groupby "Age Group" -property $GenderSplat,Swimmer, $clubageSplat, $BirthdaySplat, Meet, Event, $TimeSplat, heat | `
    Out-File -FilePath $ReportPath -append
    $Copyright | Out-File -FilePath $ReportPath -Append
 #>

 #For Cathy
 #List the swimmer and the meet they participated in.
 #There is no qualification on the number of meets.
 #sort for cathy - simple: sort by gender
 #Don't include Unoffical Heats
 if(test-path $ReportPath) {remove-item $ReportPath}
 "Report Generated {0} by {1}" -f (get-date), $Copyright | Out-File -FilePath $ReportPath
 "To swim in Champs you must have participated in at least two Division-1 Dual Meets" | Out-File -FilePath $ReportPath -append
($Records).where( {($_.heat -notlike "'U*") -and `
#Don't include overall relay time event
($_.swimmer.substring(0, 6) -notin ("Lane 1", "Lane 2", "Lane 3", "Lane 4", "Lane 5", "Lane 6")) -and `
#Cathy wanted this view - Don't include time trial or crossover meets
#($_.Meet -notin ("2018-11-19 Time Trials","2019-01-01 Time Trials 2","2019-02-03 Freeport"))} ) | `
#Include division dual meets (not crossover)
($_.Meet -in ("2018-12-02 Echo","2018-12-16 Long Beach","2019-01-06 Plainview", "2019-03-16 Syosset"))} ) | `
    #Use sort to find the UNIQUE meets that a swimmer participated in. The event is not important.
    Sort-Object -Property Gender, Swimmer, Meet -Unique | `
    #Format-Table -auto size -groupby Gender -property $GenderSplat, Swimmer, Meet, Event, $TimeSplat, heat, "Age Group", $clubageSplat, $BirthdaySplat | `
    #Format-Table -autosize -groupby Gender -property $GenderSplat, Swimmer, Meet, Event, Heat | `
    Format-Table -autosize -groupby Gender -property $GenderSplat, Swimmer, Meet | `
    Out-File -FilePath .\"EligibleForChamps.txt" -Append
    $Copyright | Out-File -FilePath $ReportPath -Append
    #Out-GridView





$NewRecords=get-content $ReportPath
#https://www.sqlshack.com/reading-file-data-with-powershell/
$newrecords=get-childitem -File -path  * |Sort-Object BaseName |select-object basename, lastwritetime

$tempname=""
$x=""
$7=""
$NewRecords | ForEach-Object {
   if($_.basename -eq $tempname) {
      $count++

   }

}


#****************************************
#Insert Into
($Copyright = "'SwimRiteNow' Copyright 2018 FAJ")

# find all the properties and methods
$l_accessApp = new-object -ComObject access.application
# $l_accessApp | Get-Member
# https://stackoverflow.com/questions/44682487/use-powershell-to-create-queries-in-ms-access

Set-Location $env:onedrive\swimclub\2018

#get the event records for a new meet.
$Records=Import-Excel -path (join-path $pwd -childpath "SyossetEvents.xlsx")

#Insert them into the datebase
"Saturday"
$Database="SwimRiteNowTest.accdb" 
$DatabasePath=join-path $pwd -childpath $Database
$l_dbPath = $DatabasePath
$l_accessApp = new-object -com access.application
$l_accessApp.OpenCurrentDatabase($l_dbPath)
$Records|ForEach-Object {  
#$l_query = "INSERT INTO MeetEvents ( Meet, [Age Group], Event, Swimmer, [Time], Heat ) VALUES ($_.Meet, $_.'Age Group', $_.Event,$_.Swimmer,$_.Time,$_.Heat);"
$l_query = "INSERT INTO MeetEvents ( Meet,  Event, Swimmer, [Time], Heat ) VALUES ($_.Meet,  $_.Event,$_.Swimmer,$_.Time,$_.Heat);"
$l_accessApp.docmd.runsql($l_query)
$l_accessApp.CloseCurrentDatabase()
}
