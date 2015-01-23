import UIKit

/*
//  Map
//
//  Suggested Reading:
//  http://www.objc.io/snippets/9.html
/===================================*/



/*------------------------------------/
//  Map on Arrays
/------------------------------------*/
var ints = [1,2,3,4,5]
var resultInts = ints.map { $0 + 1 }
resultInts
ints // it's immutable


/*------------------------------------/
//  Map, the global func
/------------------------------------*/
resultInts = map(ints) { $0 + 2 }
resultInts
ints // still immutable


/*------------------------------------/
//  Map on an Optional
/------------------------------------*/
var optName: String?
var greeting: String? = ""

optName = "George"
if let name = optName {
  greeting = "Hi, \(name)"
}
greeting!


// Can detect a nil with a much nicer syntax
optName = "Fred"
greeting = optName.map { "Hello, \($0)" }
greeting!


// And return nil if map unsuccessful
optName = nil
greeting = map(optName) { "Hello, \($0)" }
if greeting == nil {
  "greeting is nil"
}




