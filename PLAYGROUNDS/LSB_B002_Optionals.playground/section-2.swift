import UIKit

/*
//  Optionals
//
//  Based on:
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


/*-----------------------------------------------/
//  ?? in depth
/-----------------------------------------------*/
struct Eval {
  var x: String {
    println("computing...")
    return "x"
  }
}
// Note the "console output" when this gets evaluated
//Eval().x

let aNil: String? = nil
var x: String?
//x = aNil ?? Eval().x

// Doesn't eval x, unless it needs to...
x = "hello" ?? Eval().x


/*-----------------------------------------------/
//  More Optional Chaining
/-----------------------------------------------*/
let capitals = ["France": "Paris", "USA": "Washington DC"]
let cities = ["Paris": 2_273, "Washington DC":659]

// This is a recurring pattern.
func popOfCapitolOfCountry(country: String) -> Int? {
  if let capital = capitals[country] {
    if let population = cities[capital] {
      return population * 1_000
    }
  }
  return nil
}

popOfCapitolOfCountry("France")
popOfCapitolOfCountry("USA")
popOfCapitolOfCountry("Canada")


//// Try this operator from Functional Programming in Swift
//infix operator >>= {}
//func >>=<U, T>(optional: T?, f: T -> U?) -> U? {
//  if let x = optional {
//    return f(x)
//  } else {
//    return nil
//  }
//}

infix operator >>= { associativity left}
func >>=<U, T>(optional: T?, f: T -> U?) -> U? {
  return optional.map { f($0)! }
}

func popOfCapitolOfCountry2(country: String) -> Int? {
  return
    capitals[country] >>= { capital in
      cities[capital] >>= { population in
        return population * 1_000
    }
  }
}

popOfCapitolOfCountry2("France")
popOfCapitolOfCountry2("USA")
popOfCapitolOfCountry2("Canada")


func popOfCapitolOfCountry3(country: String) -> Int? {
  return capitals[country] >>= { cities[$0] } >>= { $0 * 1000 }
}

popOfCapitolOfCountry3("France")
popOfCapitolOfCountry3("USA")
popOfCapitolOfCountry3("Canada")



