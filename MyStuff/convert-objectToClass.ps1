#https://jdhitsolutions.com/blog/powershell/8059/solving-the-powershell-conversion-challenge/
Function Convert-ObjectToClass {
    [cmdletbinding()]
    [outputType([String])]
    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [object]$InputObject,
        [Parameter(Mandatory, HelpMessage = "Enter the name of your new class")]
        [string]$Name,
        [string[]]$Properties,
        [string[]]$Exclude
    )
    Begin {
        Write-Verbose "Starting $($myinvocation.MyCommand)"
    } #begin

    Process {
        Write-Verbose "Converting existing type $($InputObject.getType().Fullname)"
        #create a list to hold properties
        $prop = [system.collections.generic.list[object]]::new()

        #define the class here-string
        $myclass = @"

# this class is derived from $($InputObject.getType().Fullname)
class $Name {
#properties

"@

        #get the required properties
        if ($Properties) {
            $InputObject.psobject.properties | Where-Object { $Properties -contains $_.name } |
            Select-Object -Property Name, TypeNameOfValue |
            ForEach-Object {
                Write-Verbose "Adding $($_.name)"
                $prop.Add($_)
            } #foreaach
        } #if Properties
        else {
            Write-Verbose "Adding all properties"
            $InputObject.psobject.properties | Select-Object -Property Name, TypeNameOfValue |
            ForEach-Object {
                Write-Verbose "Adding $($_.name)"
                $prop.Add($_)
            } #foreach
        } #else all

        if ($Exclude) {
            foreach ($item in $Exclude) {
                Write-Verbose "Excluding $item"
                #remove properties that are tagged as excluded from the list
                [void]$prop.remove($($prop.where({ $_.name -like $item })))
            }
        }
        Write-Verbose "Processing $($prop.count) properties"
        foreach ($item in $prop) {
            #add the property definition name to the class
            #e.g. [string]$Name
            $myclass += "[{0}]`${1}`n" -f $item.TypeNameOfValue, $item.name
        }

        #add placeholder content to the class definition
        $myclass += @"

#Methods can be inserted here
    <#
    [returntype] MethodName(<parameters>) {
        code
        return value
    }
    #>

#constructor placeholder
$Name() {
    #insert code here
}

} #close class definition
"@

        #if running VS Code or the PowerShell ISE, copy the class to the clipboard
        #this code could be modified to insert the class into the current document
        if ($host.name -match "ISE|Visual Studio Code" ) {
            $myClass | Set-Clipboard
            $myClass
            Write-Host "The class definition has been copied to the Windows clipboard." -ForegroundColor green
        }
        else {
            $myClass
        }
    } #process
    End {
        Write-Verbose "Ending $($myinvocation.MyCommand)"
    } #end
}
Get-Ciminstance win32_Operatingsystem | Convert-ObjectToClass -Properties Caption,CSName,Version,InstallDate -Name myOS