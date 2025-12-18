Add-Type -AssemblyName System.Numerics
function Get-Factorial {
    param([int]$n)
    $result = [System.Numerics.BigInteger]::One
    for ($i = 2; $i -le $n; $i++) {
        $result *= [System.Numerics.BigInteger]$i
    }
    return $result
}

 Get-Factorial 52

<# 
Add-Type -AssemblyName System.Numerics
$big = [System.Numerics.BigInteger]::Parse("80658175170943878571660636856403766975289505440883277824000000000000")
$bytes = $big.ToByteArray()
$bytes.Length  # Number of bytes used to store the value 
#>

<#
Awesome! Here's both a visual chart showing how "-illions" scale up in the U.S. naming system, and a PowerShell script to format large numbers with their named equivalents.

📊 "-illion" Scale Chart (U.S. System)

Name

Power of 10

Number of Zeros

Example Value

Million

10⁶

6

1,000,000

Billion

10⁹

9

1,000,000,000

Trillion

10¹²

12

1,000,000,000,000

Quadrillion

10¹⁵

15

1,000,000,000,000,000

Quintillion

10¹⁸

18

1,000,000,000,000,000,000

Sextillion

10²¹

21

1,000,000,000,000,000,000,000

Septillion

10²⁴

24

1 × 10²⁴

Octillion

10²⁷

27

1 × 10²⁷

Nonillion

10³⁰

30

1 × 10³⁰

Decillion

10³³

33

1 × 10³³

Undecillion

10³⁶

36

1 × 10³⁶

Duodecillion

10³⁹

39

1 × 10³⁹

Tredecillion

10⁴²

42

1 × 10⁴²

Quattuordecillion

10⁴⁵

45

1 × 10⁴⁵

Quindecillion

10⁴⁸

48

1 × 10⁴⁸

Sexdecillion

10⁵¹

51

1 × 10⁵¹

Septendecillion

10⁵⁴

54

1 × 10⁵⁴

Octodecillion

10⁵⁷

57

1 × 10⁵⁷

Novemdecillion

10⁶⁰

60

1 × 10⁶⁰

Vigintillion

10⁶³

63

1 × 10⁶³

PowerShell Script: Format Large Numbers with Named Scale

function Get-NamedScale {
    param([System.Numerics.BigInteger]$number)

    $scales = @{
        "Vigintillion"     = [System.Numerics.BigInteger]::Pow(10, 63)
        "Novemdecillion"   = [System.Numerics.BigInteger]::Pow(10, 60)
        "Octodecillion"    = [System.Numerics.BigInteger]::Pow(10, 57)
        "Septendecillion"  = [System.Numerics.BigInteger]::Pow(10, 54)
        "Sexdecillion"     = [System.Numerics.BigInteger]::Pow(10, 51)
        "Quindecillion"    = [System.Numerics.BigInteger]::Pow(10, 48)
        "Quattuordecillion"= [System.Numerics.BigInteger]::Pow(10, 45)
        "Tredecillion"     = [System.Numerics.BigInteger]::Pow(10, 42)
        "Duodecillion"     = [System.Numerics.BigInteger]::Pow(10, 39)
        "Undecillion"      = [System.Numerics.BigInteger]::Pow(10, 36)
        "Decillion"        = [System.Numerics.BigInteger]::Pow(10, 33)
        "Nonillion"        = [System.Numerics.BigInteger]::Pow(10, 30)
        "Octillion"        = [System.Numerics.BigInteger]::Pow(10, 27)
        "Septillion"       = [System.Numerics.BigInteger]::Pow(10, 24)
        "Sextillion"       = [System.Numerics.BigInteger]::Pow(10, 21)
        "Quintillion"      = [System.Numerics.BigInteger]::Pow(10, 18)
        "Quadrillion"      = [System.Numerics.BigInteger]::Pow(10, 15)
        "Trillion"         = [System.Numerics.BigInteger]::Pow(10, 12)
        "Billion"          = [System.Numerics.BigInteger]::Pow(10, 9)
        "Million"          = [System.Numerics.BigInteger]::Pow(10, 6)
    }

    foreach ($scale in $scales.GetEnumerator()) {
        if ($number -ge $scale.Value) {
            $scaled = $number / $scale.Value
            return "{0:N2} {1}" -f $scaled, $scale.Key
        }
    }

    return $number.ToString()
}

# Example usage:
Add-Type -AssemblyName System.Numerics
$big = [System.Numerics.BigInteger]::Parse("80658175170943878571660636856403766975289505440883277824000000000000")
Get-NamedScale $big

This will return:

80.66 Septendecillion

Let me know if you want to extend this to support scientific notation, chunked display, or localization!
#>