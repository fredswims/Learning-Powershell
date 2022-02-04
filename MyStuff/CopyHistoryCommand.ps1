# https://jdhitsolutions.com/blog/powershell/8777/copy-powershell-history-command/?fbclid=IwAR3kBeDeS1mC4wXwCn5pWlBiLkQ9SQDge9e182k3bxwp3XqDg5US7WSxfGQ
Function Copy-HistoryCommand {

    [CmdletBinding(SupportsShouldProcess)]
    [alias("ch")]
    [outputtype("None", "System.String")]
    Param(
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [int]$ID = $(Get-History).Count,
        [switch]$Passthru)

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
    } #begin
    Process {
        Write-Verbose "[PROCESS] Getting commandline from history item: $id"
        $cmdstring = (Get-History -Id $id).CommandLine
        If ($PSCmdlet.ShouldProcess("ID #$id [$cmdstring]")) {
            $cmdstring | Microsoft.PowerShell.Management\Set-Clipboard

            If ($Passthru) {
                #write the command to the pipeline
            } #If passthru
        }
    } #process

    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end

} #close function
