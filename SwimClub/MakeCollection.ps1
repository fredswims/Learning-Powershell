#https://www.powershellmagazine.com/2013/02/04/creating-powershell-custom-objects/
# read for more and better options
$data=@(
    "fred", "red", "ed", "d"),
    ("Ellen","llen","len","en"),
    ("Irving","rving","ving","ing")

 $objectCollection=@()

 for ($i=0;$i -lt 3; $i++) {
     $object=new-object -TypeName psobject
     add-member -inputObject $object -memberType NoteProperty -Name A -value ""
     add-member -inputObject $object -memberType NoteProperty -Name B -value ""
     add-member -inputObject $object -memberType NoteProperty -Name C -value ""
     add-member -inputObject $object -memberType NoteProperty -Name D -value ""

     $object.A = $data[$i][0]
     $object.B = $data[$i][1]
     $object.C = $data[$i][2]
     $object.D = $data[$i][3]
     $objectCollection += $object
                                }


$data=@(
    "fred", "red", "ed", "d"),
    ("Ellen","llen","len","en"),
    ("Irving","rving","ving","ing")

 $objectCollection=@()

for ($i=0;$i -lt 3; $i++) {
     $properties = @{
         A = $data[$i][0]
         B = $data[$i][1]
         C = $data[$i][2]
         D = $data[$i][3]
        }
     $object=new-object -TypeName psobject -Property $properties
     $objectCollection += $object
     }