function Test-Script {
    [CmdletBinding()]
    param (
    )
        
    begin {
        Write-verbose "In function $($MyInvocation.MyCommand.Name) "
        $startDir = Get-Location
        write-verbose "here we go" 
        $sw = [System.Diagnostics.Stopwatch]::StartNew() 
    }
        
    process {
        push-location $home
        $file = "psreadLine"
        $places = $env:PSModulePath.Split(";")
        foreach ($place in $places) {
            ">>> {0}" -f $place 
            if (Test-Path $place) {
                Push-Location $place
                if (Test-path $file) {
                    Push-Location $file
                    Get-ChildItem  -recurse $file*              
                }
            }
        }
    }
        
    end {
        set-location $startDir 
        Write-verbose $sw.Elapsed.TotalMilliseconds  
        Write-Host "FINIS" 
    }
}

test-script  -Verbose