import UIKit


/*---------------------/
   Basics
/---------------------*/

// This is a comment.
println("hello") // Another comment
/* A bigger 
   ...
   comment. */
/* Another
   big
/* comment
   here */
*/

// You can also import just submodules and features.
// Features can be var, func, class, struct, enum, protocol, or typealias
//import UIKit
import var Foundation.NSTimeIntervalSince1970


/*---------------------/
// Types
/---------------------*/
let word = "hello" // This is a String
let anotherWord : String = "hi"

let doubleNum = 3.14
let floatNum : Float = 3.14

typealias MyByte = UInt8


/*--------------------------/
// Bin and Hex, and Numbers
/--------------------------*/
let binary = 0b01010
let hex = 0xAB
let oct = 0o12
let someNumber = 42_012_123


/*--------------------------/
// println
/--------------------------*/
println("hello")
println("pi is \(3.14)")
println("pi is \(22.0 / 7.0)")





/*---------------------/
   Optionals
// Why use implicitly unwrapped and lazy properites:
//   http://www.scottlogic.com/blog/2014/11/20/swift-initialisation.html
/---------------------*/

var myName : String? // = "Kyle" // to make it have a value
if myName == nil {
  "no name here"
} else {
  "my name is \(myName)"
}

let scores = ["kyle": 111, "newton": 80]
let kylesScore : Int? = scores["kyle"]

if kylesScore != nil {
    // Must use `!` to force unwrap to a non-optional type:
    "Kyle's score is \(kylesScore!)"
}


// Optional Binding...
if let score = scores["newton"] {
    // So, `!` is not required:
    "Newton's score is \(score)"
} else {
    "Score not found."
}


// SIDENOTE: ??
let maybeInt : Int? = nil
let aNumber = maybeInt ?? 10
"Number is \(aNumber)."


let defaultName : () -> String = {
    "Expensive Computation"
    return "Default Name"
}
let maybeName : String? = nil
let aName = maybeName ?? defaultName()
println("Number is \(aName).")
defaultName()


// Optional Chaining
// https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/OptionalChaining.html
//
struct Address {
    let state: String?
}
struct Person {
    let address: Address?
}
struct Order {
    let person: Person?
}
var order = Order(person: Person(address: Address(state: "CA")))
let state = order.person?.address?.state?
if state != nil {
    "Order is from \(state!)."
}
if let orderState = order.person?.address?.state? {
    "Order is from \(orderState)."
}


/*---------------------/
   A Taste of Swift
/---------------------*/

sorted([1,2,5,3,4,1])
