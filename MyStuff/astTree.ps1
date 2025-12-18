function Get-AstTree {
    param (
        [string]$Code
    )
    #Parse input and extract AST
    $null = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$null, [ref]$null)
    return $ast
}

function Show-AstNodes {
    param (
        [System.Management.Automation.Language.Ast]$Ast
    )
    #Visualize AST Nodes
    $Ast.FindAll({ $true }, $true) | ForEach-Object {
        [PSCustomObject]@{
            NodeType = $_.GetType().Name
            Extent   = $_.Extent.Text
            Parent   = $_.Parent?.GetType().Name
        }
    }
}
#Usage Example

# $code = '[string]$PSVersionTable.PSVersion'
$code='Get-childitem -recurse -path $env:userprofile -filter *.ps1'
$code= 'foreach ($file in $files){$psitem.fullname}'
$ast = Get-AstTree -Code $code
Show-AstNodes -Ast $ast
