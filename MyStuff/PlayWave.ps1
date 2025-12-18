Function fjPlayWav1 {
    [Alias('fjpwav')]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Object]$Path,   # accept either string or FileInfo
        [switch]$Async
    )
    Begin {
        $oPlayWave = New-Object System.Media.SoundPlayer
        write-host "`$oPlayWave of type [$($oplaywave.gettype().FullName)]"
    }
    Process {
        # Normalize input to a FileInfo object
        if ($Path -is [string]) {
            $file = Get-Item -LiteralPath $Path -ErrorAction SilentlyContinue
        }
        elseif ($Path -is [System.IO.FileInfo]) {
            $file = $Path
        }
        else {
            Write-Host "Unsupported input type: $($Path.GetType().FullName)"
            return
        }

        if ($null -ne $file -and $file.Exists) {
            Write-Host "Playing file $($file.FullName)"
            # $oPlayWave = New-Object System.Media.SoundPlayer $file.FullName
            # $playWav.SoundLocation = 'C:\Path\To\Your\File.wav'
            $oPlayWave.SoundLocation = $file.FullName
            if ($Async) {
                $oPlayWave.Play()       # async
            }
            else {
                $oPlayWave.PlaySync()   # blocking
            }
        }
        else {
            Write-Host "File not found [$Path]"
        }
    }
    End {
        write-host "Dispose"
        $oPlayWave.Dispose()
    }
}
<# 
cd "C:\Users\freds\OneDrive\Documents\EchoLink\wav"
$files=gci -filter f*
$files|fjplaywav1

 #>


Function fjPlayWav2 {
    [Alias('fjpt')]
    [CmdletBinding(DefaultParameterSetName="Single")]
    Param(
        # Single file set (allows -Async)
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ParameterSetName="Single", Position=0)]
        [System.IO.FileInfo]$Path,

        [Parameter(ParameterSetName="Single")]
        [switch]$Async,

        # Multiple files set (no -Async)
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ParameterSetName="Multiple", Position=0)]
        [System.IO.FileInfo[]]$Paths
    )

    Begin {
        Write-Verbose "Parameter set: $($PSCmdlet.ParameterSetName)"
    }

    Process {
        switch ($PSCmdlet.ParameterSetName) {
            "Single" {
                if ($Path.Exists) {
                    Write-Host "Playing single file $($Path.FullName)"
                    $oPlayer = New-Object System.Media.SoundPlayer $Path.FullName
                    if ($Async) { $oPlayer.Play() } else { $oPlayer.PlaySync() }
                    $oPlayer.Dispose()
                }
                else {
                    Write-Host "File not found [$($Path.FullName)]"
                }
            }

            "Multiple" {
                $total = $Paths.Count
                Write-Host "Playing $total files synchronously..."
                $i = 0
                foreach ($file in $Paths) {
                    $i++
                    if ($file.Exists) {
                        Write-Host "[$i/$total] Playing file $($file.FullName)"
                        $oPlayer = New-Object System.Media.SoundPlayer $file.FullName
                        $oPlayer.PlaySync()   # always sync
                        $oPlayer.Dispose()
                    }
                    else {
                        Write-Host "[$i/$total] File not found [$($file.FullName)]"
                    }
                }
            }
        }
    }
}

cd "C:\Users\freds\OneDrive\Documents\EchoLink\wav"
$files=gci -filter f*
# $files.fullname|fjplaywav2 -Async
(get-item f*) | fjpt -Verbose
# fjpt -Paths (Get-Item f*) -Verbose
