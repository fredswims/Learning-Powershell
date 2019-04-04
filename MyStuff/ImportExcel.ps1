#this is all about the module ImportExcel
#On my machine with 500 items in a folder this takes 1.2 seconds
cd ~
Get-ChildItem | Select-Object -Property name,Length,LastWriteTime | export-excel .\foo.xlsx -BoldTopRow -FreezeTopRow -AutoSize -AutoFilter -show
<#
The rate is 1000-2000 cells per second. It will vary a little and obviously with machine speed, but that's the order of magnitute.
This runs in 0.2 seconds
#>

$t = New-Object -TypeName System.Data.DataTable
[void]$t.Columns.Add("Name",[string])
[void]$t.Columns.Add("Length",[int])
[void]$t.Columns.Add("Lastwrite",[datetime])

Get-ChildItem | ForEach-Object {$r = $t.NewRow() ; $r.name=$_.name; $r.length = $_.Length ; $r.lastWrite  = $_.LastWriteTime ; $t.rows.Add($r) }
Send-SQLDataToExcel -DataTable $t -Path .\foo.xlsx -BoldTopRow -FreezeTopRow -AutoSize -AutoFilter -show

#Write fomulas
"c1,c2`r`ntest,=10*3" | convertfrom-csv | export-excel c:\temp\testformula.xlsx -show -ClearSheet

<#
When I do understand your prolbem correct and presuming you have

Excel-Application installed
an xla containing a public macro named "Hello"
your security-settings allow macro execution
the following should work
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $true
$workbook = $excel.Workbooks.Add()
$sheet = $workbook.ActiveSheet
$excel.Run('.\Documents\ExcelWithMacro.xla!Hello')
#>

$big=Import-Excel -path .\foo.xlsx
$big.Count
($big[0].psobject.Properties |Measure-Object).count * $big.Count # number of cells
#alternate?
($big| get-member -MemberType NoteProperty | Measure-Object).count
