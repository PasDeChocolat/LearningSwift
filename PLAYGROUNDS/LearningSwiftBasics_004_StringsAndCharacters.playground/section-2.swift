import UIKit


/*--------------------------/
// Strings and Characters
/--------------------------*/

let x: Character = "x"

// Concat with +
let phrase = "Hello" + " " + "there."

// Appending with +=
var pets = "dogs"
pets += ", cats"

// Interpolation with character
let word: String = "\(x)-ray"


/*--------------------------/
// Comparison
/--------------------------*/
x == "x"
word == "x-ray"
pets != "sharks"

word < "zzzz"
word > "aaaa"

word.hasPrefix("x-")
word.hasSuffix("ray")


/*--------------------------/
// Escaping
/--------------------------*/
"\\ "
"\t margin"
"\" double quote"
"\' double quote"


/*------------------------------/
// println (and interpolation)
/------------------------------*/
println("hello")

// Numbers:
println("pi is \(3.14)")

// With expressions
println("pi is \(22.0 / 7.0)")



