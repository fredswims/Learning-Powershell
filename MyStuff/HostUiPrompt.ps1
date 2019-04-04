$fields = @(
    New-Object "System.Management.Automation.Host.FieldDescription" "Input"
    New-Object "System.Management.Automation.Host.FieldDescription" "Input List"
)
$fields[1].SetParameterType([int[]])

$host.UI.Prompt("Caption", "Message", $fields)