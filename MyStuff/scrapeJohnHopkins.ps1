#https://paullimblog.wordpress.com/2017/08/08/ps-tip-parsing-html-from-a-local-file-or-a-string/
function Positives {
$StatesHere=@'
Alabama
Alaska
Arizona
Arkansas
California
Colorado
Connecticut
Delaware
Florida
Georgia
Hawaii
Idaho
Illinois
Indiana
Iowa
Kansas
Kentucky
Louisiana
Maine
Maryland
Massachusetts
Michigan
Minnesota
Mississippi
Missouri
Montana
Nebraska
Nevada
New Hampshire
New Jersey
New Mexico
New York
North Carolina
North Dakota
Ohio
Oklahoma
Oregon
Pennsylvania
Rhode Island
South Carolina
South Dakota
Tennessee
Texas
Utah
Vermont
Virginia
Washington
West Virginia
Wisconsin
Wyoming
'@
$States = $($StatesHere -split "`n").TrimEnd("`r")

# $template=@'
# {NAME:57,159 confirmed}
# {LOCATION:New York City US}
# '@
# $template=@'
# {NAME:57,159 confirmed}
# {NAME:12,351 confirmed}
# {LOCATION:New York City US}
# '@
# $template=@'
# {Positive:57,159} {[string]Status:confirmed} {[string]City:New York City} {[string]State:New York} {[string]Country:US}
# {Positive:12,351} {[string]Status:confirmed} {[string]City:Westchester} {[string]State:New York} {[string]Country:US}
# {Positive:12,024} {[string]Status:confirmed} {[string]City:Nassau} {[string]State:New York} {[string]Country:US}
# {Positive:4,808} {[string]Status:confirmed} {[string]City:Wayne} {[string]State:New Jersey} {[string]Country:US}
# '@

# $template=@'
# {[long]Positive:57,159} {[string]Status:confirmed} {[string]City:New York City} {[string]State:New York} {[string]Country:US}
# '@

set-location $env:Homepath/mystuff/data
$path="./feature-list.html"

$html = New-Object -ComObject "HTMLFile"
$html.IHTMLDocument2_write($(Get-Content -path $path -raw))

$innertext=$html.all.tags("P")|Select-Object innertext
$ellen=new-object system.collections.arrayList
#for($i=0;$i -lt $innertext.count;$i=$i+2){$ellen.add("{0}  {1}" -f $innertext[$i].innertext, $innertext[$i+1].innertext)}
#for($i=0;$i -lt $innertext.count;$i=$i+2){$ellen.add($innertext[$i].innertext + ' ' + $innertext[$i+1].innertext)}
#Process two at a time.

for($i=0;$i -lt $innertext.count;$i+=2){
    $LineArray=$innertext[$i+1].innertext -split(' ')

$thisobject=   [pscustomobject]@{
    Positives=$innertext[$i].innertext
    City=$innertext[$i+1].innertext
   
   }
$thisobject
}
}#end of function


write-host "start"
$positives=positives
write-host "end"

$object=$ellen|convertFrom-String -TemplateContent $template

$html.all.tags("P")|Select-Object innertext|ConvertFrom-String -TemplateContent $template


$html.all.tags("A")| foreach-object innertext
$html.all.tags("A")| out-file "covid.txt"
$html.all|out-file "covid.txt"
$html.all.tags("A")| select-object *
$html.all.tags("external-html")| where-object innertext -like "*new york city*"

$a=($html.allElements|Where-Object {$_.class -match "feature-list"}).innerText
$a=($html.allElements|Where-Object {$_.class -match "external-html"}).innerText

$tags=$html.all.tags("")

$url="https://coronavirus.jhu.edu/map.html"
$response = Invoke-WebRequest -Uri $url
$response.ParsedHtml.body.getelementsbyclassname('external-html')

