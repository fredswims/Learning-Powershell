Install-Sript -Name Pivot-Object
get-help pivot-object

@"
NAME
    C:\Users\Super Computer\Documents\WindowsPowerShell\Scripts\Pivot-Object.ps1
SYNOPSIS
    Converts a stream of input items into properties of a resulting object
    -------------------------- EXAMPLE 1 --------------------------
    PS >1..5 | Pivot-Object -Width 3

    P1 P2 P3
    -- -- --
    1  2  3
    4  5

    -------------------------- EXAMPLE 2 --------------------------
    PS >gc C:\temp\addresses.txt

    Name: Joe
    Phone: 555-1212

    Name: Frank
    Phone: 555-1213

    PS > gc C:\temp\addresses.txt | % { $_ -replace '.*: (.*)','$1' } | Pivot-Object -Property Name,Phone,$null

    Name  Phone
    ----  -----
    Joe   555-1212
    Frank 555-1213
"@