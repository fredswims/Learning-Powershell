Function Get-Args

{

 Param(

  [string]$command

 )

 [management.automation.psparser]::Tokenize($command,[ref]$null)

} #end function Get-Args