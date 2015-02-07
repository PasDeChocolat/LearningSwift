import UIKit

/*
//  Applicative Functors
//
//  Based on:
//  http://www.objc.io/books/ (Chapter 14, Functors, Applicative Functors, and Monads)
//    (Functional Programming in Swift, by Chris Eidhof, Florian Kugler, and Wouter Swierstra)
/===================================*/


/*---------------------------------------------------------------------/
//  pure
/---------------------------------------------------------------------*/
func pure<A>(value: A) -> A? {
  return value
}


/*---------------------------------------------------------------------/
//  <*>
/---------------------------------------------------------------------*/
infix operator <*> { associativity left precedence 150 }
func <*><A, B>(optionalTransform: (A -> B)?, optionalValue: A?) -> B? {
  if let transform = optionalTransform {
    if let value = optionalValue {
      return transform(value)
    }
  }
  return nil
}


/*---------------------------------------------------------------------/
//  Example: addOptionals
/---------------------------------------------------------------------*/
func curry<A, B, C>(f: (A, B) -> C) -> A -> B -> C {
  return { x in { y in f(x, y) } }
}

func addOptionals(maybeX: Int?, maybeY: Int?) -> Int? {
  return pure(curry(+)) <*> maybeX <*> maybeY
}

let opt5: Int? = 5
let opt7: Int? = 7
addOptionals(opt5, opt7)!

