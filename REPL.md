
```` bash
# Optional
$ sudo xcode-select -s /Applications/Xcode.app

```` bash
# Run the SWIFT REPL on Mavericks:
$ xcrun swift

# Run the SWIFT REPL on Yosemite:
$ swift

# If it doesn't work, run it twice.
# (You should only have to do the first time, if at all.)
$ xcrun swift
````

Some basic commands:
```` swift
// For a help menu:
> :help

// To exit:
> :exit
````

You can reuse values:
```` swift
> 100
$R0: Int = 100
> $R0 + 200
$R1: Int = 300
````

# References
- [Introduction to the Swift REPL, with Quick Reference](https://developer.apple.com/swift/blog/?id=18)