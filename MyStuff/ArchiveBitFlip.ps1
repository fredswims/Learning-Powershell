$attribute=[io.fileattributes]::archive
if((Get-ItemProperty -path fred.txt).Attributes -band $attribute)
{"it is set"}
else {
    "it isnt set"
}

Set-Location $env:HOMEPATH
$path = "fred.txt"
$files = Get-ChildItem -Path $path

$attribute = [io.fileattributes]::archive
Foreach ($file in $files) {
    If ((Get-ItemProperty -Path $file.fullname).attributes -band $attribute)
    {
        "$file.fullname has the $attribute bit set, removing the bit."
        Set-ItemProperty -Path $file.fullname -Name attributes -Value ((Get-ItemProperty $file.fullname).attributes -BXOR $attribute)
        "New value of $file.Fullname attributes"
        (Get-ItemProperty -Path $file.fullname).attributes
    }
    ELSE
    {
        Write-host -ForegroundColor blue
        "$file.fullname does not have the $attribute bit set, setting the bit."
        Set-ItemProperty -Path $file.fullname -Name attributes -Value ((Get-ItemProperty $file.fullname).attributes -BXOR $attribute)
        "New value of $file.Fullname attributes"
        (Get-ItemProperty -Path $file.fullname).attributes
    }
} #end Foreach