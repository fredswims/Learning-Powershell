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


Path[1]:    $fred="http://www.dmr-marc.net/cgi-bin/trbo-database/datadump.cgi?table=users&format=csv"
   $html=(Invoke-WebRequest $fred).AllElements
   ConvertFrom-String -PropertyNames Radio ID,Callsign,Name,City,State,Country,Home Repeater,Remarks
   $html[3] | convertfrom-string -PropertyNames Radio ID,Callsign,Name,City,State,Country,Home Repeater,Remar