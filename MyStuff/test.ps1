function showRenameFiles($files){
    $time=showFileDateTime;
    #Use a delay-bind script-block
    L
} 
function RenameFiles([System.IO.FileInfo[]]$files){
    #arg1 is fileobject
    $time=showFileDateTime;
    #Use a delay-bind script-block
    $files|rename-item -Confirm `
      -NewName { $time + "-"+ $psitem.Name}
} 
 set-location $env:TEMP
#  showRenameFiles "*.log"
#  Get-ChildItem "*.log" -OutVariable thesefiles
  RenameFiles (Get-ChildItem *.log)
