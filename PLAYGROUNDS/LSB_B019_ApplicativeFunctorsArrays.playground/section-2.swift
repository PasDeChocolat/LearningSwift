import UIKit

/*
//  Applicative Functors - Arrays
//
//  Based on:
//  http://www.objc.io/books/ (Chapter 14, Functors, Applicative Functors, and Monads)
//    (Functional Programming in Swift, by Chris Eidhof, Florian Kugler, and Wouter Swierstra)
/===================================*/


/*---------------------------------------------------------------------/
//  pure
/---------------------------------------------------------------------*/
func pure<A>(value: A) -> [A] {
  return [value]
}


func curry<A, B, C>(f: (A, B) -> C) -> A -> B -> C {
  return { x in { y in f(x, y) } }
}


/*---------------------------------------------------------------------/
//  <*>
/---------------------------------------------------------------------*/
infix operator <*> { associativity left precedence 150 }
func <*><A, B>(fs: [(A -> B)], xs: [A]) -> [B] {
  if fs.isEmpty {
    return []
  }
  var result = [B]()
  for f in fs {
    for x in xs {
      result.append(f(x))
    }
  }
  return result
}


/*---------------------------------------------------------------------/
//  Example: List comprehensions... non-deterministic computations
/---------------------------------------------------------------------*/
let mapList = pure({ $0 + 1 }) <*> [1, 2, 3]
mapList
let mapList2 = pure(curry(+)) <*> [10, 20, 30] <*> [1, 2, 3]


let comboList = [{ $0 + 1 }, { $0 + 100 }] <*> [1, 2, 3]
comboList

let comboList2 = [curry(+), curry(*)] <*> [10, 20, 30] <*> [1, 2, 3]


/*---------------------------------------------------------------------/
//  </> 
//
//  ==> Haskell's <$>
//
//  (<$>) :: (Functor f) => (a -> b) -> f a -> f b
//  f <$> x = fmap f x
/---------------------------------------------------------------------*/
infix operator </> { precedence 170 }
public func </> <A, B>(l: A -> B, r: [A]) -> [B] {
  return pure(l) <*> r
}

curry(+) </> [10, 20, 30] <*> [1, 2, 3]


