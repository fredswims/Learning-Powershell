function Covid19 {
    push-location $env:OneDrive\PowershellScripts\MyStuff\Data\
    $path="./feature-list.html"
    $path="./2020-04-06-feature-list.html"
    $path="./2020-04-06T-19-28-feature-list.html"

    #version 1.0.2 FAJ 2020-04-08
    # new functions GroupCovid19, runthis
    #added rank
    #run like this '$data=$null;$data=covid19;read-host $data.count;$data|format-table -auto;GroupCovid19 $data'
    Write-Warning "In function $($MyInvocation.MyCommand.Name): "
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
Puerto Rico
District of Columbia
'@
    $States = $($StatesHere -split "`n").TrimEnd("`r")

    #https://paullimblog.wordpress.com/2017/08/08/ps-tip-parsing-html-from-a-local-file-or-a-string/
    $html = New-Object -ComObject "HTMLFile"
    $html.IHTMLDocument2_write($(Get-Content -path $path -raw))

    $InnerText=$html.all.tags("P")|Select-Object innertext
    #$ellen=new-object system.collections.arrayList
    #for($i=0;$i -lt $innertext.count;$i=$i+2){$ellen.add("{0}  {1}" -f $innertext[$i].innertext, $innertext[$i+1].innertext)}
    #for($i=0;$i -lt $innertext.count;$i=$i+2){$ellen.add($innertext[$i].innertext + ' ' + $innertext[$i+1].innertext)}

    #$innerText is a string with data.
    #Process two at a time.
    #The first string looks like '67,551 confirmed' with spaces embedded.
    #The second string looks like 'New York City New York US' with spaces embedded.
    #Both lines must be parsed.
    $Rank=0
    for($i=0;$i -lt $Innertext.count;$i+=2){
        $rank++
        $thisstring=""
        $IndexTemp=0
        $Index=0
        $Country=""
        $State=""
        $City=""
        $thisString=$innertext[$i+1].innertext
        #Country is the last two digits of the string preceeded by a space ' '.
        $Country=$thisstring.Substring($thisstring.LastIndexOf(" ")+1)
        #Remove country from the string.
        $thisstring=$thisstring.Substring(0,$thisstring.LastIndexOf(" "))
        #Locate the State
        foreach($aState in $States) {
            $IndexTemp=$thisstring.LastIndexOf($aState)
            if ($IndexTemp -gt 0){
                #Got a State
                $Index=$IndexTemp
                $State=$aState
                #remove the State from the string; the city/county remains
                $City=$thisstring.Substring(0,$index-1)
                #stop the 'foreach' operator
                break
            }
        }
        #Parse the number and status
        $thisString=$innertext[$i].innertext
        #find the separator between number and status
        $index=$thisString.LastIndexOf(" ")

        $thisobject=   [pscustomobject]@{
            oCount=[long]$thisString.Substring(0,$index)
            oStatus=$thisString.Substring($index+1)
            oCity=$City
            oState=$State
            oCountry=$Country
            oRank=$Rank
        }
        #push the thisobject to the pipeline.
        $thisobject
    }#End of for.
Write-Warning "End of function $($MyInvocation.MyCommand.Name): "
}#end of function

Function GroupCovid19 ($object) {
    #https://stackoverflow.com/questions/5999930/how-to-sum-multiple-items-in-an-object-in-powershell
    $object | Group-Object ostate | %{
        New-Object psobject -Property @{
            State = $_.Name
            Sum = ($_.Group | Measure-Object oCount -Sum).Sum
        }
    } | Sort-Object -property Sum -Descending
}


function runthis {
    $data=$null;$data=covid19;read-host $data.count;$data|format-table -auto;GroupCovid19 $data
    $sum=GroupCovid19 $data
    foreach ($state in $states){if($state -in $sum.state){}else {"nope $($state)"}}
}
# $object=$ellen|convertFrom-String -TemplateContent $template

# $html.all.tags("P")|Select-Object innertext|ConvertFrom-String -TemplateContent $template


# $html.all.tags("A")| foreach-object innertext
# $html.all.tags("A")| out-file "covid.txt"
# $html.all|out-file "covid.txt"
# $html.all.tags("A")| select-object *
# $html.all.tags("external-html")| where-object innertext -like "*new york city*"

# $a=($html.allElements|Where-Object {$_.class -match "feature-list"}).innerText
# $a=($html.allElements|Where-Object {$_.class -match "external-html"}).innerText

# $tags=$html.all.tags("")

# $url="https://coronavirus.jhu.edu/map.html"
# $response = Invoke-WebRequest -Uri $url
# $response.ParsedHtml.body.getelementsbyclassname('external-html')

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

#foreach ($state in $states){write-host "This state is $($state)";if($state -eq "Nevada"){write-warning "break";break}}
