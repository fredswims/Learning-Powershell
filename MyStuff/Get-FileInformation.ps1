<#
Pete Gilchrist
https://gist.github.com/nullldata/c19e2138b386f023ed0d2d56b2a76f14?fbclid=IwAR0XMflnrptp9L61wMrNFFKYuxtZtUriO7nlO7doKl-v-Hq-UHitK1qIeTg
I originally posted this on a comment of someone else's awesome work, as I was inspired to share.
I have some PowerShell that I wrote that retrieves the "Creation Date" from MS Office files which can also be useful in determining the age of some files (although templates throw confusion into the mix).
This includes both XML based office files (docx, xlsx, pptx, etc), and the reaaaaally annoying Compound Storage type binary files (doc, xls, ppt, etc... although I had to google how to do these!).
Also, other such dates like "Send / Receive date" (.msg), and other useful properties.
It also figures out the earliest date out of all the dates available for a file.
I wrapped it all into a function that just takes the literal path (local, UNC etc.) of a file and spits out a bunch of dates and other useful information into a PowerShell object for later dissemination.
Useful for building a CSV of the age of all your old files on a filesystem.
GDPR has made a lot of people look at how to do this, I'm sure!!

[sarcasm] Ahhh the fun times of figuring out a file's age when the last modified date is older than the created date, and the creation date is even older than that. [/sarcasm]

I have thrown up a paste if you're interested.

Note: UK Date format!!!!!

https://gist.github.com/nullldata/c19e2138b386f023ed0d2d56b2a76f14
#>
Function Get-FileInformation # This function will gather date information and other properties about a file
{
    param([string]$LiteralFilePath) # Target is the full path to a file
    $Target = $LiteralFilePath
    $Directory = ($Target -replace '[^\\]*$')
    #region Filetypes
    #region Outlook
    if (
            $Target -like "*.msg" # Handle Outlook Files (Has to open OutLook to get sent and received dates)
        )
    {
        $application = New-Object -ComObject "Outlook.Application"
        $NameSpace = $application.GetNamespace('MAPI')
        $document = $NameSpace.OpenSharedItem($Target.replace("\\?\UNC","\"))
        $MessageReceived = $document.ReceivedTime
        $MessageSent = $document.SentOn
        $document.Close($false)
        $application.Quit()
        $CreationDate = $null
    }
    #endregion
    #region Old Office Files
    elseif (  # Handle old Office Files (This was a complete pain to get working!)
            $Target -like "*.doc" -or
            $Target -like "*.dot" -or
            $Target -like "*.wbk" -or
            $Target -like "*.xls" -or
            $Target -like "*.vsd" -or
            $Target -like "*.xlt" -or
            $Target -like "*.xlm"
            )
        {
            $Folder = ($Target -replace '[^\\]*$').replace("\\?\UNC\","\\")
            #$File = Split-Path $Target -leaf
            try
            {
                Function OldCreatedDate()
                {
                    foreach($sFolder in $Folder)
                    {
                        $a = 0
                        $objShell = New-Object -ComObject Shell.Application
                        $objFolder = $objShell.namespace($sFolder)

                        foreach ($strFileName in $objFolder.items())
                        {
                            if ($strFileName.Path -eq  ($Target).replace("\\?\UNC\","\\"))
                            {
                                for ($a ; $a  -le 266; $a++)
                                {
                                    if($objFolder.getDetailsOf($strFileName, $a))
                                    {
                                        $hash += `
                                        @{
                                            $($objFolder.getDetailsOf($objFolder.items, $a))  = $($objFolder.getDetailsOf($strFileName, $a))
                                        }
                                        $hash
                                        $hash.clear()
                                    }
                                }
                            }
                        }
                    }
                }

                function ConvertHashtableTo-Object `
                {
                    [CmdletBinding()]
                    Param([Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
                    [hashtable]$ht
                    )
                    PROCESS {
                        $results = @()

                        $ht | %{
                            $result = New-Object psobject;
                            foreach ($key in $_.keys) {
                                $result | Add-Member -MemberType NoteProperty -Name $key -Value $_[$key]
                             }
                             $results += $result;
                         }
                        return $results
                    }
                }

                $ContentreatedObject = (OldCreatedDate | where {$_.Keys -eq "Content created"} | ConvertHashtableTo-Object)."Content created"
                $CreationDate = Get-Date ([Datetime]::ParseExact(($ContentreatedObject -replace '[^\p{L}\p{Nd}]', ''), 'ddMMyyyyHHmm', $null))  -Format "dd/MM/yyyy HH:mm:ss" -ErrorAction Stop
            }
        catch
            {
                $CreationDate = $null
            }
        }
    #endregion
    #region New Office Files
    #Handle Newer Formats
    elseif (                                #Handles New Office Files (Opens them like a Zip and reads the date from an XML file inside)
                $Target -like "*.xlsx" -or
                $Target -like "*.xlsm" -or
                $Target -like "*.xltx" -or
                $Target -like "*.xltm" -or
                $Target -like "*.vsdx" -or
                $Target -like "*.docm" -or
                $Target -like "*.dotx" -or
                $Target -like "*.docb" -or
                $Target -like "*.docx" -or
                $Target -like "*.pptx" -or
                $Target -like "*.pptm" -or
                $Target -like "*.potx" -or
                $Target -like "*.ppam" -or
                $Target -like "*.ppsx" -or
                $Target -like "*.ppsm" -or
                $Target -like "*.sldx" -or
                $Target -like "*.sldm"
            )
    {
        Add-Type -assembly "system.io.compression.filesystem"
        $zip = [io.compression.zipfile]::OpenRead($Target)
        $file = $zip.Entries | where-object {$_.Name -eq "core.xml"}
        $stream = $file.Open()
        $reader = New-Object IO.StreamReader($stream)
        $text = $reader.ReadToEnd()
        $XMLText = [XML]$text
        $UnFormattedDate = $XMLText.coreProperties.created.'#text'
        $FormattedDate = Get-Date $UnFormattedDate -Format "dd/MM/yyyy HH:mm:ss"
        $CreationDate = $FormattedDate
        $reader.Close()
        $stream.Close()
        $zip.Dispose()
    }
    #endregion
    #Everything else
    else
    {
        $CreationDate = $null
    }
    #endregion
    #region Variables
    $ItemProperties = Get-ItemProperty $Target | select CreationTime, LastAccessTime, LastWriteTime, Name, Length
    $CreationTime = $ItemProperties.CreationTime
    $LastAccessTime = $ItemProperties.LastAccessTime
    $LastWriteTime = $ItemProperties.LastWriteTime
    $FileName = $ItemProperties.Name
    $FileSize = $ItemProperties.Length
    $FileType = [System.IO.Path]::GetExtension($Target)
    $PathLength = $LiteralFilePath.Length
    $FolderPath = Split-Path -Path $LiteralFilePath
    $ParentFolder = Split-Path (Split-Path $LiteralFilePath -Parent) -Leaf
    #endregion
    #region Earliest Date
    $Dates = @($CreationDate, $CreationTime, $LastAccessTime, $LastWriteTime, $MessageReceived, $MessageSent)
    $EarliestDate = $Dates | Sort-Object | Select-Object -First 1
    #endregion
    #region Build Object And Get Earliest Date
    New-Object -TypeName psobject -Property `
    @{
        Filename = $FileName;
        FileSize = $FileSize;
        FileType = $FileType;
        PathLength =  ($Directory.replace("\\?\UNC\","\\")).Length;
        ParentFolder = Split-Path $Directory -Leaf;
        LiteralFilePath = $LiteralFilePath;
        LiteralFolderPath = $FolderPath;
        EarliestDate = $EarliestDate;
        CreationDateOffice = $CreationDate;
        CreationTimeWindows = $CreationTime;
        LastAccessTimeWindows = $LastAccessTime;
        LastWriteTimeWindows = $LastWriteTime;
        MessageReceived = $MessageReceived;
        MessageSent = $MessageSent;

    }
    #endregion
}

Get-FileInformation -LiteralFilePath "\\?\UNC\STUPIDLY\LONG\PATH\TO\FILE.docx"