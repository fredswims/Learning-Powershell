#Doug Fink ExportExcel
# https://www.youtube.com/watch?v=znVu2q11Rp4&feature=em-uploademail

$xlfile=join-path $env:temp "fink.xlsx"
$xlfile="$env:temp\PowershellHour.xlsx"
remove-item $xlfile -ErrorAction ignore
get-process | select-object Company, Name, Handles |Export-Excel $xlfile
invoke-item $xlfile
Read-Host "continue introduce -show"

remove-item $xlfile -ErrorAction ignore
get-process | select-object Company, Name, Handles |Export-Excel $xlfile -show
Read-Host "continue introduce PivotTable and PivotChart"

remove-item $xlfile -ErrorAction ignore
$data=get-process | select-object Company, Name, Handles
$data|export-excel $xlfile -show -IncludePivotTable -IncludePivotChart -PivotRows company -PivotData @{handles="sum"}
Read-Host "continue introduce parameters as a hashtable"

remove-item $xlfile -ErrorAction ignore
$xlParams=@{Show=$true; IncludePivotTable=$true; IncludePivotChart=$true; PivotRows='company'; PivotData=@{handles="sum"}}
$data|Export-Excel $xlfile @xlParams
Read-Host "continue Chart Type PieExploded3D"

remove-item $xlfile -ErrorAction ignore
$data|Export-Excel $xlfile @xlParams -ChartType PieExploded3D
Read-Host "continue No Legend etc "

remove-item $xlfile -ErrorAction ignore
$data|Export-Excel $xlfile @xlParams -ChartType PieExploded3D -NoLegend -ShowCategory -ShowPercent
Read-Host "continue MORE Get Service"

remove-item $xlfile -ErrorAction ignore
$data=Get-Service | select-object Status, Name, DisplayName, StartType
$data|Export-Excel $xlfile -Show -AutoSize
Read-Host "continue Iterate through that with conditional text"

remove-item $xlfile -ErrorAction ignore
$Text1=New-ConditionalText -Text stop
$data|Export-Excel $xlfile -Show -AutoSize -ConditionalText $Text1
Read-Host "more conditional text"

remove-item $xlfile -ErrorAction ignore
$Text2=New-ConditionalText runn -ConditionalTextColor Blue -Backgroundcolor Cyan
$data|Export-Excel $xlfile -Show -AutoSize -ConditionalText $Text1, $Text2
Read-Host "more conditional text"

remove-item $xlfile -ErrorAction ignore
$Text3=New-ConditionalText svc -ConditionalTextColor wheat -Backgroundcolor Green
$data|Export-Excel $xlfile -Show -AutoSize -ConditionalText $Text1, $Text2, $Text3
Read-Host "more conditional format"

remove-item $xlfile -ErrorAction ignore
$data=get-process |where-object Company |select-object Company, Name, PM, Handles, *mem*
$cfmt=New-ConditionalFormattingIconSet -Range "C:C" -ConditionalFormat ThreeIconSet -IconType arrows
$data|Export-Excel $xlfile -Show -AutoSize -ConditionalFormat $cfmt

$data=get-process |where-object Company |select-object -skip 2 -first 7
$data

#more in video.