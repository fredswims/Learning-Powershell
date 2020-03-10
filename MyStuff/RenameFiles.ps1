# THIS WORKS - look at ssingle and double quotes.
# Can this be simplified with splatting?
$file="fred.txt"
new-item $file
get-item fred.txt | ForEach-Object {rename-item -confirm -path $_.fullname  -NewName "fred$($_.BaseName.replace('f','').replace('ed','yellow'))Ellen$($psitem.Extension)"  }


$splat=@{
NewName="fred$($_.BaseName.replace('f','').replace('ed','yellow'))Ellen$($psitem.Extension)"
}
$splat=@{
  Path="fred.txt"
  NewName="fred" 
  }
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