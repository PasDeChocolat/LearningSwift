import UIKit

/*
//  Transducers
// 
//  Based on: Brandon Willams' talk on Functional Programming in a Playground
//    at the Functional Swift Conference, Dec. 6th, 2014, Brooklyn, NY
//  http://2014.funswiftconf.com/speakers/brandon.html
/==========================================*/



/*------------------------------------------------------/
//  Reducer on type A
//  (C, A) -> C
//
//  Transducer takes a reducer on A and returns a
//  reducer on B
//  ((C, A) -> C) -> ((C, B) -> C)
/------------------------------------------------------*/

func squaringTransducer <C> (reducer: (C, Int) -> C) -> ((C, Int) -> C) {
  return { accum, x in
    return reducer(accum, x * x)
  }
}

let xs = Array(1...100)

// Sum of xs, as an example:
reduce(xs, 0, +)

// Lift reducer `+` to the `+` of squares reducer
reduce(xs, 0, squaringTransducer(+))


/*------------------------------------------------------/
//  Generalize
//  Replace x * x with f(x)
//
//  Contravariance: f takes A to B, but transducer takes B to A
/------------------------------------------------------*/
func mapping <A, B, C> (f: A -> B) -> (((C, B) -> C) -> ((C, A) -> C)) {
  return { reducer in
    return { accum, a in
      return reducer(accum, f(a))
    }
  }
}

func square (x: Int) -> Int {
  return x * x
}

reduce(xs, 0, mapping(square)(+))



/*------------------------------------------------------/
//  Append - creates new list, no mutation
/------------------------------------------------------*/
func append <A> (xs: [A], x: A) -> [A] {
  return xs + [x]
}

infix operator |> {associativity left}
func |> <A, B> (x: A, f: A -> B) -> B {
  return f(x)
}

func |> <A, B, C> (f: A -> B, g: B -> C) -> (A -> C) {
  return { a in
    return g(f(a))
  }
}

reduce(xs, [], append |> mapping(square)) 


func incr (x: Int) -> Int {
  return x + 1
}

reduce(xs, [], append |> mapping(incr) |> mapping(square))


/*------------------------------------------------------/
//  Filtering Transducer
/------------------------------------------------------*/
func filtering <A, C> (p: A -> Bool) -> ((C, A) -> C) -> (C, A) -> C {
  return { reducer in
    return { accum, x in
      return p(x) ? reducer(accum, x) : accum
    }
  }
}

func isPrime (p: Int) -> Bool {
  if p <= 1 { return false }
  if p <= 3 { return true }
  for i in 2...Int(sqrtf(Float(p))) {
    if p % i == 0 { return false }
  }
  return true
}

// Has only one traversal!
// (comment out other `reduce` calls, and see how many times `append` occurs
reduce(xs, [], append
                 |> filtering(isPrime)
                 |> mapping(incr)
                 |> mapping(square))


// Now, what if you want the sum of those primes
reduce(xs, 0, (+) |> filtering(isPrime)
                  |> mapping(incr)
                  |> mapping(square))



