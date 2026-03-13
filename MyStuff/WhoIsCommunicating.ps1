[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [Switch]
    $OutGrid
)
# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/identifying-unknown-network-listeners
# Who is communitcating with my computer?
# Invoke-RestMethod -Uri 'http://ipinfo.io/51.107.59.180/json'
write-warning ("[$(Get-Date -Format "dddd MM/dd/yyyy HH:mm:ss K")]`n`t [$PSCommandPath]")
#region Who Am I
Write-Warning (
    "`n`t[$(Get-Date -Format 'dddd MM/dd/yyyy HH:mm:ss K')]"+
    # "`n`tIn function [$($MyInvocation.MyCommand.Name)] " +
    "`n`tIn script   [$PSCommandPath]: " + 
    "`n`tShow Internet Traffic on port 443 " 
)
#endregion
$Process = @{
    Name       = 'Process'
    Expression = {
        # return process path
        split-path -leaf -path $((Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).Path).trim()
    }
}

<# 
$ProcessSplat = @{
    Name       = 'Process'
    Expression = {
        # return process path
        # (Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).Path
        $path = ""
        $path=split-path -leaf -path $((Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).Path)
        if($path) {$path} else {"PID: $($_.OwningProcess)"}

    }
}
#> 

$IpOwner = @{
    Name       = 'RemoteAuthority'
    Expression = {
        $ip = $_.RemoteAddress
        $info = Invoke-RestMethod -Uri "http://ipinfo.io/$ip/json"
        # $Info.Org consists of the ASN (Autonomous System Number) and the name of the organization that owns the IP address.
        # e.g. AS15169 Google LLC 
        # e.g. Mountain View
        '{0} ({1})' -f $info.Org, $info.City 

    }
}


# get all connections to port 443 (HTTPS)
Get-NetTCPConnection -RemotePort 443 -State Established | 
# where there is a remote address
Where-Object RemoteAddress |
# and resolve IP and Process ID
# Select-Object -Property $IPOwner, RemoteAddress, OwningProcess, $Process

# reorder output and narrow OwningProcess by use a calculated Splat.
Select-Object -Property $IPOwner, RemoteAddress, $Process, @{ N ='PID'; E = {$_.OwningProcess}}  

<# 
$NetConx=Get-NetTCPConnection -RemotePort 443 -State Established
$RealNetConx=$NetConx| Where-Object RemoteAddress
$RealNetConx|Select-Object -Property $IPOwner, RemoteAddress, $Process, @{ N ='PID'; E = {$_.OwningProcess}} 
#>