$DonLogPreference = "c:\errors.txt"
$DonLogPreference = $env:HOMEDRIVE +$env:HOMEPATH +    "\errors.txt"

function Get-OSInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="The. Computer. Name.")]
        [Alias('Hostname','cn')]
        [string[]]$ComputerName,

        [Parameter()]
        [string]$ErrorLogFilePath = $DonLogPreference
    )
    BEGIN {
        Remove-Item -Path $ErrorLogFilePath -Force -ErrorAction SilentlyContinue
        $ErrorsHappened = $False
    }
    PROCESS {
        Write-Verbose "HERE WE GO!!!!"
        foreach ($computer in $ComputerName) {
            try {

                Write-Verbose "------------------------------"
                Write-Verbose "Retrieving data from $computer"
                $session = New-CimSession -ComputerName $computer -ErrorAction Stop
                $os = Get-CimInstance -ClassName win32_operatingsystem -CimSession $session
                $cs = Get-CimInstance -ClassName win32_computersystem -cimsession $session
                

                $properties = @{ComputerName = $Computer
                                Status = 'Connected'
                                SPVersion = $os.servicepackmajorversion
                                OSVersion = $os.Version
                                Model = $cs.model
                                Mfgr = $cs.Manufacturer}

            } catch {

                Write-Verbose "Couldn't connect to $computer"
                $computer | Out-File $ErrorLogFilePath -Append
                $ErrorsHappened = $True
                $properties = @{ComputerName = $Computer
                                Status = 'Disconnected'
                                SPVersion = $null
                                OSVersion = $null
                                Model = $null
                                Mfgr = $null}

            } finally {

                $obj = New-Object -TypeName PSObject -Property $properties
                $obj.psobject.typenames.insert(0,'My.Awesome.Object')
                Write-Output $obj 

            }
        }
    }
    END {
        if ($ErrorsHappened) {
            Write-Warning "OMG, errors. Logged to $ErrorLogFilePath."
        }
    }
}

function Set-ServicePassword {
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact="Medium")]
    param(
        [Parameter(Mandatory=$True)]
        [string]$ServiceName,

        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True)]
        [string[]]$ComputerName,

        [Parameter(Mandatory=$True)]
        [string]$NewPassword
    )
    BEGIN {}
    PROCESS {
        foreach ($computer in $computername) {
            try {
                $service = Get-WmiObject -ComputerName $computer -Class win32_service -Filter "Name='$servicename'" -ErrorAction Stop
                if ( $pscmdlet.ShouldProcess($computer) ) {
                    $result = $service.change($null,$null,$null,$null,$null,$null,$null,$newpassword)
                    if ($result.returnvalue -ne 0) {
                        Write-Warning "ERROR SETTING PASSWORD ON $computer : $($result.returnvalue)"
                    }
                }
            } catch {
                Write-Warning "FAILED TO SET PASSWORD ON $computer"
            }
        } #foreach computer
    } #process
    END {}
}
