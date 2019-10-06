$testdir = "C:\Users\freds_000\OneDrive\SwimClub\2018"
set-location $testdir
$testfile = "Events.csv"
$outfile = "Output.xlsx"
if (test-path $outfile  ) { remove-item $outfile } else { "$outfile doesn not exist" }
$IMPORT = Import-Csv "$testfile"
$IMPORT | Export-Excel -Path $outfile -Show -FreezeTopRow -BoldTopRow -AutoSize -AutoFilter -WorkSheetname "My Excel" -CellStyleSB {
    # HorizontalAlignment "Center" of columns A-H
    param($WorkSheet)
    $WorkSheet.Cells["A:H"].Style.HorizontalAlignment = "Center"
}
