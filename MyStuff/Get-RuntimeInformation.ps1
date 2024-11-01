# jhicks@jdhitsolutions.com
Function Get-RuntimeInformation {
    [cmdletbinding()]
    [OutputType('PSRunTimeInformation')]
    [alias('rti')]
    Param()
    [PSCustomObject]@{
        PSTypeName       = 'PSRuntimeInformation'
        PSVersion        = $PSVersionTable.PSVersion
        Framework        = [System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription
        FrameworkVersion = [System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription.Replace('.NET', '').Trim()
        OSVersion        = [System.Runtime.InteropServices.RuntimeInformation]::OSDescription
        Architecture     = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
        Computername     = [Environment]::MachineName
    }
}