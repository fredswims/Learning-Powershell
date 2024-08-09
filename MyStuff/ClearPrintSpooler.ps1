#Get-WmiObject Win32_Printer | where-object { $_.Name -like "HP LaserJet P1006" } | foreach-object {  $_.CancelAllJobs() }
#$fred=Get-ComputerInfo

# If that doesn't work try this
# http://mickitblog.blogspot.com/2017/02/clearing-specific-print-queues.html

#this is for a multiple printer environment.

<#
	.SYNOPSIS
		Delete Print Jobs for Specific Printer

	.DESCRIPTION
		This script will delete print jobs for a specific printer.
		It gets a list of print jobs in the %SYSTEM32\Spool\PRINTERS directory.
		It reads the contents of the .SHD files, which have the names of the printer inside them.
		It then filters out those jobs that are not queued for the specified printer and deletes them.
		It stops the spooler before the deletion and then restarts it.

	.PARAMETER PrinterName
		Full or partial name of the printer to filter for

	.EXAMPLE
		Delete all printer jobs for printer named Workshare
			powershell.exe -file ClearPrintSpooler.ps1 -PrinterName "Workshare"
			shortcut to launch is run as administrator and target is ->
			powershell.exe -noprofile -noexit -command "& 'C:\Users\Super Computer\OneDrive\Documents\Powershell\MyStuff\ClearPrintSpooler.ps1' -PrinterName basementprinter"
	.NOTES
		===========================================================================
		Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
		Created on:   	2/22/2017 10:46 AM
		Created by:   	Mick Pletcher
		Organization:
		Filename:		ClearPrintSpooler.ps1
		===========================================================================
#>
[CmdletBinding()]
param
(
    [parameter(Mandatory=$true)]
    [ValidateSet("HP LaserJet P1006","BasementPrinter","WirelessPrinter")]
	[ValidateNotNullOrEmpty()][string]$PrinterName="BasementPrinter"
)

Clear-Host
write-host "printer name: $printerName"
#$printername="basementprinter"
#Get list of print jobs
$Files = Get-ChildItem -Path $env:windir"\system32\spool\printers" -Filter *.SHD
#Initialize variable to contain list of files to delete
$DeleteFiles = @()
foreach ($File in $Files) {
	#Read contents of binary file
	$Contents = [System.IO.File]::ReadAllBytes($File.FullName)
	#Filter out all contents that are not A-Z and a-z in the ASCII number fields
	$Contents = $Contents | Where-Object { (($_ -ge 65) -and ($_ -le 90)) -or (($_ -ge 97) -and ($_ -le 122)) }
	#Convert string to ASCII
	foreach ($Value in $Contents) {
		$Output += [char]$Value
	}
	#Add base file name to the $DeleteFiles list if the $PrinterName is in the converted string
	If ($Output -like "*$PrinterName*") {
		$DeleteFiles += 	$File.BaseName
	}
}
#Delete all files that met the searched criteria
foreach ($File in $DeleteFiles) {
	#Stop Print Spooler Service
	"Stopping Service Spooler"
	Stop-Service -Name Spooler -Force | Out-Null
	#Create Filter to search for files
	$FileFilter = $File + ".*"
	#Get list of files
	$Filenames = Get-ChildItem -Path $env:windir"\system32\spool\printers" -Filter $FileFilter
	#Delete each file
	foreach ($Filename in $Filenames) {
		write-host "Going to delete - $filename"
		Remove-Item -Path $Filename.FullName -Force | Out-Null
	}
	#Start Print Spooler Service
	"Starting Service Spooler"
	Start-Service -Name Spooler | Out-Null
}
write-host "finis"

