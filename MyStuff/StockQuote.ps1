#Requires -Version 2.0

Function Get-StockQuote($symbol)

{
$symbol="MSFT"
 $URI = “http://www.webservicex.net/StockQuote.asmx?WSDL”

 $stockProxy = New-WebServiceProxy -uri $URI -namespace WebServiceProxy -class stock

 $stockProxy.getQuote($symbol)

} #end Get-StockQuote



$quote = Get-StockQuote -symbol msft

[xml]$quote |

ForEach-Object {

 $_.stockQuotes.Stock

} #end Foreach-Object


function Get-Stockquote {
    <#
    .Synopsis
    Get Stock quote for a company Symbol
    .Description
    Get Stock quote for a company Symbol
    Parameter symbol
    Enter the Symbol of the company/
    .Example
    ./Get-stockquote -Symbols ge
    This example shows how to return the stock quote for the GE stock.
    .Example
    ./Get-stockquote -Symbols "ge","mmm" | format-table
    In this example the function will return the stock quotes for GE and 3m

    #>
     [cmdletBinding()]
    Param(
        [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Mandatory=$TRUE)]
        $Symbols
        )
      foreach ($symbol in $symbols)
      {
       $webservice = New-WebServiceProxy -Uri 'http://www.webservicex.com/stockquote.asmx?WSDL'
    [xml]$Quote = $webservice.getquote($symbol)
     $props = @{
                                                    'Symbol' = $Quote.Stockquotes.stock.symbol;
                                                    'Last' = $Quote.Stockquotes.stock.last;
                                                    'Date' = $Quote.Stockquotes.stock.date;
                                                    'Time' = $Quote.Stockquotes.stock.time;
                                                    'Change' = $Quote.Stockquotes.stock.change;
                                                    'Open' = $Quote.Stockquotes.stock.open;
                                                    'High' = $Quote.Stockquotes.stock.high;
                                                    'Low' = $Quote.Stockquotes.stock.low;
                                                    'Volume' = $Quote.Stockquotes.stock.volume;
                                                    'MktCap' = $Quote.Stockquotes.stock.MktCap;
                                                    'Previous Close' = $Quote.Stockquotes.stock.PreviousClose;
                                                    'Precentage Change' = $Quote.Stockquotes.stock.PercentageChange;
                                                    'AnnRange' = $Quote.Stockquotes.stock.annrange;
                                                    'Earns' = $Quote.Stockquotes.stock.earns;
                                                    'P-E' = $Quote.Stockquotes.stock.'P-E';
                                                    'Name' = $Quote.Stockquotes.stock.name

                                                    }

                                         $obj = New-Object -TypeName PSObject -Property $props
                                         $obj.PSobject.typenames.insert(0,'VT.Weather')
                                         Write-Output $obj


    }
    }


    # Converted from bash to Powershell reference: https://github.com/alexanderepstein/Bash-Snippets/blob/master/stocks/stocks

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