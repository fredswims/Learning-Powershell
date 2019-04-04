#Git
#https://dfinke.github.io/2016/Data-Crunching-Using-the-content-of-a-text-file-as-a-PowerShell-DSL/
<#
COMPND      Ammonia
AUTHOR      DAVE WOODCOCK  97 10 31
ATOM      1  N           1       0.257  -0.363   0.000
ATOM      2  H           1       0.257   0.727   0.000
ATOM      3  H           1       0.771  -0.727   0.890
ATOM      4  H           1       0.771  -0.727  -0.890
TER       5              1
END
#>
class Compound {
    $CompoundName
    [Author]$Author
    [Atom[]]$Atoms

    AddAtom([Atom]$atom) {
        $this.Atoms+=$atom
    }
}

class Author {
    $FirstName
    $LastName
    $Year
    $Month
    $Day
}

class Atom {
    $sphere
    $elementName
    $idx
    $x
    $y
    $z
}

function Compnd ($CompoundName) {
    $Global:targetCompound=[Compound]$PSBoundParameters
}

function Author ($FirstName, $LastName, $Year, $Month, $Day) {
    $Global:targetCompound.Author=[Author]$PSBoundParameters 
}

function Atom   ($sphere, $elementName, $idx, $x, $y, $z){
    $Global:targetCompound.AddAtom([Atom]$PSBoundParameters)
}

function ter {$Global:targetCompound}
#function ter {}
function end {}
#----------------------
#loop for debugging
    $count=25
    for ($i=0; $i -lt $count; $i++)
    {
        "loop count: $i"
        start-sleep -milliseconds 200
    }
$FileDir=$SkyDriveDir
$Global:targetCompound=""
Get-Content -Raw $FileDir\ammonia.pdb | Invoke-Expression
$global:targetCompound.CompoundName 

$global:targetCompound.Author

$global:targetCompound.Atoms | ft
