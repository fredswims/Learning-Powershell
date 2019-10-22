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
# Collect all of Laurie's files.
$laurieTemp=import-excel -path .\registration\2019-10-18NewFemales.xlsx -StartRow 2 -StartColumn 1 -EndColumn 2
$laurieTemp+=import-excel -path .\registration\2019-10-18NewMales.xlsx -StartRow 2 -StartColumn 1 -EndColumn 2
$laurieTemp+=import-excel -path .\registration\2019-10-18ReturningFeMales.xlsx -StartRow 2 -StartColumn 1 -EndColumn 2
$laurieTemp+=import-excel -path .\registration\2019-10-18ReturningMales.xlsx -StartRow 2 -StartColumn 1 -EndColumn 2
# Clean-up data on the Laurie spreadsheet; trim spaces and middle names.
$FirstNameSplat=@{name='FirstName'; expression={$psitem.'first name'}}
$LastNameSplat=@{name='LastName'; expression={$psitem.'last name'}}
$FirstLastNameSplat = @{name = "FirstLastName";`
    expression = {if ($psitem."first name".trim().IndexOf(" ") -gt 0)`
    {$psitem.'First Name'.trim().Substring(0,($psitem.'first name'.trim().indexof(" "))) + $psitem."last name".trim()}`
    else {$psitem."first name".trim()+$psitem."last name".trim()}}    }

$Laurie=$laurieTemp |Select-Object -property $FirstNameSplat,$LastNameSplat,$FirstLastNameSplat
# People who claimed they signed-up
$OnlineTemp=import-excel -path .\registration\2019-10-20OnlineResponses.xlsx -StartRow 1 -StartColumn 1 -EndColumn 2
# Clean-up the data in the spreadsheet.
$FirstLastNameSplat=@{name = "FirstLastName";`
    expression = {if ($psitem."firstname".trim().IndexOf(" ") -gt 0)`
    {$psitem.'FirstName'.trim().Substring(0,($psitem.'firstname'.trim().indexof(" "))) + $psitem."lastname".trim()}`
    else {$psitem."firstname".trim()+$psitem."lastname".trim()}}    }
$OnLine=$onlineTemp|select-object -property firstname,LastName,$FirstLastNameSplat

#Create Arrays
$LaurieArray=foreach($item in $Laurie){$item.FirstLastName}
if ($LaurieArray.count -eq $laurie.count -and $laurie.count -gt 0){"There are {0} Laurie items" -f $LaurieArray.count} else {Write-error -message "Problem with Laurie data"}

$RosterArray=foreach($item in $Roster) {$item."firstname"+$item."lastname"}
if ($RosterArray.count -eq $Roster.count -and $Roster.count -gt 0){"There are {0} Roster items" -f $RosterArray.count} else {Write-error -message "Problem with Record data"}

$OnlineArray=foreach($item in $Online) {$item.FirstLastName}
if ($OnlineArray.count -eq $Online.count -and $Online.count -gt 0){"There are {0} Online items" -f $OnlineArray.count} else {Write-error -message "Problem with Online data"}

#Analysis of data
#Are there names in the Laurie list that are not in the Roster'
#because they were not put in the Roster or are misspelled.'
$NotInRoster=$LaurieArray|Where-Object {($psitem) -notin $RosterArray}
if ($NotInRoster.count -gt 0) {foreach ($item in $NotInRoster){write-host -ForegroundColor  yellow  "This person is in Lauries list but not in the Roster-> $($item) <-"}}else {"All names in Laurie's list are in the Roster"}

'***** Are there members in the roster ($Roster) who are not on the Laurie list? *****'
$Roster|Where-Object {($psitem.firstname+$psitem.lastname) -notin $laurieArray}|Select-Object firstname, lastname

'***** people who said they signed up but are not on Laurie list *****'
#$online|Where-Object {($psitem.firstname+$psitem.lastname) -notin $laurieArray}|Select-Object firstname, lastname|Sort-Object -Unique -property lastname
$OnlineArray|Where-Object {($psitem) -notin $laurieArray}|Sort-Object -Unique
