
Add-Type @"
using System;
public class MyHelper {
    public static void SayHi() {
        Console.WriteLine("Hi Fred!");
    }
}
"@
#how to invoke the static function
#refer to its class and method in dot notation.
[MyHelper]::SayHi()

<#
Excellent observation, Fred — yes, when you 
include `using` statements inside 
a `Add-Type @"..."@` block in PowerShell, those lines are part of the actual C#
source code being compiled **at runtime** into a .NET assembly.

---

### 🧱 What Happens Behind the Scenes

When you run:

powershell
Add-Type @"
using System;
public class MyHelper {
    public static void SayHi() {
        Console.WriteLine("Hi Fred!");
    }
}
"@
#>
<# 
PowerShell does the following:

1. 📦 **Wraps the C# code into a temporary string**
2. 🏗️ **Passes it to the CSharpCodeProvider compiler**
3. ⚙️ **Compiles it into an in-memory .NET assembly**
4. 📚 **Loads that assembly into the current PowerShell session**
5. 🧠 **Makes the class and its methods available for use via dot notation**

So yes — the "using System;" statement is real C# 
syntax and must end in a semicolon **because it's parsed and compiled by the actual C# compiler**,
not interpreted by PowerShell.

### 🔍 Where It’s Compiled

It’s compiled in memory unless you specify parameters like
`-OutputAssembly` to generate a DLL. 
Most of the time, `Add-Type` just creates **transient types** that vanish when the session ends.

---

Would you like help turning one of your embedded C# blocks into a reusable DLL, 
or exploring `Reflection` to inspect compiled types after the fact? 
You strike me as the type who’d enjoy peeking under the hood.
 #>
<# 
 In C#, the semicolon (;) is the official “end-of-statement” marker — 
 it tells the compiler, “I’m done with this instruction, you can move on.”

🧠 Why Does using System; Need a Semicolon?

Because it’s a directive, not a block or declaration. Specifically:

using System; tells the compiler to include the System namespace so you can reference its types
(like Console, DateTime, etc.) without qualifying them.

As a statement, it must terminate with a semicolon — just like int x = 5; or Console.WriteLine("Hi");

🚫 When Don’t You Use Semicolons?

Class and method definitions: These are enclosed in {} blocks.

public class Hello {
    public void SayHi() {
        Console.WriteLine("Hi Fred!");  // ← semicolon here
    }
}  // ← no semicolon after class/method

Namespace declarations: also wrapped with {} and don’t end with semicolons.

💡 Fun Fact

Even though using System; looks simple, it unlocks powerful functionality — otherwise, 
you’d need to write:
System.Console.WriteLine("Hello!");
Want to see how deeply nested some namespace dependencies go, or how aliasing with using X = Y.Z; can cut down on verbosity in a larger script? I can show you a few tricks to tidy your Add-Type blocks.
 #>