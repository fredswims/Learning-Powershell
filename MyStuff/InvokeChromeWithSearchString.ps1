<#
https://foxdeploy.com/2013/11/16/use-powershell-to-quickly-launch-a-new-tab-in-your-browser-to-search-google/
.Synopsis
Searches the Googes
.DESCRIPTION
Lets you quickly start a search from within Powershell
.EXAMPLE
Search-Google Error code 5
--New google search results will open listing top entries for 'error code 5'

.EXAMPLE
search-google (gwmi win32_baseboard).Product maximum ram

If you need to get the maximum ram for your motherboard, you can even use this
type of syntax
#>
function Search-Google {
    Begin {
        $query = 'https://www.google.com/search?q='
    }
    Process {
        if ($args.Count -eq 0) {
            "Args were empty, commiting `$input to `$args"
            Set-Variable -Name args -Value (@($input) | ForEach-Object { $_ })
            "Args now equals $args"
            $args = $args.Split()
        }
        ELSE {
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
        ($url = “https://www.google.com/#q=” + $search)
        Start-Process $url
    }
}

function googletest {
    $search = $args
    $url = “https://www.google.com/#q=” + $search
    Start-Process $url
}


Search-Google "is there a hell" "what is the matter with you"
"what is the matter with you" | Search-Google
googletest "what is reality"
"what is reality" | googletest