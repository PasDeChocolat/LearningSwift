import UIKit


/*
//  Pattern Matching
/===================================*/


/*---------------------------------------------------------/
//  Combined Pattern Matching
//
//  Suggested Reading:
//  http://www.objc.io/snippets/15.html
/---------------------------------------------------------*/
enum Result {
  case Success
  case Error(String)
}

// Use a tuple instead of nested switch statements
func ==(l: Result, r: Result) -> Bool {
  switch (l,r) {
  case let (.Error(x), .Error(y)): return x == y
  case (.Success, .Success): return true
  default: return false
  }
}

let a1: Result = Result.Success
let a2: Result = Result.Error("Bad")

let b1: Result = Result.Success
let b2: Result = Result.Error("Bad")
let b3: Result = Result.Error("Really Bad")

a1 == b1
a1 == b2
a1 == b3
a2 == b1
a2 == b2
a2 == b3

