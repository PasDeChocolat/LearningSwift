import UIKit

/*
//  SemiGroups
// 
//  Based on: Brandon Williams' "Algebraic Structure and Protocols"
//  http://www.fewbutripe.com/swift/math/algebra/2015/02/17/algebraic-structure-and-protocols.html
/============================================================*/



/*------------------------------------------------------/
//  The SemiGroup
//
//  "In the language of mathematics, a semigroup is a set X, 
//   a binary operation ⋅ that takes two elements a,b in X
//   and produces a third a⋅b, such that
//   the operation is associative:
//
//     a⋅(b⋅c)=(a⋅b)⋅c   for every a,b,c in X
//
//   Examples include:
//     Integers (denoted by ℤ) equipped with addition: (ℤ,+)
//     Boolean values B={⊤,⊥} with disjunction: (B,∨)
//     Boolean values with conjunction: (B,∧)
//     2×2 matrices equipped with multiplication: (M2×2,×)"
//
/------------------------------------------------------*/
protocol Semigroup {
  // Binary semigroup operation
  // **AXIOM** Should be associative:
  //   a.op(b.op(c)) == (a.op(b)).op(c)
  func op (g: Self) -> Self
}


extension Int : Semigroup {
  func op (n: Int) -> Int {
    return self + n
  }
}
3.op(2)


extension Bool : Semigroup {
  func op (b: Bool) -> Bool {
    return self || b
  }
}
true.op(true)
true.op(false)
false.op(true)
false.op(false)


extension String : Semigroup {
  func op (b: String) -> String {
    return self + b
  }
}
"hello".op("world")


extension Array : Semigroup {
  func op (b: Array) -> Array {
    return self + b
  }
}
[1,2,3].op([4,5,6])



/*------------------------------------------------------/
//  <> as binary op
/------------------------------------------------------*/
infix operator <> {associativity left precedence 150}
func <> <S: Semigroup> (a: S, b: S) -> S {
  return a.op(b)
}

2 <> 3                // 5
false <> true         // true
"foo" <> "bar"        // "foobar"
[2, 3, 5] <> [7, 11]  // [2, 3, 5, 7, 11]



/*------------------------------------------------------/
//  sconcat (semigroup concat) via reduce and <>
/------------------------------------------------------*/
func sconcat <S: Semigroup> (xs: [S], initial: S) -> S {
  return reduce(xs, initial, <>)
}

sconcat([1, 2, 3, 4, 5], 0)             // 15
sconcat([false, true], false)           // true
sconcat(["f", "oo", "ba", "r"], "")     // "foobar"
sconcat([[2, 3], [5, 7], [11, 13]], []) // [2, 3, 5, 7, 11, 13]



/*------------------------------------------------------/
//  The Monoid
//
//  "A monoid is a set X, a binary operation ⋅ and 
//   a distinguished element e of X such that 
//   the following holds:
//
//     ⋅ is associative: a⋅(b⋅c)=(a⋅b)⋅c for all a,b,c in X.
//     e is an identity: e⋅a=a⋅e=a for all a in X.
//
//   Said more succinctly, 
//   (X,⋅,e) is a monoid if (X,⋅) is first a semigroup
//   and e is an identity element.
//
//   Examples include:
//     Integers with addition: (ℤ,+,0)
//     Boolean values with disjunction: (B,∨,⊥)
//     Boolean values with conjunction: (B,∧,⊤)
//     2×2 matrices with multiplication and the identity matrix: (M2×2,×,I2×2)"
//
/------------------------------------------------------*/
protocol Monoid : Semigroup {
  // Identity value of monoid
  // **AXIOM** Should satisfy:
  //   Self.e() <> a == a <> Self.e() == a
  // for all values a
  static func e () -> Self
}


extension Int : Monoid {
  static func e () -> Int {
    return 0
  }
}

extension Bool : Monoid {
  static func e () -> Bool {
    return false
  }
}

extension String : Monoid {
  static func e () -> String {
    return ""
  }
}

extension Array : Monoid {
  static func e () -> Array {
    return []
  }
}

3 <> Int.e()            // 3
false <> Bool.e()       // false
"foo" <> String.e()     // "foo"
[2, 3, 5] <> Array.e()  // [2, 3, 5]



/*------------------------------------------------------/
//  mconcat (monoid concat) via reduce and <>
/------------------------------------------------------*/
func mconcat <M: Monoid> (xs: [M]) -> M {
  return reduce(xs, M.e(), <>)
}

mconcat([1, 2, 3, 4, 5])            // 15
mconcat([false, true])              // true
mconcat(["f", "oo", "ba", "r"])     // "foobar"
mconcat([[2, 3], [5, 7], [11, 13]]) // [2, 3, 5, 7, 11, 13]


