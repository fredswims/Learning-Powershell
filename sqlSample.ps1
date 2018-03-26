<#
Get the email addresses from othe Access Data Base
https://blogs.technet.microsoft.com/heyscriptingguy/2009/08/13/hey-scripting-guy-can-i-query-a-microsoft-access-database-with-a-windows-powershell-script/
https://technet.microsoft.com/en-us/library/2009.05.scriptingguys.aspx
#>

Set-Location $env:onedrive\swimclub\2017

$strQuery = "SELECT
 [aqRoster].FirstName ,[aqRoster].[Lastname] ,[aqRoster].[email] 
 FROM [aqRoster] 
 ORDER BY [Lastname] DESC ;"

$strConn = "Provider=Microsoft.Jet.OLEDB.4.0; Data Source=SwimRiteNow.accdb"
#$strConn = "Provider=Microsoft.ACE.OLEDB.12.0; Data Source=SwimRiteNow.accdb"
$oConn = New-Object System.Data.OleDb.OleDbConnection $strConn
$oCmd  = New-Object System.Data.OleDb.OleDbCommand($strQuery, $oConn)
$oConn.Open()
$oReader = $oCmd.ExecuteReader()
[void]$oReader.Read()
    $oJumper = New-Object PSObject
    $oJumper | Add-Member NoteProperty FirstName     $oReader[0]
    $oJumper | Add-Member NoteProperty LastName  $oReader[1]
    $oJumper | Add-Member NoteProperty email    $oReader[2]
    $oJumper
$oReader.Close()
$oConn.Close()




$path = "SwimRiteNow.accdb"
$adOpenStatic = 3
$adLockOptimistic = 3

$cn = new-object -comobject ADODB.Connection
$rs = new-object -comobject ADODB.Recordset

$cn.Open("Provider = Microsoft.Jet.OLEDB.4.0;Data Source = SwimRiteNow.accdb")
$rs.Open("SELECT TOP 1 [aqRoster].[FirstName], 
  [aqRoster].[lastname], [aqRoster].[email] 
  FROM [aqRoster]
  ORDER BY [aqRoster].[LastName]", 
  $cn, $adOpenStatic, $adLockOptimistic)

$rs.MoveFirst()
Write-host "The winner will likely be " $rs.Fields.Item("FirstName").Value