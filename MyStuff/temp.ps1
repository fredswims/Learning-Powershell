

#function test {
function MakeObject {
    if (test-path variable:global:myobject) {remove-variable myObject}
    #create object once
    $MyObject = [PSCustomObject]@{
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

MakeObject
$path = join-path -Path $env:temp -ChildPath "fred.text"
#Create test data
if (test-path $path) {remove-item $path}
Get-ChildItem * |
    select-object -property name, @{Name = "Language"; Expression = {$_.basename}}, `
@{Name = "State"; Expression = {[string]$_.creationtime}} | ConvertTo-Json | Set-Content -path $path
# Beginning of Test
Clear-Host
write-host -ForegroundColor 'yellow' "beginning test**************************"
# step to create an array based on PSCustomObject from a file
# clean up previous runs
if (test-path variable:global:myarray) {remove-variable myarray}
#[PSTypeName('My.Object')]$myArray=@()
$myarray = @()
if ((get-item -Path $path).length -lt 100) {write-host -ForegroundColor 'red' "no data in file- stopping"; break}
$line = get-content -path $path | ConvertFrom-Json
foreach ($item in $line) {
    #$MyObject = [PSCustomObject]@{
    #PSTypeName = 'My.Object'
    $MyObject.Name = $item.Name
    $MyObject.Language = $item.Language
    $MyObject.State = $item.State
    #}
    $myarray += $MyObject
}

'Display results *************'
$myarray.Count
$myarray | Get-Member
$myarray
$myarray | format-table # DefaultPropertySet displayed
$myarray | format-table -property * # notice all the properties show
## End of Test funcion



#The powershell OneDrive directory $env:Onedrive\Documents\Powershell is owned by Fred@Fred.Jacobowitz.com and shared as \Powerhell with FredSwims@Outlook.com
function fgetProfile {
    $LocalProfile=join-path -path (split-path -parent $profile) -ChildPath "\profile.ps1"
    if($env:ComputerName -eq "SuperComputer") {$RepositoryProfile=(join-path $env:Onedrive\Documents\Powershell\Profiles\CurrentUser Profile.ps1)} else {$RepositoryProfile=join-path $env:Onedrive\Powershell\Profiles\CurrentUser Profile.ps1}
    write-host "Repository Profile:: $(get-content $RepositoryProfile |select-object -first 1)"
    Compare-Object -ReferenceObject (get-content $RepositoryProfile) -DifferenceObject (get-content $LocalProfile)
    copy-item -confirm -path $RepositoryProfile -destination $LocalProfile
}
set-alias getProfileFromRepository -value fgetProfile -Option Readonly -passthru | format-list;#remove-variable thisPath#
