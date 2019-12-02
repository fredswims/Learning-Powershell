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
