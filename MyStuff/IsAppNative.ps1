<# 
Native AOT (Ahead-of-Time) compilation is a powerful technique in .NET that allows developers to compile applications directly to native machine code at publish time—bypassing the need for a JIT (Just-In-Time) compiler at runtime. Here's a breakdown tailored for programmers working with or exploring Native AOT:

---

### 🧠 What Is Native AOT?

- **Ahead-of-Time Compilation**: Converts IL (Intermediate Language) code into native machine code during the build/publish phase.
- **Self-contained Executables**: Produces a single binary that includes everything needed to run, even without the .NET runtime installed.
- **Performance Boosts**:
  - Faster startup time
  - Lower memory usage
  - Smaller disk footprint
  - Ideal for microservices, CLI tools, and containerized apps

---

### 👨‍💻 Who Are Native AOT Programmers?

Native AOT programmers are typically .NET developers who:

- Optimize for **performance-critical scenarios**, like cloud infrastructure or embedded systems.
- Work with **restricted environments** (e.g., where JIT isn't allowed).
- Build **cross-platform apps** targeting Windows, Linux, or macOS.
- Use tools like:
  - `dotnet publish -r win-x64 -c Release`
  - `<PublishAot>true</PublishAot>` in project files

---

### 🛠️ Skills and Considerations

Native AOT developers often need to:

- **Audit dependencies** for AOT compatibility (`IsAotCompatible` flag).
- **Avoid reflection-heavy or dynamic code**, which may break under AOT.
- **Use trimming and analyzers** to reduce unused code and catch incompatibilities.
- **Test thoroughly**, since some ASP.NET Core features (like MVC or Blazor Server) aren't fully supported

---

### 🚀 Use Cases

| Scenario                        | Why Native AOT Helps                     |
|--------------------------------|------------------------------------------|
| CLI tools                      | Instant startup, minimal footprint       |
| Microservices in containers    | Smaller images, faster deployment        |
| Serverless functions           | Cold-start latency reduction             |
| Embedded systems               | No runtime dependency, tight control     |

---

If you're curious about diving deeper or want help adapting your existing .NET projects to Native AOT, I can walk you through the process or help refactor code for compatibility. Want to explore a sample project or benchmark some performance gains?

#>
<# 
is there some attribute visible in filemanager or taskmanager that indicates a program is Native AOT?
Great question, Fred. Unfortunately, **there’s no direct attribute or column in File Explorer or Task Manager** 
that explicitly labels a program as Native AOT. But there are a few indirect clues and techniques that can help you identify one:

---

### 🕵️‍♂️ How to Spot a Native AOT Executable

#### 1. **File Characteristics in Explorer**
- **Single, self-contained `.exe`**: Native AOT apps are typically published as a single executable with no dependency on the .NET runtime.
- **No `.dll` files**: Unlike framework-dependent apps, you won’t see accompanying assemblies like `System.Private.CoreLib.dll`.
- **Smaller size than expected** (if trimmed) or **larger size** (if not trimmed), depending on what's bundled.

#### 2. **Task Manager Clues**
- **No `dotnet.exe` parent process**: Native AOT apps run directly as executables, not hosted by the .NET runtime.
- **Lower memory footprint and faster startup**: These are behavioral clues, not definitive markers.

#### 3. **PE Header Inspection**
You can use tools like [PE Explorer](https://www.heaventools.com/overview.htm), [CFF Explorer](https://ntcore.com/?page_id=388), or even PowerShell to inspect the executable:

Powershell
#>
Function FileSignature {

# Display the first few bytes (e.g., first 16 bytes as hex)
# This will give you a hex dump of the beginning of the file, 
# which is useful for identifying
# PE headers or signatures like MZ (0x4D 0x5A) and later PE (0x50 0x45).
# This will give you a hex dump of the beginning of the file, which is useful for identifying PE headers or signatures like  (0x4D 0x5A) and later  (0x50 0x45).

$pathToExe = "C:\Program Files\KeePass Password Safe 2\KeePass.exe"
$bytes = [System.IO.File]::ReadAllBytes($pathToExe)
$bytes = [system.io.file]::
# Display the first few bytes (e.g., first 16 bytes as hex)
$bytes[0..15] | ForEach-Object { "{0:X2}" -f $_ }
$signature = [System.Text.Encoding]::ASCII.GetString($bytes[0x00..0x0F])
    "`$signature is [{0}]" -f $signature
}
# FileSignature
# Read-Host "Halt"
<#
Or use `dumpbin /headers MyApp.exe` to look for native code sections. Native AOT executables will show native machine code sections and lack CLR metadata.

#### 4. **Use `corflags` Tool**
Run this on the `.exe`:

```bash
corflags MyApp.exe
```

If it says:
- `PE` is `PE32` or `PE32+`
- `CLR Header` is **absent**

Then it’s likely Native AOT. Traditional .NET apps will show a CLR header.

---
#>
### 🧪 Bonus: Programmatic Detection

# You can also write a script to check for the presence of CLR metadata:

# ```powershell
function Test-IsNativeAOT {
    param([string]$Path)
    $bytes = [System.IO.File]::ReadAllBytes($pathToExe)
    # $bytes = Get-Content $Path -Encoding Byte
    # Look for "BSJB" signature of CLR metadata - 
    # Look for "PE" signature of Native AOT
    $signature = [System.Text.Encoding]::ASCII.GetString($bytes[0x80..0x83])
    $signature = [System.Text.Encoding]::ASCII.GetString($bytes[0x00..0x01])
    "`$signature is [{0}]" -f $signature
    return ($signature -ne "BSJB")
}
# Test-IsNativeAOT "C:\Program Files\KeePass Password Safe 2\KeePass.exe"
#Test-IsNativeAOT "C:\Program Files\WindowsApps\Microsoft.WindowsNotepad_11.2504.62.0_arm64__8wekyb3d8bbwe\Notepad\Notepad.exe"
#>

# Would you like help building a PowerShell utility to
#  scan a folder and flag likely Native AOT binaries? Or maybe a script to compare startup times across builds?

# List all static methods and their parameters for a given .NET type
$typeName = 'System.IO.File'
$type = [Type]::GetType($typeName)
$staticMethods = $type.GetMethods([System.Reflection.BindingFlags]::Static -bor [System.Reflection.BindingFlags]::Public)

$staticMethods | ForEach-Object {
    $params = $_.GetParameters() | ForEach-Object { "$($_.ParameterType.Name) $($_.Name)" }
    [PSCustomObject]@{
    # $obj=[PSCustomObject]@{
        Method = $_.Name
        Parameters = ($params -join ', ')
    }
<# 
    Write-Debug "Built object: $($obj | Out-String)" # $DebugPreference = 'Continue'
    $obj
     #>
} | Format-Table -AutoSize