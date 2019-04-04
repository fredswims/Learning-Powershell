function test {
    Clear-Host
    write-host -ForegroundColor 'yellow' "beginning test**************************"
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

    #Create data
    $path = (join-path -path $env:TEMP  -childpath "fred.text")

    #'Create test data ********************************'
    if (test-path $path) {remove-item $path}
    Get-ChildItem * |
        select-object -property name, `
    @{Name = "Language"; Expression = {$_.basename}}, `
    @{Name = "State"; Expression = {[string]$_.creationtime}} |
        ConvertTo-Json | Set-Content -path $path

    # step to create an array based on PSCustomObject from a file
    if (test-path variable:global:myobject) {remove-variable myObject}
    #CreateCustomDataType
    #if (test-path variable:global:myarray) {remove-variable myarray}
    #[PSTypeName('My.Object')]$myArray=@()
    #myarray = @()
    if ((get-item -Path $path).length -lt 100) {write-host -ForegroundColor 'red' "no data in file- stopping"; break}
    $line = get-content -path $path | ConvertFrom-Json
    foreach ($item in $line) {
        $myObject = [PSCustomObject]@{
            PSTypeName = 'My.Object'
            Name       = $item.Name
            Language   = $item.Language
            State      = $item.State

        }
        $myObject
        #$myarray += $myobject #$myarray has pointers to $myobject data. That is why we create the custom object repeatedly.
    }
    Remove-TypeData -TypeData my.Object
} #end of function Test
