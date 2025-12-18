Get-ChildItem -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides" -Recurse |
ForEach-Object {
    try {
        $props = Get-ItemProperty -Path $_.PSPath
        if ($props.PSChildName -like "*Recall*" -or $_.PSChildName -like "*Recall*") {
            [PSCustomObject]@{
                KeyPath = $_.PSPath
                PSChildName = $_.PSChildName
                Properties = $props
            }
        }
    } catch {
        # Skip inaccessible keys
    }
}
