<#
Invoke the procedures in Excel that
generate Best Time html files from the compact version of the pivot tables,
and generate Rank Reports as html and pdf files.

Borrowed from
https://stackoverflow.com/questions/31200130/run-vba-macro-in-excel-sheet-using-external-c-sharp-console-application
#>
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

<#
v1  FAJ 2019-10-18
    Create Best Times as HTML Reports
    Do some clean-up
    Invoke Procedures in SwimRiteNow excel spreadsheet.
v1.1 FAJ 2019-12-09
    Add Rank reports
    Create Rank as PDF and HTML reports
V1.2 FAJ 2019-12-09
    Rank and HTML reports consolidated in Excel into one module; RankReports
V1.2.1 FAJ 2020-01-06
    Added output showing progression of script
V1.2.2 FAJ 2020-01-08
    Removed housekeeping. All the reports are overridden.
    Changed report names;
    BoysBestTimes, BoysBestTimesCompact
    The Excel procedures begin with Publish
#>
$ErrorActionPreference = "Stop"
"Shutdown Adobe Pdf reader"
get-process AcroRd* | Sort-Object name | stop-process
Start-Sleep -Seconds 2

set-location $env:OneDrive/swimclub/2019/Reports -verbose

"Housekeeping before creating Boys and Girls Best Times as HTML reports"
#remove-item -verbose "*Best*.old"
<#
$HtmlPath="BoysBestTimeCompact.html"
rename-item -force -verbose -Path $HtmlPath -NewName "$($HtmlPath).old"
$HtmlPath="BoysBestTime.html"
rename-item -force -verbose -Path $HtmlPath -NewName "$($HtmlPath).old"



$HtmlPath="GirlsBestTimeCompact.html"
rename-item -force -verbose -Path $HtmlPath -NewName "$($HtmlPath).old"
$HtmlPath="GirlsBestTime.html"
rename-item -force -verbose -Path $HtmlPath -NewName "$($HtmlPath).old"

"Housekeeping before creating Boys and Girls Rank as PDF and HTML reports"
remove-item -verbose "*Rank*.old"
$PdfPath="BoysRank.pdf"
rename-item -force -verbose -Path $PdfPath -NewName "$($PdfPath).old"
$PdfPath="GirlsRank.pdf"
rename-item -force -verbose -Path $PdfPath -NewName "$($PdfPath).old"

$HtmlPath="BoysRank.html"
rename-item -force -verbose -Path $HtmlPath -NewName "$($HtmlPath).old"
$HtmlPath="GirlsRank.html"
rename-item -force -verbose -Path $HtmlPath -NewName "$($HtmlPath).old"
#>
"Create the excel object"
set-location $env:OneDrive/swimclub/2019 -verbose
$Dir=Get-Location
$Xlfile="SwimRiteNow.xlsm"
$objExcel=new-object -ComObject Excel.Application
#$objExcel.Visible=$true
$workbook=$objExcel.Workbooks.Open($(Join-Path $dir $xlfile))
#$null=$objExcel.Workbooks.Open($(Join-Path $dir $xlfile))
#$worksheet=$workbook.Worksheets.Item('Boys')
#$worksheet.Activate()
#$objExcel.Run("HiLite")
"Publish Best Times Reports as html and pdf files."
# these procedures are in the HighLitePivotTable Module of SwimRiteNow.xlsm
$objExcel.Run("PublishBestTimeReports")
"Publish Rank Reports as pdf and html files."
$objExcel.Run("PublishRankReports")
#$objExcel.Run("RankReportPdfGirls")
#$objExcel.Run("RankReportPdfBoys")
"Housekeeping - Destroy the excel object."
    #$workbook.save()
$workbook.Close(0) #without this line you get SAVE pop-up.
    #$objExcel.Save()
$objExcel.quit()
$objExcel=$null

Start-Sleep -seconds 5
($thisTaskId =get-process excel)
stop-process $thisTaskId

"Show renamed and created files"
push-location $env:OneDrive/swimclub/2019/Reports
Get-ChildItem "*BestTimes*" |sort-object -property  LastWriteTime | format-table -property  LastWriteTime, Name -AutoSize
Get-ChildItem "*Rank*" |sort-object -property  LastWriteTime | format-table -property  LastWriteTime, Name -AutoSize

# "*.html", "*.pdf" | Get-ChildItem |Sort-Object -property LastWriteTime