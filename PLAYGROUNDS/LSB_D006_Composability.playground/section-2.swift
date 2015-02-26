import UIKit

/*
//  Composability
//
//  Based on: Brandon Willams' talk on Functional Programming in a Playground
//    at the Functional Swift Conference, Dec. 6th, 2014, Brooklyn, NY
//  http://2014.funswiftconf.com/speakers/brandon.html
/==========================================*/


/*----------------------------------------/
//  Methods don't compose well
/----------------------------------------*/

extension Int {
  func square () -> Int {
    return self * self
  }
  func incr () -> Int {
    return self + 1
  }
}


// Methods provide limited composition
3.square().incr()


// Yields a function
Int.square(3)
Int.square(3)()


// What if I want to map this function on an array?
let xs = Array(1...100)

// This doesn't work
map(xs, Int.square)



/*----------------------------------------/
//  Go "full free function"
/----------------------------------------*/

func square (x: Int) -> Int {
  return x * x
}

func incr (x: Int) -> Int {
  return x + 1
}

// Now we can map our xs with square
map(xs, square)



/*------------------------------------------------------/
//  Swift allows us to promote non-native composition
/------------------------------------------------------*/
// the compiler can do the work for us
infix operator |> {associativity left}
func |> <A, B> (x: A, f: A -> B) -> B {
  return f(x)
}

func |> <A, B, C> (f: A -> B, g: B -> C) -> (A -> C) {
  return { a in
    return g(f(a))
  }
}

// Composition!
3 |> square |> incr

// Pipe 3 into the composed function
// (one less iteration)
3 |> (square |> incr)



/*------------------------------------------------------/
//  The standard `map` signature has flipped args
//  i.e. we really want the function first to 
//       promote composability
/------------------------------------------------------*/
//map(<#source: C#>, <#transform: (C.Generator.Element) -> T##(C.Generator.Element) -> T#>)

func map <A, B> (f: A -> B) -> [A] -> [B] {
  return { xs in
    return map(xs, f)
  }
}

// now `map` lifts a func from operating on values to lists
xs |> map(square) |> map(incr)

// now `map` the lifted composition
// (one less iteration)
xs |> map(square |> incr)



/*------------------------------------------------------/
//  Same for filter...
/------------------------------------------------------*/
//filter(<#source: S#>, <#includeElement: (S.Generator.Element) -> Bool##(S.Generator.Element) -> Bool#>)


// "lift a predicate into the world of arrays"
func filter <A> (p: A -> Bool) -> [A] -> [A] {
  return { xs in
    return filter(xs, p)
  }
}

// as an example...
func isPrime (p: Int) -> Bool {
  if p <= 1 { return false }
  if p <= 3 { return true }
  for i in 2...Int(sqrtf(Float(p))) {
    if p % i == 0 { return false }
  }
  return true
}

// all where n-squared + 1 are prime
xs |> map(square) |> map(incr) |> filter(isPrime)

// reduce iteration once time
xs |> map(square |> incr) |> filter(isPrime)

// can't reduce iteration further without losing composability...

// unless...




