import UIKit

/*
//  DeMorgan's Law
// 
//  Based on: Brandon Williams' "Proof in Functions"
//  http://www.fewbutripe.com/swift/math/2015/01/06/proof-in-functions.html
//
//  For any propositions P and Q, the following holds true:
//    ¬(P∨Q)⇔¬P∧¬Q
//
//  "You can think of this as ¬ distributing over ∨ 
//   but at the cost of switching ∨ to ∧."
//
/============================================================*/



/*------------------------------------------------------/
//  Negation: ¬
/------------------------------------------------------*/
enum Nothing {
  // no cases
}

struct Not <A> {
  let not: A -> Nothing
}


/*------------------------------------------------------/
//  Box, by Rob Rix
//    https://github.com/robrix/Box
//
//  The blog post uses the @autoclosure, but that seems
//  to be out of fashion since Swift 1.2:
//    http://mazur.me/SwiftInFlux/docs/6.3-beta1.pdf
/------------------------------------------------------*/
public protocol BoxType {
  /// The type of the wrapped value.
  typealias Value
  
  /// Initializes an intance of the type with a value.
  init(_ value: Value)
  
  /// The wrapped value.
  var value: Value { get }
}

class Box<T>: BoxType, Printable {
  /// Initializes a `Box` with the given value.
  required init(_ value: T) {
    self.value = value
  }
  
  /// The (immutable) value wrapped by the receiver.
  let value: T
  
  /// Constructs a new Box by transforming `value` by `f`.
  func map<U>(f: T -> U) -> Box<U> {
    return Box<U>(f(value))
  }
  
  
  // MARK: Printable
  
  var description: String {
    return toString(value)
  }
}



/*------------------------------------------------------/
//  Or: ∨
/------------------------------------------------------*/
enum Or <A, B> {
  case left(Box<A>)
  case right(Box<B>)
}

struct And <A, B> {
  let left: A
  let right: B
  init (_ left: A, _ right: B) {
    self.left = left
    self.right = right
  }
}


/*------------------------------------------------------/
//  ¬(P∨Q) ⇔ ¬P∧¬Q
/------------------------------------------------------*/
func deMorgan <A, B> (f: Not<Or<A, B>>) -> And<Not<A>, Not<B>> {
  return And<Not<A>, Not<B>>(
    Not<A> {a in f.not(.left(Box(a)))},
    Not<B> {b in f.not(.right(Box(b)))}
  )
}

/*------------------------------------------------------/
//  And, the converse...
//    ¬P∧¬Q ⇔ ¬(P∨Q)
/------------------------------------------------------*/
func deMorgan <A, B> (f: And<Not<A>, Not<B>>) -> Not<Or<A, B>> {
  return Not<Or<A, B>> {(x: Or<A, B>) in
    switch x {
    case let .left(a):
      return f.left.not(a.value)
    case let .right(b):
      return f.right.not(b.value)
    }
  }
}






