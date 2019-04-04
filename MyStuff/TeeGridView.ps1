Get-Process | Tee-GridView |Where-Object name -like 'powershell' | Select-Object -Property Name,ID
 Get-Service | Tee-GridView | Where-Object name -like w* | Tee-GridView  | Sort-Object -Property name,status | Tee-GridView | Format-Table -GroupBy status -Property name,displayname
function Tee-GridView {
<#
.SYNOPSIS 
    Like Tee-Object this taps into the stream but instead of writing to a file or a variable we popup a GridView.
.DESCRIPTION
    To analyse what the pipeline looks like in the different stages then use Tee-GridView to get a good understanding.
.EXAMPLE 
    If you want to look at what the pipeline looks like after the Get-Process and before the Where-Object in the following command:
        Get-Process | Where-Object name -like 'powershell' | Select-Object -Property Name,ID
    Reissue the command as:
        Get-Process | Tee-GridView |Where-Object name -like 'powershell' | Select-Object -Property Name,ID
.EXAMPLE
    Take a fairly normal pipeline like the following:
        Get-Service | Where-Object name -like w* | Sort-Object -Property name,status | Format-Table -GroupBy status -Property name,displayname
    To analyse what the pipeline looks like in the different stages then issue the folowing command instead:
        Get-Service | Tee-GridView | Where-Object name -like w* | Tee-GridView  | Sort-Object -Property name,status | Tee-GridView | Format-Table -GroupBy status -Property name,displayname
#>
    param(
        [parameter(ValueFromPipeline=$true)]
        [object]$InputObject
    )
    begin {
        $res = @()
    }
    process {
        $res += $InputObject
    }
    end {        
        $title = $MyInvocation.Line.Substring(0,$MyInvocation.OffsetInLine - 1)
        if($title.LastIndexOf("|") -gt 0) {
            $title = $title.Substring(0,$title.LastIndexOf("|"))
        }
        $res | Out-GridView -Title $title -Wait
        $res
    }
}