function stream {
    get-item  * -Stream zone.identifier -ErrorAction SilentlyContinue|`
    ForEach-Object {[pscustomobject]@{Name=$psitem.psChildname;ZONE=get-content -path $psitem.filename -Stream Zone.Identifier}}
}
push-location $env:HOMEPATH\downloads
$list=stream
$list|format-list
pop-location

function stream1 {
    get-item  * -Stream zone.identifier -ErrorAction SilentlyContinue |`
        ForEach-Object { [pscustomobject]@{Name = $psitem.psChildname
                                           ZoneId = (get-content -path $psitem.filename -Stream Zone.Identifier -TotalCount 10)[1]
                                      ReferrerUrl = (get-content -path $psitem.filename -Stream Zone.Identifier -TotalCount 10)[2]
                                          HostUrl = (get-content -path $psitem.filename -Stream Zone.Identifier -TotalCount 10)[-1]
        }
    }
}
push-location $env:HOMEPATH\downloads
$list=stream1
$list|format-list
pop-location
function stream2 {
    $list=get-item  * -Stream zone.identifier -ErrorAction SilentlyContinue
    
    foreach ($file in $list) {
        $content=get-content -path $file.FileName -Stream Zone.Identifier -TotalCount 10
        [pscustomobject]@{Name = $file.filename
                                           ZoneId = $content[1]
                                      ReferrerUrl = $content[2]
                                          HostUrl = $content[-1]
        }
    }
}

push-location $env:HOMEPATH\downloads
$list=stream2
$list|format-list
pop-location
$list|Get-Member