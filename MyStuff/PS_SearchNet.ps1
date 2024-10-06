[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True,Position=0)]
	[String]$SearchFor,
	
	[Parameter(Mandatory=$True,Position=1)]
	[String]$Use
)

$ErrorActionPreference = "SilentlyContinue"
If ($Error) {$Error.Clear()}
$SearchFor = $SearchFor.Trim()
If (!($SearchFor)) {
	Write-Host
	Write-Host "Text That You Wish To Search For Has Not Been Entered." -ForeGroundColor "Yellow"
	Write-Host "Execution of the Script Has been Ternimated." -ForeGroundColor "Yellow"
	Write-Host
	Exit
}
$Use = $Use.Trim()
If (!($Use)) {
	Write-Host
	Write-Host "Search Engine To Use Has Not Been Specified." -ForeGroundColor "Yellow"
	Write-Host "Execution of the Script Has been Ternimated." -ForeGroundColor "Yellow"
	Write-Host
	Exit
}
$SearchFor = $SearchFor -Replace "\s+", " "
$SearchFor = $SearchFor -Replace " ", "+"

Switch ($Use) {
	"Google" {
		# -- "Use Google To Search"
		$Query = "https://www.google.com/search?q=$SearchFor"
	}
	"Bing" {
		# -- "Use Bing Search Engine To Search"
		$Query = "http://www.bing.com/search?q=$SearchFor"
	}
	Default {$Query = "No Search Engine Specified"}
}
If ($Query -NE "No Search Engine Specified") {
	## -- Detect the Default Web Browser
	Start-process $Query
}
Else {
	Write-Host
	Write-Host $Query -ForeGroundColor "Yellow"
	Write-Host "Execution of the Script Has been Ternimated." -ForeGroundColor "Yellow"
	Write-Host
}