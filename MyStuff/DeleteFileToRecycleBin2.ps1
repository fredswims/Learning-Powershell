<# $path = "fred"
$shell = new-object -comobject "Shell.Application"
$item = $shell.Namespace(0).ParseName($path)
$item.InvokeVerb("delete")
 #>


# Path to the file you want to remove
<# Set-Location "C:\Users\freds\OneDrive\PowershellScripts\MyStuff"


get-location
$file = "fred"

# Create a new COM object for Shell32
$shell = New-Object -ComObject Shell.Application

# Move the file to the recycle bin
$recycleBin = $shell.Namespace(10) # 10 represents the Recycle Bin
$recycleBin.MoveHere($file)

 #>

<# 
 Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class RecycleBin
{
    [DllImport("shell32.dll", CharSet = CharSet.Unicode)]
    public static extern int SHFileOperation(ref SHFILEOPSTRUCT lpFileOp);

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct SHFILEOPSTRUCT
    {
        public IntPtr hwnd;
        public UInt32 wFunc;
        public string pFrom;
        public string pTo;
        public UInt16 fFlags;
        public Int32 fAnyOperationsAborted;
        public IntPtr hNameMappings;
        public string lpszProgressTitle;
    }

    public const UInt32 FO_DELETE = 3;
    public const UInt16 FOF_ALLOWUNDO = 0x0040;

    public static void MoveFileToRecycleBin(string path)
    {
        SHFILEOPSTRUCT shf = new SHFILEOPSTRUCT();
        shf.wFunc = FO_DELETE;
        shf.pFrom = path + '\0' + '\0';
        shf.fFlags = FOF_ALLOWUNDO;
        SHFileOperation(ref shf);
    }
}
"@

# Define the path to the file you want to move to the recycle bin
cdmystuff
get-location
$file = "fred"

# Call the method to move the file to the recycle bin
[RecycleBin]::MoveFileToRecycleBin($file)
get-item $file
 #>
function move-fileToRecycleBin {
    param ([Parameter(Mandatory = $true,
            HelpMessage = "Enter the name of the Quicken data file; e.g., Home.qdf : ")]
        [System.IO.FileInfo]$Filename)

    if (!(test-path $filename)) { write-warning "$filename does not exist"; return }
    else { "File {0} exists" -f $Filename }
    # Load the necessary .NET assembly
    Add-Type -AssemblyName System.Windows.Forms
    # Define the path of the file you want to move to the recycle bin
    $filePath = $filename
    # Move the file to the recycle bin
    $sh = New-Object -ComObject Shell.Application
    # $recycleBin = $sh.Namespace(10)
    $file = $sh.NameSpace((Get-Item $filePath).Directory.FullName).ParseName((Get-Item $filePath).Name)
    $file.InvokeVerb("delete")
}
move-fileToRecycleBin 
