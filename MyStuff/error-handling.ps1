function crazy 
{
    [cmdletbinding()]
    param()
    process
    {
        try 
        {
            $lastErrorPreference=$ErrorActionPreference
            $ErrorActionPreference="Continue"
            "all is good until"
            if (1 -eq 2) 
                {
                Write-host  "everything is going well"
                $fred=1/(1-1)
                }
            else
            {
                1/0
                #write-error -ErrorAction stop "something happened that i want to tell you about"
            }
        }    
    
        catch
        {
            "I got to my catch"
            $PSitem
            "*******************"
            $PSCmdlet.ThrowTerminatingError($PSitem)
        }

        Finally
        {
            "This is the finally code"
            $ErrorActionPreference=$lastErrorPreference
        }
    }
    
}

clear-host
"hello there"
$veryhappy=crazy
"return from call to Crazy with var veryhappy: $veryhappy"
"calling crazy again"

crazy