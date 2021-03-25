Function Get-enumValues {
    param([string]$enum)
    $enumValues=@{}
    [enum]::GetValues([type]$enum) |
    ForEach-Object {
        $enumValues.add($_,$_.value__)
    }
    $enumValues
}

$enum=Get-enumValues "System.Management.Automation.CommandTypes"


<# $xlr = [psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')
$xlr::Add('accelerators', $xlr)
$xlr::Get
 #>