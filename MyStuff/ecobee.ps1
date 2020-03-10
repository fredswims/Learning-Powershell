#remember to rename the Worksheet to 'den'
#"C:\Users\freds_000\Downloads\2020-01-30Den.xlsx"
$den=import-excel -path $home/downloads/2020-01-30Den.xlsx -WorksheetName den

$den|ForEach-Object -Process {
    if ( `
    ($psitem."system setting" -eq "heat") `
    -and ($psitem."Heat Set Temp (F)" -gt $psitem."Current Temp (F)") `
    #     -and ($psitem."System Mode" -eq "heatStage1On") `
    ) {
        "{3} T {4}: TurnsOn {0:n2} degress below the setpoint. Mode:{1} DenSmartDropsTo:{2:n2} SetPoint {5}" `
        -f $($psitem."Heat Set Temp (F)" - $psitem."Current Temp (F)"), `
        $psitem."System Mode", `
        $psitem."DENsmart (F)", `
        $psitem.date.ToShortDateString(), `
        $psitem.time.toshorttimestring(), `
        $psitem."Heat Set Temp (F)"
    }
}
#Use this One.
#boiler is triggered when the room temperature drops how far below the setpoint?
function EcoDen {
$MyPath=join-path $home/downloads "ereport.xlsx"
$den=import-excel -path $MyPath -WorksheetName den -StartRow 6
$den1=$den|where-object  {$psitem."System Setting" -eq "heat"} #eliminates partial rows at end of good data.
# splates
$Date = @{label="Date";expression={$psitem.date.ToShortDateString()}}
$Time = @{label="Time";expression={$psitem.time.ToShortTimeString()}}
$DevSetPoint = @{label="DevSetPoint";expression={"{0,4:n1}" -f $($psitem."Current Temp (F)" - $psitem."Heat Set Temp (F)") }}
$DenSmart=@{label="DenSmart";expression={"{0:n1}" -f $psitem."DENsmart (F)"}}
$HeatSetPoint=@{label="HeatSetPoint";expression={"{0:n1}" -f $psitem."Heat Set Temp (F)"}}

$den2=$den1|Select-Object $Date,$Time,"Calendar Event","Program Mode",$DevSetPoint,"System Mode",$DenSmart,$HeatSetPoint
$den2|Out-GridView
}

$den1|ForEach-Object -Process {
    if ( $psitem."system setting" -eq "heat") {
        "<{3} T {4}> {6}{7} devFromSetPoint {0:n2} degress below the setpoint. Mode:{1} DenSmartDropsTo:{2:n2} SetPoint {5}" `
         -f $($psitem."Current Temp (F)" - $psitem."Heat Set Temp (F)" ), `
            $psitem."System Mode", `
            $psitem."DENsmart (F)", `
            $psitem.date.ToShortDateString(), `
            $psitem.time.toshorttimestring(), `
            $psitem."Heat Set Temp (F)", `
            $psitem."Calendar Event", `
            $psitem."Program Mode"

    }
}
$den