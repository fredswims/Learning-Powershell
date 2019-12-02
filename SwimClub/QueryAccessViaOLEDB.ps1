function Test-DBAccess{
Param(
     $fileName = 'C:\Users\freds_000\OneDrive\SwimClub\2019\SwimRiteNowV3.accdb'
)

    $conn = New-Object System.Data.OleDb.OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=$filename;Persist Security Info=False")
    $cmd=$conn.CreateCommand()
    $cmd.CommandText="Select * from roster"
    $conn.open()
    $rdr = $cmd.ExecuteReader()
    $dt = New-Object System.Data.Datatable
    $dt.Load($rdr)
    $dt
}