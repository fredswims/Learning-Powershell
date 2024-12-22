# Define the string
$string = "cd ~"

# Convert the string to a byte array
$bytes = [System.Text.Encoding]::UTF8.GetBytes($string)

# Convert each byte to a hexadecimal string
$hexString = -join ($bytes | ForEach-Object { $_.ToString("X2") })

# Display the hexadecimal string
$hexString

# Prepend "0x" to the hexadecimal string
$hexStringWithPrefix = "0x" + $hexString

# Display the hexadecimal string with prefix
$hexStringWithPrefix
