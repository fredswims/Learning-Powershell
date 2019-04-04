$template=@'
{Name*:George Washington}, {[int]TermStart:1789}-{[int]TermEnd:1797}
{Name*:William Henry Harrison}, {TermStart:1841} 
'@

((Invoke-WebRequest "http://www.ipl.org/div/potus/").AllElements | 
    Where {$_.class -eq 'potus75Width'}).outertext | 
    ConvertFrom-String -TemplateContent $template |
    foreach {
        $_ | Add-Member -PassThru -MemberType ScriptProperty -Name TotalYears `
            -Value {
                if($this.TermEnd) {
                    $this.TermEnd-$this.TermStart
                }
            }
    }$


Path[1]:   
 $fred="http://www.dmr-marc.net/cgi-bin/trbo-database/datadump.cgi?table=users&format=csv"
   $html=(Invoke-WebRequest $fred).AllElements
   ConvertFrom-String -PropertyNames Radio ID,Callsign,Name,City,State,Country,Home Repeater,Remarks
   $html[3] | convertfrom-string -PropertyNames Radio ID,Callsign,Name,City,State,Country,Home Repeater,Remar
    $html = ((Invoke-WebRequest $fred).AllElements | Where {$_.tagname -eq 'tbody'}).innerhtml
    ((Invoke-WebRequest $fred).AllElements | Where {$_.tagname -eq 'tbody'}).innerhtml | set-content html.txt
    ConvertFrom-String -PropertyNames Radio ID,Callsign,Name,City,State,Country,Home Repeater,Remarks
convertfrom-string -inputObject "C:\Users\freds_000\fhtml.txt" -delimiter "," 

"7302042, CA2ACE, ErcioBarraza, LaSerena, Elqui, Chile, CE2LS, Portable" | convertfrom-string -Delimiter ","
get-content fhtml.txt  | ConvertFrom-String -Delimiter "," -PropertyNames Radio ID,Callsign,Name,City,State,Country,HomeRepeater,Remarks

get-content fhtml.txt | ConvertFrom-String -Delimiter "," -PropertyNames RadioID,Callsign,Name,City,State,Country,HomeRepeater,Remarks | where {$_.HomeRepeater -eq "W2VL"} | ft

get-content fhtml.txt -filter "W2VL"| ConvertFrom-String -Delimiter "," -PropertyNames RadioID,Callsign,Name,City,State,Country,HomeRepeater,Remarks | where {$_.HomeRepeater -eq "W2VL"} | ft

select-string -path fhtml.txt -pattern "W2VL"|forEach-Object {$_.Line} | ConvertFrom-String -Delimiter "," -PropertyNames RadioID,Callsign,Name,City,State,Country,HomeRepeater,Remarks | where {$_.HomeRepeater -eq "W2VL"} | ft
select-string -path fhtml.txt -pattern "W2VL" | forEach-Object {$_.Line}
select-string -path fhtml.txt -pattern "United States"|forEach-Object {$_.Line} | ConvertFrom-String -Delimiter "," -PropertyNames RadioID,Callsign,Name,City,State,Country,HomeRepeater,Remarks | where {$_.HomeRepeater -eq "W2VL"} | ft -AutoSize

select-string -path ffhtml.txt -pattern "New York"|forEach-Object {$_.Line} | ConvertFrom-String -Delimiter "," -PropertyNames RadioID,Callsign,Name,City,State,Country,HomeRepeater,Remarks | ft -AutoSize

