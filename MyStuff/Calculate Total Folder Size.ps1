#Calculate Total Folder Size
Start-Sleep -seconds 10
#Here is a useful function that you can use to calculate the total size of a folder: 
Get-FolderSize $HOME
function Get-FolderSize($path) {
  Write-Progress -Activity 'Calculating Total Size for:' -Status $path
  Get-ChildItem $path -Recurse -ea 0 -Force | 
    Measure-Object -Property Length -Sum | 
    Select-Object -ExpandProperty Sum
  write-host ****DONE***  
}
#For example, if you want to know how much space your profile folder consumes, you can try this: 
#Get-FolderSize $home
#It may take some time for the function to complete because it recursively visits all folders and sums up all file sizes.
#Share this tip on:  facebook |  twitter |  linkedin 

