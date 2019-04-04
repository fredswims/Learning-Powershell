$ErrorActionPreference="STOP"

$ErrorActionPreference="silentlycontinue"
 
 try { nosense
        Get-ChildItem }
         
          
          catch [System.Management.Automation.CommandNotFoundException],[System.IO.IOException]
              {write-host -foregroundcolor yellow "Inherited Exception"}
            catch [System.SystemException] {"Base Exception" }
           catch
          {
              "An error occurred that could not be resolved."
          }
          finally{write-host "the end"}
          write-host -ForegroundColor yellow ("Error->>>>")
       

      
