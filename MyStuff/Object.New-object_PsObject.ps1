#using the New-Object cmdlet to create a new object and add it to an array of objects.
$results = @()
$Number=0 #initialize the counter
# $file = 'C:\protected_temp\logs\intest.log'
$pattern = 'function.*fjs'
Sprofile $pattern  | ForEach-Object {
    $ThisLine=$_.line #the actual line of text returned
    $ThisLineNumber=$_.LineNumber #the line number of the file
    $Number+=1
    $props = @{
        Line=$ThisLIne
        LineNumber=$ThisLineNumber
        Number=$Number
    }
    $results += New-Object psObject -Property $props #add this line to the results array which is an array of objects.
    }