# https://www.petri.com/using-the-ternary-conditional-operator-in-powershell-7
$CarColor = 'Blue'
$test=@{ $true = 'The car color is blue'; $false = 'The car color is not blue'}
$CarColor -eq 'Blue'