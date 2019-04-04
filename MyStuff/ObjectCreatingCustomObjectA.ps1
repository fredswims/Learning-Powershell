function test {
    try {
        Clear-Host
        write-host -ForegroundColor 'yellow' "beginning test**************************"
        #Create data
        $path = (join-path -path $env:TEMP  -childpath "fred.text")

        #'Create test data ********************************'
        if (test-path $path) {remove-item $path}
        Get-ChildItem *|
            select-object -property name, @{Name = "Language"; Expression = {$_.basename}}, `
        @{Name = "State"; Expression = {[string]$_.creationtime}} | ConvertTo-Json | Set-Content -path $path

        # Create PSCustomObject from a file
        #if (test-path variable:global:myobject) {remove-variable myObject}
        if ((get-item -Path $path).length -lt 100) {write-host -ForegroundColor 'red' "no data in file- stopping"; break}
        $line = get-content -path $path | ConvertFrom-Json
        #Create PSCustomObject from Dictionary Object [ordered]
        foreach ($item in $line) {
            $myObject = [ordered]@{}
            $myObject['Name'] = $item.name
            $myObject['Language'] = $item.Language
            $myObject['State'] = $item.State
            #Cast Dictionary into a PSCustomObject and places it into pipeline that is returned to caller.
            [PSCustomObject]$myobject
        }
    }
    catch {write-host 'something bad happened' -ForegroundColor Red}
    Finally {
        if (test-path $path) {remove-item $path}
    }
}