$bKeepReading=$true
While ($bKeepReading) {
    $bKeepReading=$false
    $Response=read-host "please supply a value a, b, c"
    
    switch ($Response)
    {
        "a" {"good";break}
        "b" {"good";break}
        "c" {"good";break}
        default {$bKeepReading=$true}

     }
}