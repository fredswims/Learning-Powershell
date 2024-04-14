function Prime-Numbers {
    param (
        [Parameter(ValueFromPipeline=$true)]
        [int]$range=100
    )
    Process {
        $top=$range;$n=0;for ($i=1;$i -le $top;$i++) {$return= test-prime $i; if( $return[-1] -eq 'True'){$n++;write-warning "TRUE $($i) ::$($n)::$($top)"}}
    }
}
function Test-Prime {
    param (
        [Parameter(ValueFromPipeline=$true)]
        [int64]$number
    )

    Process {
        $prime = $true

        # If the number is less than or equal to 1, it's not prime
        if ($number -le 1) {
            $prime = $false
        }
        else {
            # Check divisibility from 2 up to the square root of the number
            $sqrt = [math]::Sqrt($number)
            for ($i = 2; $i -le $sqrt; $i++) {
                "Input is [{0}] Square root is [{1}] Index is [{2}].  " -f $number, $sqrt, $i
                if ($number % $i -eq 0) {
                    $prime = $false
                    break
                }
            }
        }

        return $prime
    }
}
$top=10000;$n=0;for ($i=1;$i -le $top;$i++) {$return= test-prime $i; if( $return[-1] -eq 'True'){$n++;write-warning "TRUE $($i) ::$($n)::$($top)"}}