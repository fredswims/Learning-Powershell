Set-Location $env:onedrive\swimclub\2017
$Database="SwimRiteNow.mdb"
$DatabasePath=join-path $pwd -childpath $Database

$EmailList=@{} #initialize hashtable
$EmailList2=@{} #instead of the powershell custom object.

$strQuery = "SELECT 
 [aqRoster].FirstName ,[aqRoster].[Lastname] ,[aqRoster].[email] 
 FROM [aqRoster] 
 ORDER BY [Lastname] DESC ;"

$strConn = "Provider=Microsoft.Jet.OLEDB.4.0; Data Source=$DatabasePath"
#$strConn = "Provider=Microsoft.ACE.OLEDB.12.0; Data Source=$DatabasePath"
$oConn = New-Object System.Data.OleDb.OleDbConnection $strConn
$oCmd  = New-Object System.Data.OleDb.OleDbCommand($strQuery, $oConn)
$oConn.Open()
$oReader = $oCmd.ExecuteReader()
if ($oReader.HasRows) {
    while ($oReader.Read()){
    $oJumper = New-Object PSObject
    $oJumper | Add-Member NoteProperty FirstName $oReader[0]
    $oJumper | Add-Member NoteProperty LastName  $oReader[1]
    $oJumper | Add-Member NoteProperty email     $oReader[2]
    #$oJumper
    $FullName=$oJumper.FirstName + " " +$oJumper.LastName
    #Build Hash Table  - ha ha don't need the  Powershell custom object!!!
    $FullName2=$oReader[0] + " " + $oReader[1]
    $EmailList.add($fullname,$oJumper.email)
    $EmailList2.add($FullName2,$oReader[2])
    }
}
$oReader.Close()
$oConn.Close()
"The email list has $($EmailList.count) names"
$EmailList
"The email address for $($ojumper.firstname) $($ojumper.lastname) is $($EmailList[$fullname])"
write-host "that's all folks"

