function Get-DirectoryFileSize
/* http://info.sapien.com/scripting/scripting-how-tos/take-values-from-the-pipeline-in-powershell */
{
    param
    (
	[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
	[string[]]
	$Directory
    )
	
    if (Test-Path -Path $Directory)
    {
	Get-ChildItem -Path $Directory -File | ForEach-Object -process {
                                                            $size += $_.Length
                                                           $count+=1}
	[PSCustomObject]@{'Directory' = $Directory; 'SizeInMB' = $size / 1MB;'Number of Files'=$count}
         }
    else
    {
	Write-Error "Cannot find directory: $Directory"
    }
}