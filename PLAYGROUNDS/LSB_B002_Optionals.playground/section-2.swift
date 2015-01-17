import UIKit

/*
//  Optionals
//
//  Suggested Reading:
//  http://www.objc.io/books/
//    (Functional Programming in Swift, by Chris Eidhof, Florian Kugler, and Wouter Swierstra)
/===================================*/



/*-----------------------------------------------/
//  Map is also a Swift function on optionals.
//
//  Suggested Reading:
//  http://www.objc.io/books/ (Chapter 5: Optionals)
//  http://natashatherobot.com/swift-using-map-to-deal-with-optionals/
/-----------------------------------------------*/
let optional: Int? = 0
let mapped = optional.map { x in x + 1 }
optional!
mapped!

// If "nil" then `map` returns nil
let optNil: Int? = nil
let mappedNil = optNil.map { x in x + 1 }
if mappedNil == nil { "mappedNil is nil" }


// Conveniently give yourself a default value.
// (Note: return type is `String`, not optional `String?`)
func greet(name: String?) -> String {
  return name.map { name in "Hello, \(name)." } ?? "Hello there!"
}
greet("Fred")
greet(nil)



