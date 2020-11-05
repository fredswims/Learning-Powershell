function Enumerate-ObjectProperties {
    param (
        [psobject] $Object,
        [string] $Root
    )

    Write-Output $($Object.PSObject.Properties | Format-Table @{ Label = 'Type'; Expression = { "[$($($_.TypeNameOfValue).Split('.')[-1])]" } }, Name, Value -AutoSize -Wrap | Out-String)

    foreach ($Property in $Object.PSObject.Properties) {
        # Strings always have a single property "Length". Do not enumerate this.
        if (($Property.TypeNameOfValue -ne 'System.String') -and ($($Object.$($Property.Name).PSObject.Properties))) {
            $NewRoot = $($($Root + '.' + $($Property.Name)).Trim('.'))
            Write-Output "Property: $($NewRoot)"
            #Enumerate-ObjectProperties -Object $($Object.$($Property.Name)) -Root $NewRoot
        }
    }
}

Enumerate-ObjectProperties $(get-item *.ps1)
Enumerate-ObjectProperties $YourObject
Enumerate-ObjectProperties $a