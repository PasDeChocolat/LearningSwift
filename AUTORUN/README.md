# Some command-line Swift tools

#### Setup
Run `xcode-select` to point your xcrun command to a particular Xcode version. This project current tested with:
````bash
$ sudo xcode-select -switch /Applications/Xcode6-Beta6.app/Contents/Developer`
````

Then you can run one of these to get a Swift REPL:
`xcrun swift`
or
`lldb --repl`

#### Guard
Check out the `Guardfile` to see how to run a swift file from the command line.

To watch all `*.swift` files run the `guard.sh` script:
````bash
$ ./guard.sh
````

Adapted from [NSScreencast's Guardfile](https://github.com/subdigital/nsscreencast).

#### Credits

[NSScreencast](http://www.nsscreencast.com/) has a bunch of tutorials on Swift and other handy iOS topics. You should certainly [check them out](http://www.nsscreencast.com/episodes?query=swift).