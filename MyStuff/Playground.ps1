function Showgg{
    Begin {
        Write-Host "In function $($MyInvocation.MyCommand.Name): "
        $query = 'https://www.google.com/search?q='
        # $query = 'https://www.bing.com/search?q='

    }
    Process {
        if ($args.Count -eq 0) {
            "Args were empty, commiting `$input to `$args"
            Set-Variable -Name args -Value (@($input) | ForEach-Object { $_ })
            "Args now equals $args"
            $args = $args.Split()
        }
        else {
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
        # Start-Process $url
        # start-process msedge -ArgumentList $url
        start-process   $url
    }
}#END Search-Google

showgg "sanford kimmel"


gcm -commandtype externalscript | Get-Item | 
Select-Object Directory,Name,Length,CreationTime,LastwriteTime,
@{name="Signature";Expression={(Get-AuthenticodeSignature $_.fullname).Status }}





