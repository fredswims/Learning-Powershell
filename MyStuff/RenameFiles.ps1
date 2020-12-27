set-location $env:TEMP
$path="config.log"
remove-item -force -ErrorAction SilentlyContinue -path $path
new-item -ItemType file -path $path 
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_script_blocks?view=powershell-7
# Using *** delay-bind script blocks *** with parameters
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_script_blocks?view=powershell-7#using-delay-bind-script-blocks-with-parameters
# Renames config.log to old_config.log
# in the scriptblock you can concatenate strings and variables as opposed to a string ["fred $($psitem.basename)) someMoreText"].
get-item $path | Rename-Item -Confirm -NewName {"old_" + $_.Name.Substring(0,1).ToUpper() + $_.Name.Substring(1).toLower()}
# I like this because you can use the concatenation operator [+] to form complex strings.

# But make sure all the objects are strings. For instance (get-date -Format "yyyy-MM-ddTHH-mm-ss".ToString())
$file=New-TemporaryFile -Verbose
#set-location Temp: -Verbose
get-item $file -Verbose | rename-item -NewName { (get-date -Format "yyyy-MM-ddTHH-mm-ss".ToString())+$psitem.Name+".rename"} -confirm -Verbose
remove-item $file -verbose
#Here is a simple replace.
Get-ChildItem *.log | Rename-Item -confirm -NewName { $_.Name -replace '.log','.txt' }
Get-ChildItem *.log | Rename-Item -confirm -NewName { $psitem.BaseName + $_.Extension.Replace('.log','.txt') }
#without a delay-bind script block you have to make complex strings and reference variables buy surrounding them in [$()].
Get-ChildItem *.log | `
foreach-object { Rename-Item -confirm -path $psitem -NewName "$($psitem.BaseName)$($_.Extension.Replace('.log','.txt'))" }

function showRenameFiles($files){
  $time=showFileDateTime;
  #Use a delay-bind script-block
  get-childitem $files|rename-item -Confirm  -NewName { $time + $psitem.fullname }
}


# THIS WORKS - look at single and double quotes.
# Can this be simplified with splatting?
$file="fred.txt"
new-item $file
get-item fred.txt | ForEach-Object {rename-item -confirm -path $_.fullname  -NewName "fred$($_.BaseName.replace('f','').replace('ed','yellow'))Ellen$($psitem.Extension)"  }


$splat=@{
NewName="fred$($_.BaseName.replace('f','').replace('ed','yellow'))Ellen$($psitem.Extension)"
}
$file="fred.txt"
new-item -type file -Path $file
$splat=@{
  Path=$file
  NewName="fred" 
  }
Rename-item @splat
  
Rename-Item -path fred.txt 

rename-item -Path $fred.name -NewName ($datesubstring + $fredroot + $fred.Extension)
rename-item -Path $fred.name -NewName ($fred.BaseName.Substring($fred.BaseName.IndexOf("20"),$fred.BaseName.Length) + $fred.BaseName.Substring(0,$fred.BaseName.IndexOf("20")) + $fred.Extension)

$fred.BaseName.IndexOf("20"),$fred.BaseName.Length
 $datesubstring=$fred.BaseName.Substring($fred.BaseName.IndexOf("20"),$fred.BaseName.Length ) 
 $datestart=$fred.BaseName.IndexOf("20")
 $datelength=$fred.BaseName.Length  
  $fred.BaseName.Substring(0,$datestart) 

rename-item -path $fred.name -NewName () 
18 get-item fred*    

                                                                               
  19 $fred=get-item fred*                                                                             
  20 $fred.BaseName                                                                                   
  21 $fred.BaseName.Substring(1,5)                                                                    
  22 $fred.BaseName.Substring(1,$fred.BaseName.Length)                                                
  23 $fred.BaseName.IndexOf("20")                                                                     
  24 $datestart=$fred.BaseName.IndexOf("20")                                                          
  25 $datestart                                                                                       
  26 $datelength=$fred.BaseName.Length                                                                
  27 $datelength                                                                                      
  28 $datelength=$fred.BaseName.Length                                                                
  29 $datelength=$fred.BaseName.Length - $datestart                                                   
  30 $datelength                                                                                      
  31 $fred.BaseName.Substring($datestart,$datelength)                                                 
  32 $datesubstring=$fred.BaseName.Substring($datestart,$datelength)                                  
  33 $fred.BaseName.Substring(0,$datestart-1)                                                         
  34 $fred.BaseName.Substring(0,$datestart)                                                           
  35 $fredroot=$fred.BaseName.Substring(0,$datestart)                                                 
  36 $datesubstring                                                                                   
  37 $datesubstring + $fredroot                                                                       
  38 $datesubstring + $fredroot + $fred.Extension                                                     
  39 rename-item -Path $fred.name -NewName ($fred.BaseName.Substring($fred.BaseName.IndexOf("20") ,($fred.BaseName.Length - $fred.BaseName.IndexOf("20"))) + $fred.BaseName.Substring(0,($fred.BaseName.IndexOf("20")) + $fred.Extension)             
  40 ls *fre*  


  
  new-item $file
  rename-item -confirm -path $file  -NewName "fred$($fred.basename.replace('f','').replace('ed','yellow'))Ellen$($fred.Extension)"
