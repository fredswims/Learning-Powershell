
#ObjectObject.ps1


# some command | select-object x,y z |
[PSCustomObject]@{
    Date      = $_.TimeGenerated
    Name      = $_.ReplacementStrings[0]
    Path      = $_.ReplacementStrings[1]
    StartMode = $_.ReplacementStrings[3]
    User      = $_.ReplacementStrings[4]
}

function makeanobject {

 $thisobject=   [pscustomobject]@{Name='Test';Type='Type002';AnotherKey="some value"} #create the object
 $thisobject #put it in the pipeline

 # here we push the second item into the object.
 $thisobject=   [pscustomobject]@{
     Name='Test'
     Type='fred'
     AnotherKey="some other value"
    }
$thisobject

}
# wrap in a foreach block
#contrast this with speedtest.ps1

makeanobject