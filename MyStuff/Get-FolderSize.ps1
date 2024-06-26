function Get-FolderSize($Path=$pwd) {
   write-host 'Beginning Path ' $path
   $code = { ('{0:0.0} MB' -f ($this/1MB)) }
   Get-ChildItem -Path $Path |
      Where-Object { $_.Length -eq $null } |
      ForEach-Object {
       $i++
       Write-Progress -Activity 'Calculating Total Size for:' -Status $_.FullName
       $sum = Get-ChildItem $_.FullName -Recurse -ErrorAction SilentlyContinue |
        Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue
       $bytes = $sum.Sum
       if ($bytes -eq $null) { $bytes = 0   }
       $result = 1 | Select-Object -Property Path, TotalSize
       #$result | get-member
       $result.Path = $_.FullName
       #$result | get-member
       $result.TotalSize = $bytes | 
        Add-Member -MemberType ScriptMethod -Name toString -Value $code -Force -PassThru    
       #write-host $i
       $result
      }
   write-host 'finis'    
}
