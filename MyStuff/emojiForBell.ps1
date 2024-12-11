<# 
Great question! 
This has to do with how Unicode characters outside the Basic Multilingual Plane (BMP) are represented. 
Unicode characters are usually represented as a single 16-bit value (one char), which works fine for most characters. 
However, some characters, like emojis and certain symbols, have code points that require more than 16 bits.

The bell emoji (🔔), for example, is represented by the code point `U+1F514`. 
Since this is beyond the BMP, it needs to be represented as a surrogate pair in UTF-16 encoding, 
which is what Windows and PowerShell use.

A surrogate pair is a way of encoding these higher code points using two 16-bit values. 

For U+1F514, the surrogate pair is:
0xD83D (high surrogate)
0xDD14 (low surrogate)

By splitting it into these two 16-bit values, PowerShell can correctly represent and handle the character. 
This is why we needed to use both [char]0xD83D and [char]0xDD14 to form the complete emoji.

It's a bit technical, but it ensures that all the characters, regardless of their position in Unicode, are properly handled! 😊

 #>
$bellStr = [char]0xD83D + [char]0xDD14 #concatenating each surrogate into a 32 bit string. 
    # Adding (concatenating) these two together forms the full Unicode character for the bell emoji.
    # This will correctly render the bell emoji in PowerShell.
$bellStr.GetType() # Name=String
$bellStr.GetTypeCode() # String
$bellStr|get-member #TypeName:System.String
$bellStr.Length
$bellStr.Chars(0)
$bellStr.Chars(1)
$bellStr # output the emoji 🔔

# To convert and inspect the content of the $bell emoji, you can convert it into its UTF-32 code points. 
# Here's how you can do it in PowerShell:

$bellstr = [char]0xD83D + [char]0xDD14
$bellBytes = [System.Text.Encoding]::UTF32.GetBytes($bellstr)
foreach ($byte in $bellBytes) {
    Write-Output $byte
}
# This will output the byte values of the bell emoji in UTF-32 encoding.

"If you want to inspect the individual surrogate pairs, you can do this:"
$bellStr = [char]0xD83D + [char]0xDD14
$bellStr
$codePoints = $bellStr.ToCharArray()
foreach ($cp in $codePoints) {
    $cpValue = [int][char]$cp
    # Write-Output $cpValue # 55357 and 56596
    "Integer Value is [{0}]" -f $cpValue
}
<# 
In this code:
    $highSurrogate stores the high surrogate pair [char]0xD83D.
    $lowSurrogate stores the low surrogate pair [char]0xDD14.
    and
    $bellStr concatenates these two variables to form the complete bell emoji string.
Outputting $bellStr will show the bell emoji (🔔). This way, you can manage and manipulate each surrogate pair independently.

 #>
$highSurrogate = [char]0xD83D
$lowSurrogate = [char]0xDD14
$bellStr = $highSurrogate + $lowSurrogate
Write-Output $bellStr
<# 
It can definitely get a bit tricky, especially when dealing with different types and casting in PowerShell. 
The key is to understand when you need to explicitly convert types to achieve the desired behavior.

Here are a few tips to keep in mind:
1. Character vs. Integer: 
    If you need to work with characters and their corresponding Unicode values, 
    you'll often need to cast integers to `[char]` to get the actual character representation.
2. Strings vs. Single Characters: 
    Concatenating single characters to form strings requires understanding how each character is represented, 
    especially for characters outside the Basic Multilingual Plane, like emojis.
3. **Type Conversion**: 
    PowerShell is quite flexible with type conversion, but sometimes you'll need to be explicit. 
    For example, `[int]`, `[char]`, `[string]` to convert variables into these types.

 #>