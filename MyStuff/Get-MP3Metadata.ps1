Function Get-MP3MetaData
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([Psobject])]
    Param
    (
        [String] [Parameter(Mandatory=$true, ValueFromPipeline=$true)] $Directory
    )

    Begin
    {
        $shell = New-Object -ComObject "Shell.Application"
    }
    Process
    {

        Foreach($Dir in $Directory)
        {
            $ObjDir = $shell.NameSpace($Dir)
            $Files = Get-ChildItem $Dir| Where-Object {$_.Extension -in '.mp3','.mp4','.wma'}

            Foreach($File in $Files)
            {
                $ObjFile = $ObjDir.parsename($File.Name)
                $MetaData = @{}
                $MP3 = ($ObjDir.Items()|Where-Object {$_.path -like "*.mp3" -or $_.path -like "*.mp4" -or $_.path -like "*.wma"})
                #$PropertyArray = 0,1,2,12,13,14,15,16,17,18,19,20,21,22,27,28,36,220,223
                $PropertyArray= 0..57
                $PropertyArray+=59..61
                $PropertyArray+=63..169
                $PropertyArray+=171..254
                Foreach($item in $PropertyArray)
                {
                    If($ObjDir.GetDetailsOf($ObjFile, $item)) #To avoid empty values
                    #if (1)
                    {   #write-host $ObjDir.GetDetailsOf($ObjFile, $item)
                        "{0} : {1} -> {2}" -f ($item,$ObjDir.GetDetailsOf($MP3,$item), $ObjDir.GetDetailsOf($ObjFile, $item))
                        #write-host $item ": " $ObjDir.GetDetailsOf($MP3,$item) "::" $ObjDir.GetDetailsOf($ObjFile, $item)
                        $MetaData[$($ObjDir.GetDetailsOf($MP3,$item))] = $ObjDir.GetDetailsOf($ObjFile, $item)
                    }

                }

                New-Object psobject -Property $MetaData |Select-Object *, @{n="Directory";e={$Dir}}, @{n="Fullname";e={Join-Path $Dir $File.Name -Resolve}}, @{n="Extension";e={$File.Extension}}
            }
        }
    }
    End
    {
    }
}
#set-location "C:\Users\Super Computer\music\The Band - The Last Waltz"
Get-MP3MetaData (Get-Location)
Get-Location

<# ForEach($item in ("C:\Data\Powershell\Tutorials\1_Basics\" |Get-MP3MetaData)){
    $Source = $item.Fullname
    $Album = $item.Album
    Set-Location C:\Music
    If(-not (gci | ?{$_.name -eq "$Album" -and $_.PSisContainer}))
    {
        New-Item -Name $Album -ItemType Directory -Force |Out-Null
    }

    $destination = "C:\Music\$album"
    Move-Item -Path  $Source -Destination $destination -Force -Verbose
}
 #>