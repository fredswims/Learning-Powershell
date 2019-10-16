class Computer {
    [string] Execute() {
        return "$this executes a program"
    }
}

class Synthesizer {
    [string] Play() {
        return "$this is playing an electronic song"
    }
}

class Human {
    [string] Speak() {
        return "$this says hello"
    }
}

class Adapter {
    [object] static Adapt($obj, $alias, $referenced) {

        # doesn't work
        # return $obj | Add-Member -PassThru -Force -MemberType ScriptMethod -Name $alias -Value {$this.$referenced}

        # Use Invoke-Expression
        return ("`$obj | Add-Member -PassThru -Force -MemberType ScriptMethod -Name $alias -Value {`$this.$referenced}") | Invoke-Expression
    }
}



$targetObjects = @()
$targetObjects+= [Computer]::new()

$o=[Synthesizer]::new()
$targetObjects+=[Adapter]::Adapt($o, "execute", "play()")

$o=[Human]::new()
$targetObjects+=[Adapter]::Adapt($o, "execute", "speak()")

$targetObjects.Execute()
