function Get-AsciiBanner {
    param([string]$Text, [string]$Font = "standard")
    Invoke-RestMethod -Uri "artii.herokuapp.com"
}
