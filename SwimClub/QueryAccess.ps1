Function GetDataFromAccess {
    ($thisVersion = "2019-03-19.0")
    get-process *access* | stop-process
    ($Copyright = "'SwimRiteNow' Copyright 2018 FAJ")
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
    $l_queryName = "aqRoster"
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
    $l_accessApp.CloseCurrentDatabase()
    get-process *access* | stop-process

    $Records = import-csv -path $l_outputFile 
}