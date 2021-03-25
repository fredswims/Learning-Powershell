# https://jdhitsolutions.com/blog/powershell/8196/comparing-powershell-property-names/
Function Compare-PropertyName {
    [cmdletbinding(DefaultParameterSetName="default")]
    [alias("cpn")]
    [Outputtype("PSPropertyNameDifference","string","boolean")]
    Param(
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [object]$Reference,
        [Parameter(Position = 1, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [object]$Difference,
        [Parameter(HelpMessage = "Indicate if property names match with a simple True/False.",ParameterSetName="quiet")]
        [switch]$Quiet,
        [Parameter(HelpMessage = "Only show missing property names in the difference object.",ParameterSetName="missing")]
        [switch]$MissingOnly,
        [Parameter(HelpMessage = "Only show extra property names in the difference object.",ParameterSetName="extra")]
        [switch]$ExtraOnly
    )
    Write-Warning "In function $($MyInvocation.MyCommand.Name): "
    #get property names from the first item
    $refProp = $Reference[0].psobject.properties.name | Sort-Object
    Write-Verbose "Found $(($refProp).count) reference properties"

    $diffProp = $Difference[0].psobject.properties.name | Sort-Object
    Write-Verbose "Found $(($diffProp). count) difference properties"

    $missing = [System.Collections.Generic.List[string]]::new()
    $extra = [System.Collections.Generic.List[string]]::new()

    #find extra  properties in the difference object
    foreach ($name in $diffProp) {
        if ($refProp -notcontains $name) {
            Write-Verbose "$Name not found in the reference object"
            $extra.Add( $name)
        }
    } #foreach

    #find missing reference properties from the difference object
    foreach ($name in $refProp) {
        if ($diffProp -notcontains $name) {
            Write-Verbose "$Name not found in the difference object"
            $missing.Add( $name)
        }
    } #foreach

    #create a custom object for the reseult
    $result = [pscustomobject]@{
            PSTypename = "PSPropertyNameDifference"
            Missing = $missing
            Extra = $Extra
            ReferenceProperties = $refProp
            DifferenceProperties = $diffProp
            ReferenceCount = $refProp.count
            DifferenceCount = $diffProp.count
         }

         switch ($pscmdlet.ParameterSetName) {
            "Quiet" {
                if ($result.missing.count -eq 0 -AND $result.extra.count -eq 0) {
                    $true
                }
                else {
                    $false
                }
            }
            "Missing" {
                $result.Missing
            }
            "Extra" {
                $result.Extra
            }
            Default {
                $result
            }
         } #switch


} #close function

$csvA = @"
samantha,darren-1,darren-2,tabitha,esmerelda
1,2,3,4,5
2,4,6,8,10
3,6,9,11,12
11,22,33,44,55
"@

$csvB = @"
samantha,darren-1,darren-2,esmerelda,gladys,agatha
1,2,3,4,0,9
2,4,6,8,1,8
3,6,9,11,8,0
11,22,33,55,66,77
"@

$a = $csvA | ConvertFrom-Csv
$b = $csvB | ConvertFrom-Csv

$a[0].psobject.Properties.Name
Compare-PropertyName -Reference $a -Difference $b
Compare-PropertyName -Reference $a -Difference $b -Quiet
Compare-PropertyName -Reference $a -Difference $b -MissingOnly
Compare-PropertyName -Reference $a -Difference $b -ExtraOnly

$obj=Compare-PropertyName -Reference $a -Difference $b



