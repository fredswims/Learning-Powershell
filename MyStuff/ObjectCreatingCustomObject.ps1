function readEventLog {
    # take events not older than 48 hours
    $deadline = (Get-Date).AddHours(-48)

    Get-EventLog -LogName * |
        ForEach-Object {
        # get the entries, and quiet errors
        try { $_.Entries } catch {}
    } |
        Where-Object {
        # take only errors
        $_.EntryType -eq 'Error'
    } |
        Where-Object {
        # take only entries younger than the deadline
        $_.TimeGenerated -gt $deadline
    }
}


$object=[PSCustomObject]@{Name = "CustomObject";Expand=@(1,2,3,4,5)}
$object | Select-Object -ExpandProperty Expand -Property Name
$object | Select-Object -ExpandProperty Expand -Property Name | Get-Member

# https://kevinmarquette.github.io/2016-10-28-powershell-everything-you-wanted-to-know-about-pscustomobject/
# Creating a PSCustomObject
$myobject=[PSCustomObject]@{
    Name = "Kevin"
    Language='Powershell'
    State='Texas'
}

$myHashtable = @{
    Name     = 'Kevin'
    Language = 'Powershell'
    State    = 'Texas'
}
$myObject = [pscustomobject]$myHashtable

if ($myobject.PSobject.properties.match('xxx')){'yes'}else{'no'}



# Custom object type with PSTypeName
$myObject = [PSCustomObject]@{
    PSTypeName = 'My.Object'
    Name       = 'Kevin'
    Language   = 'Powershell'
    State      = 'Texas'
}
# Update-TypeData with DefaultPropertySet
$TypeData = @{
    TypeName = 'My.Object'
    DefaultDisplayPropertySet = 'Name','Language'
}
Update-TypeData @TypeData

# Update-TypeDate with ScriptProperty
# You can do this before your object is created or after.
$TypeData = @{
    TypeName = 'My.Object'
    MemberType = 'ScriptProperty'
    MemberName = 'UpperCaseName'
    Value = {$this.Name.toUpper()}
}
Update-TypeData @TypeData


# Function that uses custom type for parameter
function get-MyObject
{
    param([PSTypeName('My.Object')]$Data)
$Data.Name="fred"
$Data.Language="Hebrew"
$Data.State='Bliss'
}

Function CreateCustomDataType {
    $myObject = [PSCustomObject]@{
        PSTypeName = 'My.Object'
        Name       = ""
        Language   = ""
        State      = ""
    }
    # Update-TypeData with DefaultPropertySet
    $TypeData = @{
        TypeName                  = 'My.Object'
        DefaultDisplayPropertySet = 'Name', 'Language'
    }
    Update-TypeData @TypeData

    # Update-TypeDate with ScriptProperty
    # You can do this before your object is created or after.
    $TypeData = @{
        TypeName   = 'My.Object'
        MemberType = 'ScriptProperty'
        MemberName = 'UpperCaseName'
        Value      = {$this.Name.toUpper()}
    }
    Update-TypeData @TypeData
}

function test {
param($MyArray)
Clear-Host
write-host -ForegroundColor 'yellow' "beginning test**************************"
#Create data
$path=(join-path -path $env:TEMP  -childpath "fred.text")

'Create test data ********************************'
if (test-path $path) {remove-item $path}
Get-ChildItem *|
select-object -property name, @{Name="Language"; Expression = {$_.basename}}, `
@{Name="State";Expression={[string]$_.creationtime}} | ConvertTo-Json | Set-Content -path $path

# step to create an array based on PSCustomObject from a file
if (test-path variable:global:myobject) {remove-variable myObject}
CreateCustomDataType
#if (test-path variable:global:myarray) {remove-variable myarray}
#[PSTypeName('My.Object')]$myArray=@()
#myarray = @()
if ((get-item -Path $path).length -lt 100) {write-host -ForegroundColor 'red' "no data in file- stopping";break}
$line = get-content -path $path | ConvertFrom-Json
foreach ($item in $line) {
    $myObject = [PSCustomObject]@{
        PSTypeName = 'My.Object'
        Name       = $item.Name
        Language   = $item.Language
        State      = $item.State
    }
    $myarray += $myobject #$myarray has pointers to $myobject data. That is why we create the custom object repeatedly.
}
$MyArray.count
} #end of function Test

'Display results *************'
$myarray.Count
$myarray | Get-Member
$myarray
$myarray | format-table # DefaultPropertySet displayed
$myarray | format-table -property * # notice all the properties show
## End of Test funcion
#}
$MyArray=@{}
test

$myarray
$myobject

$a = for ($i = 0; $i -lt 5; $i++){
    [PSCustomObject] @{
        Col1 = $i
        Col2 = $i+1
        Col3 = $i+2
        Col4 = $i+3
        }
}

$b = @()

for ($i = 0; $i -lt 5; $i++)
{

$item = New-Object PSObject
$item | Add-Member -type NoteProperty -Name 'Col1' -Value 'data1'
$item | Add-Member -type NoteProperty -Name 'Col2' -Value 'data2'
$item | Add-Member -type NoteProperty -Name 'Col3' -Value 'data3'
$item | Add-Member -type NoteProperty -Name 'Col4' -Value 'data4'

$b += $item
}

#make data


#####################

Clear-Host
write-host -ForegroundColor 'yellow' "beginning test**************************"
#Create data
$path=(join-path -path $env:TEMP  -childpath "fred.text")
set-location (split-path $path)
'Create test data ********************************'
if (test-path $path) {remove-item $path}
Get-ChildItem *|
select-object -property name, @{Name="Language"; Expression = {$_.basename}}, `
@{Name="State";Expression={[string]$_.creationtime}} | ConvertTo-Json | Set-Content -path $path

#Now push all those items into a PSObject
if ((get-item -Path $path).length -lt 100) {write-host -ForegroundColor 'red' "no data in file- stopping";break}
if (test-path variable:myObject) {Remove-Variable myObject}
$myObject = Get-Content -Path $Path | ConvertFrom-Json

$myObject.PSObject.TypeNames.Insert(0,"My.Object")

    # Update-TypeData with DefaultPropertySet
    $TypeData = @{
        TypeName                  = 'My.Object'
        DefaultDisplayPropertySet = 'Name', 'Language'
    }
    Update-TypeData @TypeData

    # Update-TypeDate with ScriptProperty
    # You can do this before your object is created or after.
    $TypeData = @{
        TypeName   = 'My.Object'
        MemberType = 'ScriptProperty'
        MemberName = 'UpperCaseName'
        Value      = {$this.Name.toUpper()}
    }
    Update-TypeData @TypeData
####################################




$myobject

$myObject.PSObject.TypeNames.Insert(0,"My.Object")


$myobject | gm

foreach( $property in $myobject.psobject.properties.value ){myObject.$property}



$things=@{}
$things.data1="foo"
$things.data2="bar"

New-Object psobject -Property $things

New-Object psobject -Property @{
    data1 = "fooALLTHETIME"
    data2 = "morebar"
}

1..5 | ForEach-Object {
    New-Object psobject -Property @{
        data1 = $_
        data2 = Get-Random -Maximum 100
    }
}

https://www.reddit.com/r/PowerShell/comments/46hr3a/adding_items_to_a_custom_object/
