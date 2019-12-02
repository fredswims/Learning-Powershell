Function GetDataFromAccess ($l_queryName)  {
    $thisVersion = "2019-03-19.0"
    get-process *access* | stop-process
    $Copyright = "'SwimRiteNow' Copyright 2018 FAJ"
    # find all the properties and methods
    #$l_accessApp = new-object -ComObject access.application
    #$l_accessApp | Get-Member
    # https://stackoverflow.com/questions/44682487/use-powershell-to-create-queries-in-ms-access

    Set-Location $env:onedrive\swimclub\2019
    $Database = "SwimRiteNowV3.accdb"
    $DatabasePath = join-path $pwd -childpath $Database
    $l_outputFile = join-path $pwd -childpath "output.csv"


    $l_dbPath = $DatabasePath
    $l_accessApp = new-object -com access.application
    $l_accessApp.OpenCurrentDatabase($l_dbPath)
    <#

    $l_query = "SELECT Roster.FirstName,Lastname,clubage From Roster ;"  Step 1 write a query (easier to build these in MSAccess.)
    $l_queryName ="FredsTestQuery"                                      Step 2 give the query a name
    $l_accessApp.CurrentDB().CreateQueryDef($l_queryName, $l_query)     Step 3 Create the named-query in the database
                                                                        Run the named query, either just created or already in the database (see Do.Cmd)
 #>

    # $l_queryName = "aqMeetEvents"
    #$l_queryName = "aqRoster"
    # $l_queryName ="FredsTestQuery"

    # use this to create a named-query
    #$l_accessApp.CurrentDB().CreateQueryDef($l_queryName, $l_query)

    # Get rid of file created from previous DoCmd.
    if (test-path $l_outputFile) { remove-item $l_outputFile }

    $e_acExportDelim = 2 #$l_accessApp.Enumerations.AcTextTransferType.acExportDelim #arg.  this does not seem to exist...
    $e_HasFieldNamesYes = -1
    $l_exportSpec = ""

    # Execute the named-query; data will be written to $l_outputFile in CVS format.
    $l_accessApp.DoCmd.TransferText($e_acExportDelim, $l_exportSpec, $l_queryName, $l_outputFile, $e_HasFieldNamesYes)
    $l_accessApp=$null
    get-process *access* | stop-process

    $TheseRecords = import-csv -path $l_outputFile
    $TheseRecords
}

$Roster=GetDataFromAccess "aqRoster"
"$($Roster.count) Roster records returned from the database"
#
# GoogleGroupMembers
#In Google Groups export the members to a .csv file and convert it to an .xlsx file.
$GoogleGroupTemp=import-excel -path .\hewlettswimclubGoogleGroup.xlsx -StartRow 1 -StartColumn 1 -EndColumn 2
# Clean-up data on the Laurie spreadsheet; trim spaces and middle names.
<# $FirstNameSplat=@{name='FirstName'; expression={$psitem.'first name'}}
$LastNameSplat=@{name='LastName'; expression={$psitem.'last name'}}
$FirstLastNameSplat = @{name = "FirstLastName";`
    expression = {if ($psitem."first name".trim().IndexOf(" ") -gt 0)`
    {$psitem.'First Name'.trim().Substring(0,($psitem.'first name'.trim().indexof(" "))) + $psitem."last name".trim()}`
    else {$psitem."first name".trim()+$psitem."last name".trim()}}    }
 #>
 $GoogleGroup=$GoogleGroupTemp
# Clean-up the data in the spreadsheet.
$FirstLastNameSplat=@{name = "FirstLastName";`
    expression = {if ($psitem."firstname".trim().IndexOf(" ") -gt 0)`
    {$psitem.'FirstName'.trim().Substring(0,($psitem.'firstname'.trim().indexof(" "))) + $psitem."lastname".trim()}`
    else {$psitem."firstname".trim()+$psitem."lastname".trim()}}    }

#Create Arrays
$GoogleGroupArray=foreach($item in $GoogleGroup){$item.nickname}
$RosterArray=foreach($item in $Roster) {$item."firstname"+" "+$item."lastname"}
if ($RosterArray.count -eq $Roster.count -and $Roster.count -gt 0){"There are {0} Roster items" -f $RosterArray.count} else {Write-error -message "Problem with Record data"}

#Find people in the Google Group who aren't on the swimteam this year.
"**********************************************"
$RemovePath="RemoveMeFromGoogleGroup.txt"
if (Test-Path -path $RemovePath){remove-item $RemovePath}
out-file -filepath $RemovePath -InputObject ""
foreach ($longName in $GoogleGroupArray){
    $flag=0
    write-host "$Longname ------------------------------------"
    Foreach ($fullname in $RosterArray){
        if ($longname -like "*$fullname*"){$flag=$flag+1;write-host "     $longname found in roster with match to  $fullname"} 
    }
    if ($flag -eq 0){"??????????????$Longname"}
    if ($flag -eq 0){out-file -filepath "$RemovePath" -append  -InputObject $Longname}
    
}
#After the people (above) are removed from the Google Group, 
#check the remaining email address are correct using the Roster as the input reference.
#Validate email address in the Google Group.
$email=$roster.email
$email.count
$email2=$roster.email2 |Where-Object {$psitem -ne ""}
$email2.Count
$email+=$email2
$email.count
"**********************************************"
$RemovePath="emailIsBad.txt"
if (Test-Path -path $RemovePath){remove-item $RemovePath}
out-file -filepath $RemovePath -InputObject ""
foreach ($GoogleEmailAdr in $GoogleGroup."email address"){
    $flag=0
    write-host "$GoogleEmailAdr ------------------------------------"
    Foreach ($RosterEmail in $email){
        if ($GoogleEmailAdr -like "*$RosterEmail*"){$flag=$flag+1;write-host "     $GoogleEmailAdr found in roster with match to  $RosterEmail"} 
    }
    if ($flag -eq 0){"??????????????$GoogleEmailAdr"}
    if ($flag -eq 0){out-file -filepath "$RemovePath" -append  -InputObject $GoogleEmailAdr}
    
}