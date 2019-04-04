<#
PowerShell & Microsoft Word 2016 : 
Opening existing Word Documents using PowerShell.
#>

$word = New-Object -ComObject "Word.Application"
$word.Visible = $true
$myFile = "C:$ENV:HOMEPATH\Documents\TEST.DOCX"
$word.Application.Documents.open($myFile) | Out-Null