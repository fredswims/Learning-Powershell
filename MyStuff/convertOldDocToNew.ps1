# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/converting-word-documents
function Convert-Doc2Docx
{
  param
  (
    [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]
    [Alias('FullName')]
    $Path,
    
    [string]
    $DestinationFolder
    
  )
  begin
  {
    $word = New-Object -ComObject Word.Application
  }

  process
  {

    
    $pathOut = [System.IO.Path]::ChangeExtension($Path, '.docx')
    if ($PSBoundParameters.ContainsKey('DestinationFolder'))
    {
      $exists = Test-Path -Path $DestinationFolder -PathType Container
      if (!$exists)
      {
        throw "Folder not found: $DestinationFolder"
      }
      $name = Split-Path -Path $pathOut -Leaf
      $pathOut = Join-Path -Path $DestinationFolder -ChildPath $name
    }
    $doc = $word.Documents.Open($Path)
    $name = Split-Path -Path $Path -Leaf
    Write-Progress -Activity 'Converting' -Status $name
    $doc.Convert()
    $doc.SaveAs([ref]([string]$PathOut),[ref]16)
    $word.ActiveDocument.Close()

  }
  end
  {
    $word.Quit()
  }
} Convert-Doc2Docx -path fred.doc  -DestinationFolder $env:temp