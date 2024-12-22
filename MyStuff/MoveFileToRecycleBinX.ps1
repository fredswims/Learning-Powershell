function MoveFileToRecycleBinx {
    param(
        [Parameter (Mandatory = $true, HelpMessage = "Enter the name of the file to move to the recyclebin.")]
        [System.IO.FileInfo]$Filename
    )

    Write-Warning "In function $($MyInvocation.MyCommand.Name): "
    if (!(test-path $filename)) {write-warning ("File '{0}' does not exist" -f $filename); return $false}
    else { write-verbose ("File '{0}' exists" -f $Filename) }
    # Load the necessary .NET assembly
    # Add-Type -AssemblyName System.Windows.Forms
    # Define the path of the file you want to move to the recycle bin
    $filePath = $filename
    # Move the file to the recycle bin

    
# $sh = new-object -comobject "Shell.Application" 
# $ns = $sh.Namespace(0).ParseName("C:\New folder\test") 
# $ns.InvokeVerb("delete") 

    $sh = New-Object -ComObject Shell.Application
    # $recycleBin = $sh.Namespace(10)
    $ns = $sh.Namespace(0).ParseName($filepath) 
    $ns.InvokeVerb("delete") 

    # $file = $sh.NameSpace((Get-Item $filePath).Directory.FullName).ParseName((Get-Item $filePath).Name)
    # $file.InvokeVerb("delete")
    write-warning ("Deleted file {0}" -f $filepath) -Verbose
} #end MoveFileToRecycleBin
set-location $env:TEMP
$temp=new-item -type File -name fred.txt
MoveFileToRecycleBin $temp

<# # Create an instance of the Shell.Application COM object
$sh = New-Object -ComObject Shell.Application
# Parse the file path to get the file object
$ns = $sh.Namespace(0).ParseName($filepath)
# Use the InvokeVerb method to delete the file (move to Recycle Bin)
$ns.InvokeVerb("delete")

### Additional Tips:
try {
    $filepath = "C:\path\to\your\file.txt"  # Replace with your actual file path
    $sh = New-Object -ComObject Shell.Application
    $ns = $sh.Namespace(0).ParseName($filepath)
    if ($ns) {
        $ns.InvokeVerb("delete")
        Write-Output "File moved to Recycle Bin successfully."
    } else {
        Write-Output "File not found."
    }
} catch {
    Write-Error "An error occurred: $_"

} #>