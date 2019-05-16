#https://rkeithhill.wordpress.com/2014/11/01/windows-powershell-and-named-pipes/
$suits = 'Clubs','Diamonds','Hearts','Spades'
$ranks = 'Ace','2','3','4','5','6','7','8','9','10','Jack','Queen','King'

function GetShuffledDeck {
    $deck = 0..3 | Foreach {$suit = $_; 0..12 | Foreach { 
                      $num = if ($_ -eq 0) {11} elseif ($_ -ge 10) {10} else {$_ + 1}
                      [pscustomobject]@{Suit=$suits[$suit];Rank=$ranks[$_];Value=$num}}
                   }
    for($i = $deck.Length - 1; $i -gt 0; --$i) {
        $rndNdx = Get-Random -Maximum ($i+1)
        $temp = $deck[$i]
        $deck[$i] = $deck[$rndNdx]
        $deck[$rndNdx] = $temp
    }
    $deck
}

function GetValueOfHand($hand) {
    $sum = ($hand | Measure-Object Value -Sum).Sum
    if ($sum -gt 21) {
        $sum = ($hand | Foreach {if ($_.Value -eq 11) {1} else {$_.Value}} | Measure-Object -Sum).Sum
    }
    $sum
}

function IsHandBust($hand) {
    (GetValueOfHand $hand) -gt 21
}

function IsHandBlackJack($hand) {
    if ($hand.Length -ne 2) { return $false }
    (GetValueOfHand $hand) -eq 21
}

function DumpHand($hand) {
    $cards = $hand | Foreach {DumpCard $_}
    $OFS = ', '
    "$cards"
}

function DumpCard($card) {
    "$($card.Rank) of $($card.Suit)"
}

$cardNdx = -1
$deck
function DealCard {
    if ($cardNdx -lt 0) {
        WriteToPipeAndLog 'Deck empty, reshuffling deck' > $null
        $script:deck = GetShuffledDeck
        $script:cardNdx = $deck.Length - 1
    } 
    $deck[$script:cardNdx--]
}

$pipeWriter
function WriteToPipeAndLog($msg) {
    $msg 
    $pipeWriter.WriteLine($msg)
}

$npipeServer = new-object System.IO.Pipes.NamedPipeServerStream('BlackJack', [System.IO.Pipes.PipeDirection]::InOut)
try {
    'BlackJack dealer started'
    'Waiting for client connection'
    $npipeServer.WaitForConnection()
    'Connection established'

    $pipeReader = new-object System.IO.StreamReader($npipeServer)
    $script:pipeWriter = new-object System.IO.StreamWriter($npipeServer)
    $pipeWriter.AutoFlush = $true

    $playerName = $pipeReader.ReadLine()
    WriteToPipeAndLog "Connected to $playerName."

    # Outer game loop
    while (1)
    {
        WriteToPipeAndLog 'Starting new game -----------------------------------------'
        $playerHand  = @(DealCard)
        $dealerHand  = @(DealCard)
        $playerHand += DealCard
        $dealerHand += DealCard

        WriteToPipeAndLog "Dealer's hand is $(DumpCard $dealerHand[0]), hole card"
        WriteToPipeAndLog "$playerName hand is $(DumpHand $playerHand)"

        $playerDealtBlackJack = IsHandBlackJack $playerHand
        $dealerDealtBlackJack = IsHandBlackJack $dealerHand

        if ($playerDealtBlackJack -and $dealerDealtBlackJack) {
            WriteToPipeAndLog "Both the Dealer and $playerName get BLACKJACK. The game is a push"
        }
        elseif (IsHandBlackJack $playerHand) {
            WriteToPipeAndLog "$playerName gets BLACKJACK and wins!"
        }
        elseif (IsHandBlackJack $dealerHand) {
            WriteToPipeAndLog 'Dealer gets BLACKJACK and wins!'
        }
        else {
            # Let's play this hand
            $dealerBusts = $false
            $playerBusts = $false

            # Player's turn
            while (1) {
                $stand = $false
                $invalidKey = $false
                $pipeWriter.WriteLine('YOURMOVE')
                $command = $pipeReader.ReadLine()
                switch ($command) {
                    'H'      { }
                    'S'      { $stand = $true }
                    default { $invalidKey = $true }
                }

                if ($invalidKey) {
                    WriteToPipeAndLog "Sorry $playerName, didn't recognize command: '$command'"
                    continue
                }
                elseif ($stand) {
                    WriteToPipeAndLog "$playerName stands with hand $(DumpHand $playerHand)"
                    break
                }
                else {
                    $newCard = DealCard
                    $playerHand += $newCard
                    WriteToPipeAndLog "$playerName drew a $(DumpCard $newCard), updated hand $(DumpHand $playerHand)"
                    if (IsHandBust $playerHand) {
                        $playerBusts = $true
                        break
                    }
                }
            }

            # Dealer's turn
            WriteToPipeAndLog "DEALER's hand is $(DumpHand $dealerHand)"
            if (!$playerBusts) {
                do {
                    $dealerSum = GetValueOfHand $dealerHand
                    if ($dealerSum -gt 21) {
                        $dealerBusts = $true
                        break;
                    }
                    elseif ($dealerSum -ge 17) {
                        WriteToPipeAndLog "DEALER stands with $(DumpHand $dealerHand)"
                        break
                    }

                    $newCard = DealCard
                    $dealerHand += $newCard
                    WriteToPipeAndLog "Dealer draws $(DumpCard $newCard), updated hand $(DumpHand $dealerHand)"

                    Start-Sleep -Seconds 1
                } while (1)
            }

            # Determine who won
            if ($playerBusts) {
                WriteToPipeAndLog "$playerName busts with $(DumpHand $playerHand)"
                WriteToPipeAndLog "DEALER wins with $(DumpHand $dealerHand)"
            }
            elseif ($dealerBusts) {
                WriteToPipeAndLog "DEALER busts with $(DumpHand $dealerHand)"
                WriteToPipeAndLog "$playerName wins with $(DumpHand $playerHand)"
            }
            else {
                $dealerSum = GetValueOfHand $dealerHand
                $playerSum = GetValueOfHand $playerHand
                if ($dealerSum -gt $playerSum) {
                    $msg = "DEALER wins with $(DumpHand $dealerHand)"
                }
                elseif ($playerSum -gt $dealerSum) {
                    $msg = "$playerName wins with $(DumpHand $playerHand)"
                }
                else {
                    $msg = 'The game is a push'
                }
                WriteToPipeAndLog $msg
            }
        }

        $pipeWriter.WriteLine('ROUNDOVER')
        $pipeWriter.WriteLine('NEWDEAL')
        $command = $pipeReader.ReadLine()
        if ($command -eq 'EXIT') { break }
    }

    Start-Sleep -Seconds 2
}
finally {
    'Game exiting'
    $npipeServer.Dispose()
}
