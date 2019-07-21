<#
https://adamtheautomator.com/build-powershell-menu/
#>
function New-Menu {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Title,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Question
    )

    $red = New-Object System.Management.Automation.Host.ChoiceDescription '&Red', 'Favorite color: Red'
    $blue = New-Object System.Management.Automation.Host.ChoiceDescription '&Blue', 'Favorite color: Blue'
    $yellow = New-Object System.Management.Automation.Host.ChoiceDescription '&Yellow', 'Favorite color: Yellow'

    $options = [System.Management.Automation.Host.ChoiceDescription[]]($red, $blue, $yellow)

    $result = $host.ui.PromptForChoice($Title, $Question, $options, 0)

    switch ($result) {
        0 { 'Your favorite color is Red' }
        1 { 'Your favorite color is Blue' }
        2 { 'Your favorite color is Yellow' }
    }

}
new-menu -Title "wow this is cool" -Question "What is your favorite color"