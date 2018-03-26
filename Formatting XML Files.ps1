function Format-Xml  {
    param($PathXML, $Indent=2, $Destination="$env:temp\out.xml", [switch]$Open)
    $xml = New-Object XML
    $xml.Load($PathXML)
    $StringWriter = New-Object System.IO.StringWriter
    $XmlWriter = New-Object System.XMl.XmlTextWriter $StringWriter
    $xmlWriter.Formatting = "indented"
    $xmlWriter.Indentation = $Indent
    $xml.WriteContentTo($XmlWriter)
    $XmlWriter.Flush()
    $StringWriter.Flush()
    Set-Content -Value ($StringWriter.ToString()) -Path $Destination
    if ($Open) { notepad $Destination }
} 
Format-Xml -PathXML C:\Windows\Ultimate.xml -Open -Indent 1
