for ($i = 0; $i -lt 20; $i++) {
    for ($i = 0; $i -lt 2; $i++) { $t = 2; for ($i = 1; $i -lt 171; $i++) { $t = $t * $i; "count {0} value {1}" -f $i, $t } }
    for ($i = 0; $i -lt 2; $i++) { $t = 2; for ($i = 1; $i -lt 1024; $i++) { $t = [Math]::Pow(2, $i); "count {0} value {1}" -f $i, $t } }
    for ($i = 0; $i -lt 20; $i++) { get-uptime }
    for ($i = 0; $i -lt 2; $i++) { get-uptime -Since; ShowWindowsComputerInfo }
}