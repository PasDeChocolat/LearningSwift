import UIKit
import ExpressionParser

/*
//  Tokenization and Parsing
//
//  Based on:
//  http://www.objc.io/books/ (Chapter 13, Case Study: Build a Spreadsheet Application)
//    (Functional Programming in Swift, by Chris Eidhof, Florian Kugler, and Wouter Swierstra)
/===================================*/


// This is just a test of the import from the "ExpressionParser" module.
let myParser: Parser<Character, Character> = Parser { _ in
  return none()
}

// Here goes nothing...


/*=====================================================================/
//  Tokenization and Parsing
/=====================================================================*/


/*---------------------------------------------------------------------/
//  Tokens
/---------------------------------------------------------------------*/
enum Token : Equatable {
  case Number(Int)
  case Operator(String)
  case Reference(String, Int)
  case Punctuation(String)
  case FunctionName(String)
}


func ==(lhs: Token, rhs: Token) -> Bool {
  switch (lhs,rhs) {
  case (.Number(let x), .Number(let y)):
    return x == y
  case (.Operator(let x), .Operator(let y)):
    return x == y
  case (.Reference(let row, let column), .Reference(let row1, let column1)):
    return row == row1 && column == column1
  case (.Punctuation(let x), .Punctuation(let y)):
    return x == y
  case (.FunctionName (let x), .FunctionName(let y)):
    return x == y
  default:
    return false
  }
}


//extension Token : Printable {
//  var description: String {
//    switch (self) {
//    case Number(let x):
//      return "\(x)"
//    case .Operator(let o):
//      return o
//    case .Reference(let row, let column):
//      return "\(row)\(column)"
//    case .Punctuation(let x):
//      return x
//    case .FunctionName(let x):
//      return x
//    }
//  }
//}


/*---------------------------------------------------------------------/
//  const - Takes an arg and constructs a function that always
//          (constantly) returns the arg, diregarding the arguments
//          sent to the contructed function.
/---------------------------------------------------------------------*/
func const<A, B>(x: A) -> (y: B) -> A {
  return { _ in x }
}






