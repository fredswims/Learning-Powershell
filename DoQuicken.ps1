#if ($args.count -eq 0) {read-host "You must supply a data file name";exit}
#$fileName=$args

if ( $env:COMPUTERNAME -eq "VAIOFRED" -or $env:COMPUTERNAME -eq "Harriet" ) {
    $sDirPath=$env:HOMEDRIVE + $env:HOMEPATH + "\Dropbox\Private\Q\"
    }

if ($env:COMPUTERNAME -eq "SUPERCOMPUTER")  {
    $sDirPath=$env:HOMEDRIVE + $env:HOMEPATH + "\Documents\Dropbox\Private\Q\"
    }

if  (Test-Path $sDirPath) {} else {read-host "The specified path $Sdirpath is incorrect";exit}

$sourceFile= $sDirPath  + $fileName
$sourceFile
$DestinationDir= $env:HOMEPATH + "\Desktop"
$DestinationDir
Copy-Item $sourceFile $DestinationDir


