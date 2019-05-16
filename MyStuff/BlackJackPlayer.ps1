param ($ComputerName = '.')

$npipeClient = new-object System.IO.Pipes.NamedPipeClientStream($ComputerName, 'BlackJack', [System.IO.Pipes.PipeDirection]::InOut,
                                                                [System.IO.Pipes.PipeOptions]::None, 
                                                                [System.Security.Principal.TokenImpersonationLevel]::Impersonation)
$pipeReader = $pipeWriter = $null
try {
    $playerName = Read-Host 'Enter your name'
    'BlackJack player connecting to dealer'
    $npipeClient.Connect()
    'Connected to dealer'

    $pipeReader = new-object System.IO.StreamReader($npipeClient)
    $pipeWriter = new-object System.IO.StreamWriter($npipeClient)
    $pipeWriter.AutoFlush = $true
 
    $pipeWriter.WriteLine($playerName)
    $pipeReader.ReadLine()
    
    # Game loop
    while (1) {
        # Hand loop
        while (1) {      
            while (($msg = $pipeReader.ReadLine()) -notmatch 'YOURMOVE|ROUNDOVER') {
                $msg
            }
            if ($msg -match 'ROUNDOVER') { break }
            $command = Read-Host 'Enter H (hit me) or S (stand)'
            $pipeWriter.WriteLine($command)
        }

        while (($msg = $pipeReader.ReadLine()) -notmatch 'NEWDEAL') {
            $msg
        }
        $res = Read-Host 'Deal again? Y (yes) N (no)'
        if ($res -eq 'N') { 
            $pipeWriter.WriteLine('EXIT')
            break 
        }
        else {
            $pipeWriter.WriteLine('NEWDEAL')
        }
    }
}
finally {
    'Game exiting'
    $npipeClient.Dispose()
}
