$tests = @{
    'Direct Assignment' = {
        param($count)

$result = foreach($i in 1..$count) {
            $i
        }
    }
    'List<T>.Add(T)' = {
        param($count)

$result = [Collections.Generic.List[int]]::new()
        foreach($i in 1..$count) {
            $result.Add($i)
        }
    }
    'Array+= Operator' = {
        param($count)

$result = @()
        foreach($i in 1..$count) {
            $result += $i
        }
    }
}

5kb, 10kb | ForEach-Object {
    $groupResult = foreach($test in $tests.GetEnumerator()) {
        $ms = (Measure-Command { & $test.Value -Count $_ }).TotalMilliseconds

[pscustomobject]@{
            CollectionSize    = $_
            Test              = $test.Key
            TotalMilliseconds = [math]::Round($ms, 2)
        }

[GC]::Collect()
            [GC]::WaitForPendingFinalizers()
    }

$groupResult = $groupResult | Sort-Object TotalMilliseconds
        $groupResult | Select-Object *, @{
            Name       = 'RelativeSpeed'
            Expression = {
                $relativeSpeed = $_.TotalMilliseconds / $groupResult[0].TotalMilliseconds
                $speed = [math]::Round($relativeSpeed, 2).ToString() + 'x'
                if ($speed -eq '1x') { $speed } else { $speed + ' slower' }
            }
        } | Format-Table -AutoSize
}