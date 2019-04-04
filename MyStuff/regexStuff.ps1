
#https://stackoverflow.com/questions/39983462/use-powershell-to-quickly-search-files-for-regex-and-output-to-csv
#regex stuff regular expressions
#file io 
$ResultsCSV = "C:\TEMP\Results.csv"
$Directory = "C:\TEMP\examples"
$RX = "(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(?:\.|dot|\[dot\]|\[\.\])){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"
$TextFiles = Get-ChildItem $Directory -Include *.txt*,*.csv*,*.rtf*,*.eml*,*.msg*,*.dat*,*.ini*,*.mht* -Recurse
$out = [Text.StringBuilder]

foreach ($FileSearched in $TextFiles) {
    $text = [IO.File]::ReadAllText($FileSearched)
    foreach ($match in ([regex]$RX).Matches($text)) {
        if (!(Test-Path $ResultsCSV)) {
            'Matches,File Path' | Out-File $ResultsCSV -Encoding ASCII
            $out.AppendLine('' + $match.value + ',' + $FileSearched.fullname)
            $match.value | Out-File $ResultsCSV -Encoding ascii -Append
            $FileSearched.Fullname | Out-File $ResultsCSV -Encoding ascii -Append
            $out.ToString() | Out-File $ResultsCSV -Encoding ascii -Append -NoNewline
       }
    }
}




    $ResultsCSV = "C:\TEMP\Results.csv"
    $Directory = "C:\TEMP\examples"
    $RX = "(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(?:\.|dot|\[dot\]|\[\.\])){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"

    $TextFiles = Get-ChildItem $Directory -Include *.txt*,*.csv*,*.rtf*,*.eml*,*.msg*,*.dat*,*.ini*,*.mht* -Recurse

     $file2 =  new-object System.IO.StreamWriter($ResultsCSV) #output Stream
     $file2.WriteLine('Matches,File Path') # write header

    foreach ($FileSearched in $TextFiles) {   #loop over files in folder

        #    $text = [IO.File]::ReadAllText($FileSearched)
        $file = New-Object System.IO.StreamReader ($FileSearched)  # Input Stream

        while ($text = $file.ReadLine()) {      # read line by line
            foreach ($match in ([regex]$RX).Matches($text)) {   
                   # write line to output stream
                   $file2.WriteLine("{0},{1}",$match.Value, $FileSearched.fullname )  
            } #foreach $match
        }#while $file
         $file.close();  
    } #foreach  
    $file2.close()



    foreach ($file in $files) {
        get-content $file | Select-String -Pattern "\d\d\d\d-\d\d-\d\d" -AllMatches
                     }
     $A = Get-ChildItem *.ps1 | Select-String -Pattern "\d\d\d\d-\d\d-\d\d" 
        $b = Get-ChildItem *.ps1 | Select-String -Pattern "\d\d\d\d-\d\d-\d\d FAJ" 
   