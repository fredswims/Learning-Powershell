function Get-Ticker([string]$CompanyName, [string]$Ticker) {
    $Query = ""
    if ($CompanyName) {
        $Query = $CompanyName.Replace(' ', '+')
    }
    elseif ($Ticker) {
        $Query = $Ticker.Replace(' ', '+')
    }
    $response = Invoke-WebRequest "http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=$Query&region=1&lang=en%22"
    $data = $response.Content | ConvertFrom-Json
    $Symbol = $data.ResultSet.Result[0].symbol
    $data = Invoke-WebRequest "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$($Symbol)&apikey=KPCCCRJVMOGN9L6T"
    $stockInfo = $data.Content | ConvertFrom-Json
    $exchangeName = $($stockInfo.'Realtime Global Securities Quote'.'02. Exchange Name')
    $latestPrice = $($stockInfo.'Realtime Global Securities Quote'.'03. Latest Price')
    $open = $($stockInfo.'Realtime Global Securities Quote'.'04. Open (Current Trading Day)')
    $high = $($stockInfo.'Realtime Global Securities Quote'.'05. High (Current Trading Day)')
    $low = $($stockInfo.'Realtime Global Securities Quote'.'06. Low (Current Trading Day)')
    $close = $($stockInfo.'Realtime Global Securities Quote'.'07. Close (Previous Trading Day)')
    $priceChange = $($stockInfo.'Realtime Global Securities Quote'.'08. Price Change')
    $priceChangePercentage = $($stockInfo.'Realtime Global Securities Quote'.'09. Price Change Percentage')
    $volume = $($stockInfo.'Realtime Global Securities Quote'.'10. Volume (Current Trading Day)')
    $lastUpdated = $($stockInfo.'Realtime Global Securities Quote'.'11. Last Updated')
    $output = New-Object -TypeName PSObject
    $output | Add-Member -MemberType NoteProperty -Name ExchangeName -Value $exchangeName
    $output | Add-Member -MemberType NoteProperty -Name LatestPrice -Value $latestPrice
    $output | Add-Member -MemberType NoteProperty -Name Open -Value $open
    $output | Add-Member -MemberType NoteProperty -Name High -Value $high
    $output | Add-Member -MemberType NoteProperty -Name Low -Value $low
    $output | Add-Member -MemberType NoteProperty -Name Close -Value $close
    $output | Add-Member -MemberType NoteProperty -Name priceChange -Value $priceChange
    $output | Add-Member -MemberType NoteProperty -Name PriceChangePercentage -Value $priceChangePercentage
    $output | Add-Member -MemberType NoteProperty -Name Volume -Value $volume
    $output | Add-Member -MemberType NoteProperty -Name lastUpdated -Value $lastUpdated
    $output
}
Get-Ticker -ticker "ge"
