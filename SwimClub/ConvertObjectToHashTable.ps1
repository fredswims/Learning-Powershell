$psObject = gci

    foreach ($myPsObject in $psObject) {
        $output = @{};
        $myPsObject | Get-Member -MemberType *Property | % {
            $output.($_.name) = $myPsObject.($_.name);
        }
        $output;
    }
$output.Count
$output.Keys
$output.Values


#This is the way to create objects
function whereisthisfile ($arg) {
    $dir=$env:Path
    $dir=$dir.split(";")
    foreach ($path in $dir){write-host $path}
    Write-host "******"
    #$fullpath=$dir | ForEach-Object {Get-ChildItem $_/$arg}
    $dir  | `
    ForEach-Object {Get-ChildItem -path $_/$arg -File -Force -ErrorAction SilentlyContinue} | `
    ForEach-Object  -process {$myObj=[pscustomobject]@{Name=$arg;Path=$_.fullname};$myObj} 
    #where.exe $arg | ForEach-Object -Begin {$h=@{};$i=1} -process {$h.add("name",$_);$i++} -end{[pscustomobject]$h|gm}
    #$h|format-list -property *
    #$fullpath.count
    #$fullpath.fullname
}
function test {
$Path = "$env:HOMEPATH\Documents"
$Directory = Get-Acl -Path $Path

ForEach ($Dir in $Directory.Access){
    [PSCustomObject]@{
    Path = $Path
    Owner = $Directory.Owner
    Group = $Dir.IdentityReference
    AccessType = $Dir.AccessControlType
    Rights = $Dir.FileSystemRights
    }#EndPSCustomObject
}#EndForEach
}

function whereisthisfile ($arg) {
    $dir=$env:Path
    $dir=$dir.split(";")
    foreach ($path in $dir){write-host $path}
    Write-host "******"
    #$fullpath=$dir | ForEach-Object {Get-ChildItem $_/$arg}
    $dir  | `
    ForEach-Object {Get-ChildItem -path $_/$arg -File -Force -ErrorAction SilentlyContinue} | `
    ForEach-Object  -process {[pscustomobject]@{
                                     Name=$arg
                                     Path=$_.fullname
                                    }
                            } 
}

$myObj=[pscustomobject]@{Name=$arg;Path=$_.fullname}
function makeanobject {

 $thisobject=   [pscustomobject]@{Name='Test';Type='Type002'}
 $thisobject
 $thisobject=   [pscustomobject]@{Name='Test';Type='fred'}
$thisobject

}



#https://blogs.msdn.microsoft.com/timid/2013/03/05/converting-pscustomobject-tofrom-hashtables/
function ConvertTo-HashtableFromPsCustomObject {
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )] [object[]]$psCustomObject
    );

    process {
        foreach ($myPsObject in $psCustomObject) {
            $output = @{};
            $myPsObject | Get-Member -MemberType *Property | % {
                $output.($_.name) = $myPsObject.($_.name);
            }
            $output;
        }
    }
}

$myHash=@{}
$Myobj=Get-ChildItem -file |Select-Object -Property FullName, BaseName, Extension -first 6
$myHash=ConvertTo-HashtableFromPsCustomObject $Myobj
