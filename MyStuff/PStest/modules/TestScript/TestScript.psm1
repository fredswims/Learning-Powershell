# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7
function Test-Scriptx {
    [CmdletBinding()]
    param (
        $file = "psreadLine"
        )

        begin {
            function InsideOut {
                param (
                    $param1
                )
                Write-verbose "In function $($MyInvocation.MyCommand.Name) "
                Write-Verbose "The variable 'PSScriptRoot' is: $($PSScriptRoot)"

            }
            InsideOut
            Write-verbose "In function $($MyInvocation.MyCommand.Name) "
            $startDir = Get-Location
            write-verbose "here we go Fred and Mara"
            $sw = [System.Diagnostics.Stopwatch]::StartNew()
        }

        process {
            push-location $home
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
    function InsideOut1 {
        [CmdletBinding()]
        param (
            $param1
        )
        Write-verbose "In function $($MyInvocation.MyCommand.Name) "

    }
    # test-script  -Verbose