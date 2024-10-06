New-NameItTemplate {[PSCustomObject]@{Company="";Name=""}}

New-NameItTemplate {[PSCustomObject]@{Company="";Name=""}}
# Run on 12/31/2020

$templates = $(
    'ThisQuarter'
    'q1', 'q3', 'q3', 'q4'
    'Today', 'Tomorrow', 'Yesterday'
    'February', 'April', 'October'
)

foreach ($template in $templates) {
    $template | ForEach-Object {
        [PSCustomObject]@{
            Template = $_
            Result   = Invoke-Generate "$_" 
        }
    }
}

$templates = $(
    'ThisQuarter'
    'q1', 'q3', 'q3', 'q4'
    'Today', 'Tomorrow', 'Yesterday'
    'February', 'April', 'October', 'address'
)

foreach ($template in $templates) {
    $template | ForEach-Object {
        [PSCustomObject]@{
            Template = $_
            Result   = Invoke-Generate "$_" 
        }
    }
}