#First pass on print the compact pivot tables
#borrowed from
#https://stackoverflow.com/questions/31200130/run-vba-macro-in-excel-sheet-using-external-c-sharp-console-application
#and
#
<# $XlsxFile = "$Path\date.xlsx"
$HtmlFile = $XlsxFile -replace '\.xlsx$', '.html'

#Add-Type -AssemblyName "C:\Program Files\Microsoft Office\root\Office16\ADDINS\Microsoft Power Query for Excel Integrated\bin\Microsoft.Office.Interop.Excel.dll"
#[int][Microsoft.Office.Interop.Excel.XlFileFormat]::xlHtml # 44
$xlFixedFormat = 44

$Excel = New-Object -ComObject "Excel.Application"
$null = $Excel.Workbooks.Open($XlsxFile)
$Excel.ActiveWorkbook.SaveAs($HtmlFile, $xlFixedFormat)
$Excel.ActiveWorkbook.Close()
$Excel.Quit()
#>

#v1 FAJ 2019-10-18

set-location $env:OneDrive/swimclub/2019/Reports
remove-item "*compact*.old"
$HtmlPath="BoysBestCompact.html"
rename-item -force -Path $HtmlPath -NewName "$($HtmlPath).old"
$HtmlPath="GirlsBestCompact.html"
rename-item -force -Path $HtmlPath -NewName "$($HtmlPath).old"

set-location $env:OneDrive/swimclub/2019
$Dir=Get-Location
$Xlfile="SwimRiteNow.xlsm"

$objExcel=new-object -ComObject Excel.Application
#$objExcel.Visible=$true
$workbook=$objExcel.Workbooks.Open($(Join-Path $dir $xlfile))
#$null=$objExcel.Workbooks.Open($(Join-Path $dir $xlfile))
#$worksheet=$workbook.Worksheets.Item('Boys')
#$worksheet.Activate()
#$objExcel.Run("HiLite")
$objExcel.Run("SavePivotTableAsHtml")
    #$workbook.save()
$workbook.Close(0) #without this line you get SAVE pop-up.
    #$objExcel.Save()
$objExcel.quit()
$objExcel=$null

Start-Sleep -seconds 5
($thisTaskId =get-process excel)
stop-process $thisTaskId

push-location $env:OneDrive/swimclub/2019/Reports
Get-ChildItem "*compact*"