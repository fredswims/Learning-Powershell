Some regex examples
sreadme -ThisMatch ^windows.*key.*\+.*u$
sprofile '^(?!#)function.*fjg.*{$'

<# 
Yes, the `?!` is used together as part of a negative lookahead in regular expressions. Here's a quick breakdown:
- The `?` character in regex has several uses, but in this context, it is combined with `!` to create a **negative lookahead assertion**.
- `!` following `?` specifically means "not followed by."

When you combine them as `?!`, it tells the regex engine to look ahead in the string and ensure that the specified pattern does *not* match at that position. 
Similarly, for positive lookahead assertions, you use `?=`, which checks that the pattern is indeed followed by the specified string.

Here are a couple of examples:
- `(?!abc)` ensures that the position is not followed by the string `abc`.
- `(?=xyz)` ensures that the position is followed by the string `xyz`.
 #>