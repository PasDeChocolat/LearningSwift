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
optName = "Fred"

var greeting = ""
//greeting = map(optName) { "Hello, \($0)" }
//greeting
