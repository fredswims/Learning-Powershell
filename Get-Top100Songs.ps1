function Get-Top100Songs {
    param($year=1968)
    
    $template = '
<TR>
<TD id=pos1>{pos*:1}</TD>
<TD id=rec1547 data-sorttable-customkey="Beatles">{group:Beatles}</TD>
<TD>{song:Hey Jude}</TD></TR>
<TR>
<TD id=pos2>{pos*:2}</TD>
<TD id=rec1548 data-sorttable-customkey="Paul Mauriat">{group:Paul Mauriat}</TD>
<TD>Love Is Blue</TD></TR>
<TR>
<TR>


<TD id=pos68>68</TD>
<TD id=rec1614 data-sorttable-customkey="Sam and Dave">Sam and Dave</TD>
<TD>I Thank You</TD></TR>
<TR>
    '
    
    $url = "http://www.bobborst.com/popculture/top-100-songs-of-the-year/?year=$year"
    $html = ((Invoke-WebRequest $url).AllElements | Where {$_.tagname -eq 'tbody'}).innerhtml
    $html
    $html | ConvertFrom-String -TemplateContent $template | 
        ForEach { 
            $_ | Add-Member -PassThru -MemberType NoteProperty -Name Year -Value $year
        }
}