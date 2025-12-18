function fjGoogleThis {
    [alias ('fjgt')] param(
        [switch]$maps)
    Begin {
        Write-Host "In function $($MyInvocation.MyCommand.Name): "
        if ($maps) { $query = 'https://www.google.com/maps/search/' }
        elseif ($url) { $query = 'https://' }
        else { $query = 'https://www.google.com/search?q=' }
    }
    Process {
        if ($args.Count -eq 0) {
            "Args were empty, commiting `$input to `$args"
            Set-Variable -Name args -Value (@($input) | ForEach-Object { $_ })
            "Args now equals $args"
            set-variable -name args -value $args.Split()
        }
        else {
            "`$Args count {0}" -f $args.count
            "Args had value, using them instead"
        }
        <#
        Write-Host $args.Count, "Arguments detected"
        "Parsing out Arguments: $args"
        for ($i = 0; $i -le $args.Count; $i++) {
            $args | ForEach-Object { "Arg $i `t $_ `t Length `t" + $_.Length, " characters" }
        }
        $args | ForEach-Object { $query = $query + "$_+" }
        #>
    }
    End {
        <#
        $url = $query.Substring(0, $query.Length - 1)
        "Final Search will be $url `nInvoking..."
        Start-Process "$url"
        #>
        $search = $args
        ($url = $query + $search) #display on console
        "URL is [ {0} ]" -f $url
        Start-Process $url
    }
}
("fred", "ellen" ,"bea", "irv") |fjGoogleThis 