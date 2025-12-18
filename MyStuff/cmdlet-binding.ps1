
function cmdlet-binding1 {
    [CmdletBinding()]
                    [OutputType("PSReleaseStatus")]
                    param(
                        [Parameter(Mandatory=$true,HelpMessage = "Get the latest preview release")]
                        [switch]$Preview
                    )

                    begin {
                        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting: $($MyInvocation.MyCommand)"
                        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running PowerShell $($PSVersionTable.PSVersion) in $($host.name)"
                        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Using module version $moduleVersion"
                    } #begin

                    process {
                        # $data = GetData @PSBoundParameters
                    } #process    
                    end {
                        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending: $($MyInvocation.MyCommand)"
                        return $data
                    } #end  
} #function
# cmdlet-binding1 -Verbose


<# 
function Wrapper {
    param(
        [string]$Name,
        [int]$Age
    )
    write-host @PSBoundParameters
    set-variable -Name mydata -Value  @PSBoundParameters
    $myData.GetType().FullName
}

Wrapper -Name "Fred" -Age 42 
#>