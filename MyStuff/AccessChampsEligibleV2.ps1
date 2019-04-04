$Version="2019-03-28.1"
"Version $Version"
"add to remote repository."

#Added code in MakeObjects to flip the event to the heat.
#This occurs in freestyle relays were the swimmer was leg 1
#and medley relays were the swimmer was leg 1 or leg 4.
#get-process *access* | stop-process
($Copyright = "'SwimRiteNow' Copyright 2018 FAJ")
# find all the properties and methods
#$l_accessApp = new-object -ComObject access.application
#$l_accessApp | Get-Member
# https://stackoverflow.com/questions/44682487/use-powershell-to-create-queries-in-ms-access

Set-Location $env:onedrive\swimclub\2018
$Database = "SwimRiteNowv3.accdb"
$DatabasePath = join-path $pwd -childpath $Database
$l_outputFile = join-path $pwd -childpath "output.csv"

$l_dbPath = $DatabasePath
$l_accessApp = new-object -com access.application
$l_accessApp.OpenCurrentDatabase($l_dbPath)
if ($? -eq $true) {Write-warning "Database Opened"} else {write-warning "Could not open database! Exiting";exit}
#$l_query = "SELECT Roster.FirstName,Lastname From Roster;"
$l_queryName = "aqMeetEvents"
#$l_accessApp.CurrentDB().CreateQueryDef($l_queryName, $l_query)

if (test-path $l_outputFile) {remove-item $l_outputFile }
#$l_outputFile = join-path $pwd -childpath "output.csv"
$e_acExportDelim = 2 #$l_accessApp.Enumerations.AcTextTransferType.acExportDelim #arg.  this does not seem to exist...
$e_HasFieldNamesYes = -1
$l_exportSpec = ""
$l_accessApp.DoCmd.TransferText($e_acExportDelim, $l_exportSpec, $l_queryName, $l_outputFile, $e_HasFieldNamesYes)
$l_accessApp.CloseCurrentDatabase()
    $StopList = get-process | where-object {$_.mainwindowtitle -eq "" -and $_.ProcessName -eq "MsAccess"}
    if ($StopList.count -gt 0) {
        $WarningString = "Killing {0} background database process(es)" -f $StopList.count
        write-warning $WarningString
        $StopList | stop-process
    }
$Records=$null
$Records = import-csv -path $l_outputFile
$WarningString ="Extracted {0} records from the database" -f $records.Count
if ($Records.Count -eq 0) {Write-Warning "Exiting";exit}

<#
            $these=$records.where({($_.lastname.trim() -like "Ginsberg") -and ([int]$_.clubage -eq 10)})
            $these=$records.where({[int]$psitem.clubage -eq 10})
            $these=$records.where({$_.lastname -like "*Rovner*"})
            $these |Select-Object @{name="Gender";expression={$_.gender.toupper()}}, lastname, firstname, @{name="Age";expression={[int]$_.clubage}}

 #>
# We need these splats
$TimeSplat = @{name = "Time"; expression = {$_.ftime}}
#On the database Time (ftime) is text
#Convert it to mm:ss.dd
$TimeSplat = @{name = "Time"; expression = {"{0}:{1}.{2}" -f `
    [convert]::toint64($_.time, 10).tostring("D6").substring(0, 2), `
    [convert]::toint64($_.time, 10).tostring("D6").substring(2, 2), `
    [convert]::toint64($_.time, 10).tostring("D6").substring(4, 2)}
}
$MeetSplat = @{name = "Meet"; expression = {($_.meet).substring(0, 20)}}
$HeatSplat = @{name = "Heat"; expression = {($_.heat).substring(1)}}
$SwimmerMeetSplat = @{name = "SwimmerMeat"; expression = { + $_Swimmer + " " + ($_.meet).substring(0, 20)}}
$GenderSplat = @{name = "G"; expression = {$_.gender.toupper()}}
$ClubAgeSplat = @{name = "Age"; expression = {[int]$_.clubage}}
$BirthdaySplat = @{name = "Birthday"; expression = `
    {(get-date -date ("{0}-{1:d2}-{2:d2}" -f `
        $_.birthday.substring(0, 4), `
        $_.birthday.substring(4, 2), `
        $_.birthday.substring(6, 2))).toshortdatestring()
    }
}
$BirthdaySplat = @{name = "Birthday"; expression = `
    {get-date -uformat "%m-%d-%y" -date ("{0}-{1}-{2}" -f `
        $_.birthday.substring(0, 4), `
        $_.birthday.substring(4, 2), `
        $_.birthday.substring(6, 2))
    }
}

$ReportPath = join-path $pwd -childpath "EligibleForChamps.txt"
<#
# sort for submission to champs
if(test-path $ReportPath) {remove-item $ReportPath}
 "Report Generated on {0} by {1}" -f (get-date).Date.ToShortDateString(), $Copyright | Out-File -FilePath $ReportPath
 "To swim in Champs you must have participated in at least two Division-1 Dual Meets" | Out-File -FilePath $ReportPath -append
($Records).where( {($_.heat -notlike "'U*") -and `
 ($_.swimmer.substring(0, 6) -notin ("Lane 1", "Lane 2", "Lane 3", "Lane 4", "Lane 5", "Lane 6")) -and `
 ($_.Meet -notin ("2018-11-19 Time Trials","2019-01-01 Time Trials 2"))} ) | `
    Sort-Object -Property Gender, "Age Group", Swimmer, Meet -Unique
    Format-Table -autosize -groupby "Age Group" -property $GenderSplat,Swimmer, $clubageSplat, $BirthdaySplat, Meet, Event, $TimeSplat, heat | `
    Out-File -FilePath $ReportPath -append
    $Copyright | Out-File -FilePath $ReportPath -Append
 #>

#For Cathy
#List the swimmer and the meet they participated in.
#There is no qualification on the number of meets.
#sort for cathy - simple: sort by gender
#Don't include Unoffical Heats
if (test-path $ReportPath) {remove-item $ReportPath}
"Report Generated {0} by {1}" -f (get-date), $Copyright | Out-File -FilePath $ReportPath
"To swim in Champs you must have participated in at least two Division-1 Dual Meets" | Out-File -FilePath $ReportPath -append
$AllSwimmers = ($Records).where( {($_.heat -notlike "'U*") -and `
#Don't include unofficial heats except line 5 in an office heat. - removed! 2018-03-28
#Don't include overall relay time event
    ($_.swimmer.substring(0, 6) -notin ("Lane 1", "Lane 2", "Lane 3", "Lane 4", "Lane 5", "Lane 6") ) -and `
            #Cathy wanted this view - Don't include time trial or crossover meets
        #($_.Meet -notin ("2018-11-19 Time Trials","2019-01-01 Time Trials 2","2019-02-03 Freeport"))} ) | `
        #Include division dual meets (not crossover)
        ($_.Meet -in ("2018-12-02 Echo", "2018-12-16 Long Beach", "2019-01-06 Plainview", "2019-03-16 Syosset"))} ) | `
    #Use sort to find the UNIQUE meets that a swimmer participated in. The event is not important.
#Cathy Sort
#Sort-Object -Property Gender, Swimmer, Meet -Unique | `
    #George Sort (GroupCode, ClubAge)
Sort-Object -Property Gender, GroupCode, LastName, FirstName, Meet -Unique | `
Select-Object -property $GenderSplat, Swimmer, $clubageSplat, $BirthdaySplat, Meet, Event, $TimeSplat, heat, FirstName, LastName


#Format-Table -auto size -groupby Gender -property $GenderSplat, Swimmer, Meet, Event, $TimeSplat, heat, "Age Group", $clubageSplat, $BirthdaySplat | `
#Format-Table -autosize -groupby Gender -property $GenderSplat, Swimmer, Meet, Event, Heat | `
#Format-Table -autosize -groupby Gender -property $GenderSplat, Swimmer, Meet | `
#Add one more swimmer and change his name - used to push last swimmer out (I could use $AllSwimmers.count)
#*****************************************************************
function MakeObjects {
    Param ($Inputx)
$MyFunctionName="MakeObjects"
Write-Warning "Function $MyFunctionName is beginning."
$InputxCount = $Inputx.count
$Inputx | ForEach-Object `
    -begin {
        $EligibleCount = 0 #elibible swimmer count
        $LoopCount=0
        $MeetCount = 0 #number of meets for this swimmer
        $FlipCount=0 #number of Events changed to event number embedded in Heat
        $thisSwimmer = ""
        $thisFirstName = ""
        $thisLastName = ""
        $thisMeets = @()
        $thisEvents = @() #this should come from Heat - the heat represents the actuall event swam. In certain cases it differs from the Event.
        $thisHeats = @()
        $thisGenderSplat = ""
        $thisClubagesplat = ""
        $thisBirthdaySplat = ""
    } `
    -process { `
        $LoopCount++

        if ($_.Swimmer -eq $thisSwimmer) {
            #Already initialized this swimmer. Just need info about this event, this meet.
            $MeetCount++
            $thismeets += $_.Meet.substring(11)
            $thisEvents += $_.Event.substring(0, $_.Event.indexof("-")).replace("r","")
            $thisHeats += $_.Heat
        } #end  if same swimmer
        #Look for different swimmer or the last object in the INPUT collection.
        if ($_.Swimmer -ne $thisSwimmer -or $LoopCount -eq $InputxCount) {
            if ($MeetCount -ge 2 ) {
                $EligibleCount++
                #Swimmer participated in enough meets
                #Cathy Format
                #"{0,-25} Sex:{6} Age:{7,-2} {8} Meets:{5} {1,-12}  {2,-12}  {3,-12}  {4,-12}"                            -f $thisSwimmer, $thismeets[0], $thismeets[1], $thismeets[2], $thismeets[3], $MeetCount, $thisGenderSplat, $thisClubagesplat, $thisBirthdaySplat,$thisEvents[0],$thisEvents[1],$thisEvents[2],$thisEvents[3],$thisfirstname, $thislastname
                #"{0,-25} Sex:{6} Age:{7,-2} {8} Meets:{5} {1,-12} {9} {2,-12} {10} {3,-12} {11} {4,-12} {12}"                            -f $thisSwimmer, $thismeets[0], $thismeets[1], $thismeets[2], $thismeets[3], $MeetCount, $thisGenderSplat, $thisClubagesplat, $thisBirthdaySplat,$thisEvents[0],$thisEvents[1],$thisEvents[2],$thisEvents[3],$thisfirstname, $thislastname
                #George Format
                #"Sex:{6} Age:{7,-2} {8} {14,-15} {13,-15} Meets:{5} {1,-12} {9} {2,-12} {10} {3,-12} {11} {4,-12} {12}" -f $thisSwimmer, $thismeets[0], $thismeets[1], $thismeets[2], $thismeets[3], $MeetCount, $thisGenderSplat, $thisClubagesplat, $thisBirthdaySplat, $thisEvents[0],$thisEvents[1],$thisEvents[2],$thisEvents[3],$thisfirstname,$thislastname
                #create one object per line written
                #Map the correct event (carried in Heat) into the Event
                for ($index=0; $index -lt $thisEvents.count; $index++) {
                    if ( $thisHeats[$index].substring(1,1) -eq '#' -and $thisEvents[$index] -ne $thisHeats[$index].substring(1,3) ){
                        #Read-Host "Got one"
                        $thisHold=$thisEvents[$index]
                        $thisEvents[$index] =$thisHeats[$index].substring(1,3)
                        $FlipCount++
                        $thisWarning="<{0}> flipped {1} to {2} heat was {3}" -f $flipcount, $thisHold, $thisEvents[$index], $thisHeats[$index]
                        Write-warning -message "$thiswarning"
                    }
                }

                $NewRow=[ordered]@{}
                $NewRow["#"]=$EligibleCount
                $NewRow["Sex"]=$thisGenderSplat
                $NewRow["Age"]=$thisClubagesplat
                $NewRow["BDay"]=$thisBirthdaySplat
                $NewRow["Last Name"]=$thislastname
                $NewRow["First Name"]=$thisFirstname
                $NewRow["Meet 1"]=$thismeets[0]
                $NewRow["Event 1"]=$thisEvents[0]
                #$NewRow["Heat 1"]=$thisHeats[0]
                $NewRow["Meet 2"]=$thismeets[1]
                $NewRow["Event 2"]=$thisEvents[1]
                #$NewRow["Heat 2"]=$thisHeats[1]
                $NewRow["Meet 3"]=$thismeets[2]
                $NewRow["Event 3"]=$thisEvents[2]
                #$NewRow["Heat 3"]=$thisHeats[2]
                $NewRow["Meet 4"]=$thismeets[3]
                $NewRow["Event 4"]=$thisEvents[3]
                #$NewRow["Heat 4"]=$thisHeats[3]

                [PSCustomObject]$NewRow
                #Write-Warning "object added to collection"
            }
            else {
                #didn't participate in enough meets
                #"skipping $thisSwimmer"
            }
        }
        if ($_.Swimmer -ne $thisSwimmer) {
            #initialize new swimmer (this $_.)
            #also falls here for the first swimmer
            $MeetCount = 1
            $thisSwimmer = $_.Swimmer
            $thisFirstName = $_.FirstName
            $thisLastName = $_.LastName
            $thisMeets = @()
            $thismeets += $_.Meet.substring(11)
            $thisEvents = @()
            $thisEvents += $_.Event.substring(0, $_.Event.indexof("-")).replace("r","")
            #$thisEvents +=
            $thisHeats = @()
            $thisHeats += $_.Heat
            $thisGenderSplat = $_.G
            $thisClubagesplat = $_.age
            $thisBirthdaySplat = $_.Birthday
        }
    # end of PROCESS block
    } `
    -end {
        write-warning " $MyFunctionName returning $EligibleCount objects."
    }
Write-Warning "Function $MyFunctionName is ending"
}#process block

$ExcelPath = join-path $pwd -childpath "ChampsRosterxx.xlsx"
if(test-path $excelpath) {remove-item $excelpath}
$EligibleOnes=MakeObjects ($allswimmers)
$WarningString="{0} swimmers are eligible for the championship meet." -f $EligibleOnes.count
write-warning "$WarningString"
Write-Warning "Calling Export-Excel"
$EligibleOnes | export-excel -ClearSheet -show  -path $excelpath #this will open an existing spreadsheet and wipe out the date on this sheet but keep all the formatting.
<#

    Out-File -FilePath .\"EligibleForChamps.txt" -Append
    $Copyright | Out-File -FilePath $ReportPath -Append
    #Out-GridView

notepad $ReportPath



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
#>





$records=import-excel .\SwimRiteNow.xlsm -WorksheetName BoysPlainview -EndColumn 14