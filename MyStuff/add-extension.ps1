function Add-Extension
{
param
(

[string]
#Fred Specifies the file name. 
$name,

[string]
#Ellen Specifies the file name extension. "Txt" is the default.
$extension = "txt"
)

"does nothing yet"
$name = $name + "." + $extension
$name

<#
.SYNOPSIS

Adds a file name extension to a supplied name.

.DESCRIPTION

Adds a file name extension to a supplied name. Takes any strings for the
file name or extension.

.PARAMETER Extension

If you put infomation here then it overrides any 
help you put in the parameter section of the script.


.INPUTS

None. You cannot pipe objects to Add-Extension.

.OUTPUTS

System.String. Add-Extension returns a string with the extension or
file name.

.EXAMPLE

PS> extension -name "File"
File.txt

.EXAMPLE

PS> extension -name "File" -extension "doc"
File.doc

.EXAMPLE

PS> extension "File" "doc"
File.doc

.LINK

http://www.fabrikam.com/extension.html

.LINK

Set-Item
#>
}