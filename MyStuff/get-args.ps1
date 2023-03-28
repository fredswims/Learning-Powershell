Function Get-Args

{

 Param(

  [string]$command

 )
# borrowed from https://devblogs.microsoft.com/scripting/solve-problems-with-external-command-lines-in-powershell/
 [management.automation.psparser]::Tokenize($command,[ref]$null)

} #end function Get-Args