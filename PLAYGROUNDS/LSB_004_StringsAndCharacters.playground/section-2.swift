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


/*-------------------------------------------/
// From the Stanford C193p,
// Developing iOS8 Apps with Swift course.
//
// You want to get your index from Swift,
// because some chars take up more space than
// others. Use `advance`.
/-------------------------------------------*/
var s = "pork"
let index = advance(s.startIndex, 2)
s.splice("or man's fo", atIndex: index)
let startIndex = advance(s.startIndex, 5)
let endIndex   = advance(startIndex, 5)
let substring = s[startIndex..<endIndex]
s.replaceRange(startIndex..<endIndex, with: "woman's")


/*------------------------------/
//  Grab a range
/------------------------------*/
let num = "56.25"
if let decimalRange = num.rangeOfString(".") {
  let wholeNumberPart = num[num.startIndex..<decimalRange.startIndex]
}


/*------------------------------/
//  .toInt() : Int?
/------------------------------*/
let probablyFour: Int? = "4".toInt()
if let four = probablyFour {
  four + 2 == 6
}


/*------------------------------/
//  capitalizedString
/------------------------------*/
"hello".capitalizedString


/*------------------------------/
//  Upper / Lower
/------------------------------*/
"hello".uppercaseString
"Hello There".lowercaseString


/*------------------------------/
//  Join: Array to String
/------------------------------*/
let commaSeparated = ",".join((1...10).map{"\($0)"})
commaSeparated


/*------------------------------/
//  "Split" -> [String]
/------------------------------*/
commaSeparated.componentsSeparatedByString(",")





