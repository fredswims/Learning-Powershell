#https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/encrypting-text-part-1

function Protect-Text
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [String]
        $SecretText,
        
        [string]
        $Password='',
        
        [string]
        [ValidateSet('CurrentUser','LocalMachine')]
        $scope = 'CurrentUser',

        [string]
        [ValidateSet('UTF7','UTF8','UTF32','Unicode','ASCII','Default')]
        $Encoding = 'Default',

        [Switch]
        $ReturnByteArray
        
    )
    begin
    {
        Add-Type -AssemblyName System.Security
        if ([string]::IsNullOrEmpty($Password))
        {
            $optionalEntropy = $null
        }
        else
        {
            $optionalEntropy = [System.Text.Encoding]::$Encoding.GetBytes($Password)
        }
    }
    process
    {
        try
        {
            $userData = [System.Text.Encoding]::$Encoding.GetBytes($SecretText)
            $bytes = [System.Security.Cryptography.ProtectedData]::Protect($userData, $optionalEntropy, $scope)
            if ($ReturnByteArray)
            {
                $bytes
            }
            else
            {
                [Convert]::ToBase64String($bytes)
            }
        }
        catch
        {
            throw "Protect-Text: Unable to protect text. $_"
        }
    }
}



function Unprotect-Text
{
    [CmdletBinding(DefaultParameterSetName='Byte')]
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="Text", Position=0)]
        [string]
        $EncryptedString,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="Byte", Position=0)]
        [Byte[]]
        $EncryptedBytes,
        
        [string]
        $Password='',
        
        [string]
        [ValidateSet('CurrentUser','LocalMachine')]
        $scope = 'CurrentUser',

        [string]
        [ValidateSet('UTF7','UTF8','UTF32','Unicode','ASCII','Default')]
        $Encoding = 'Default'
        
    )
     begin
    {
        Add-Type -AssemblyName System.Security

        if ([string]::IsNullOrEmpty($Password))
        {
            $optionalEntropy = $null
        }
        else
        {
            $optionalEntropy = [System.Text.Encoding]::$Encoding.GetBytes($Password)
        }
    }
    process
    {
        try
        {
            if ($PSCmdlet.ParameterSetName -eq 'Text')
            {
                $inBytes = [Convert]::FromBase64String($EncryptedString)
            }
            else
            {
                $inBytes = $EncryptedBytes
            }
            $bytes = [System.Security.Cryptography.ProtectedData]::Unprotect($inBytes, $optionalEntropy, $scope)
            [System.Text.Encoding]::$Encoding.GetString($bytes)
        }
        catch
        {
            throw "Unprotect-Text: Unable to unprotect your text. Check optional password, and make sure you are using the same encoding that was used during protection."
        }
    }
}
$text = "This is my secret"
$a = Protect-Text -SecretText $text -scope CurrentUser -Password zumsel
write-host "Encrypted Text: $($a)"
$b=Unprotect-Text -EncryptedString $a -scope CurrentUser -Password zumsel 
$b