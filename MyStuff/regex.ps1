Some regex examples
sreadme ^windows.*key.*\+.*u$
sprofile '^(?!#)function.*fjg.*{$'

<# 
Absolutely! Let’s break down the `(?!#)` part of the regex:

- `(?!)`: This is a **negative lookahead assertion**. It's a type of zero-width assertion that specifies a position in the string where a certain pattern must *not* match. In simpler terms, it looks ahead in the string to see if a certain pattern is present, and if it is, the match fails.
- `#`: This is the character we're looking for in the negative lookahead. In this context, it checks to see if the `#` character is at the position being considered.

So, the complete expression `(?!#)` ensures that the current position in the string is *not* followed by a `#` character. 

When combined in the regex `^(?!#).*`, it means "match any line that does not start with a `#`". Here's a quick summary:

- `^` asserts position at the start of a line.
- `(?!#)` ensures that the following character is not `#`.
- `.*` matches any character (except newline) zero or more times.
- `$` asserts position at the end of a line.

Is there anything else you'd like to know about regular expressions or anything else?


Yes, the `?!` is used together as part of a negative lookahead in regular expressions. Here's a quick breakdown:
- The `?` character in regex has several uses, but in this context, it is combined with `!` to create a **negative lookahead assertion**.
- `!` following `?` specifically means "not followed by."

When you combine them as `?!`, it tells the regex engine to look ahead in the string and ensure that the specified pattern does *not* match at that position. 
Similarly, for positive lookahead assertions, you use `?=`, which checks that the pattern is indeed followed by the specified string.

Here are a couple of examples:
- `(?!abc)` ensures that the position is not followed by the string `abc`.
- `(?=xyz)` ensures that the position is followed by the string `xyz`.
 #>