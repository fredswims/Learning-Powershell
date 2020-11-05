
#ObjectObject.ps1
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