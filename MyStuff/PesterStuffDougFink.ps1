cls
#Get Largest Number In Array
function Get-LargestNumber {
    Param([int[]]$list)
    # ($list |measure-object -Maximum).Maximum

    $Max=[int]::MinValue
    $Min=[int]::MaxValue
    $min | Out-File -FilePath testThis.txt -Force
    
    #"The maximum value is {0}" -f $max
    #write-host "initial $max"
    for ($i=0; $i -lt $list.count; $i++){
        if($list[$i] -gt $max) {
        $max=  $list[$i]
        }
    }
    $max
}


describe "Get Largest Number In Array" {

    it "Should be 3" {
        $actual=Get-LargestNumber 2,3,1
        $actual | should be 3
     }
         it "Should be 5" {
        $actual=Get-LargestNumber 5,1,2
        $actual | should be 5
     }
       it "Should be 1000000" {
       $actual=Get-LargestNumber (0..1000000)
       $actual | should be 1000000
    }
           it "Should be -1" {
        $actual=Get-LargestNumber -5,-1,-2
        $actual | should be -1
     }
              it "Should be 7" {
        $actual=Get-LargestNumber 5,1,2,7
        $actual | should be 7
     }
}
Get-LargestNumber 5,1,2,7
