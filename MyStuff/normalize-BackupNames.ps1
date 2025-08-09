function Normalize-BackupNames {
    param (
        [Parameter(Mandatory)]
        [string[]]$Names
    )

    $Names | ForEach-Object {
        if ($_ -match 'home-(\d{4}-\d{2}-\d{2})\.(AM|PM)(\d{2})\.(\d{2})\.QDF-backup') {
            $date = $matches[1]
            $meridian = $matches[2]
            $hour = [int]$matches[3]
            $minute = $matches[4]

            # Convert to 24-hour time
            if ($meridian -eq 'PM' -and $hour -lt 12) {
                $hour += 12
            } elseif ($meridian -eq 'AM' -and $hour -eq 12) {
                $hour = 0
            }

            $hourStr = $hour.ToString("D2")
            "home-$($date)T$hourStr.$minute.QDF-backup"
        } else {
            Write-Warning "Unrecognized format: $_"
            $_
        }
    }
}

$rawNames = @(
    'home-2024-08-31.AM11.38.QDF-backup',
    'home-2024-08-31.PM11.38.QDF-backup',
    'home-2024-08-31.AM12.00.QDF-backup',
    'home-2024-08-31.PM12.00.QDF-backup'
)

$normalizedNames = Normalize-BackupNames -Names $rawNames
clear-host
$normalizedNames