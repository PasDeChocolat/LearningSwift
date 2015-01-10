import UIKit


/*--------------------------/
//  Functions
//    http://practicalswift.com/2014/06/14/the-swift-standard-library-list-of-built-in-functions/
/--------------------------*/

// let's add some numbers
func addOneTo(x: Int) -> Int {
  return x + 1;
}
addOneTo(2)

// arg passed by value:
var i = 0
addOneTo(i)
i


// var
func addTwoTo(var y: Int) -> Int {
  // can modify param internally
  y = y + 2
  return y
}
i = 0
addTwoTo(i)


// inout
func addThreeTo(inout z: Int) -> Int {
  z = z + 3
  return z
}
i = 0
addThreeTo(&i)
i


/*--------------------------/
// returning optionals
/--------------------------*/
func divX(x: Double, byY y: Double) -> Double? {
  if (y == 0) { return nil }
  
  return x / y
}

divX(10, byY: 10)!
if let result = divX(10, byY: 0) {
  "Result is \(result)"
} else {
  "divide by zero!"
}


/*--------------------------/
// parameters
/--------------------------*/

// external parameter names:
func areaForRect(width w: Double, height h: Double) -> Double {
  return w * h
}
areaForRect(width: 10.0, height: 20.0)

// use same parameter names internally
// and externally:
func areaForSquare(# side: Double) -> Double {
  return side * side
}
areaForSquare(side: 10.0)


// default values
// (also, pi implied as external name, as second param)
func areaForCircle(radius r: Double, pi: Double = 3.14) -> Double {
  return pi * r * r
}
areaForCircle(radius: 10.0)
areaForCircle(radius: 10.0, pi: 22/7)

// no param names:
func multiply(x: Double, y: Double) -> Double {
  return x * y
}
multiply(10.0, 2.0)

// variadic
func mult(xs: Double...) -> Double {
  return xs.reduce(1) {
    $0 * $1
  }
}
mult(1, 2, 3)


/*--------------------------/
// function types
/--------------------------*/
func additionalFive(adder: (Int) -> Int) -> (Int) -> Int {
  return {
    adder($0) + 5
  }
}

let plusSeven: (Int) -> Int = {
  $0 + 7
}

let plusTwelve = additionalFive(plusSeven)
plusTwelve(10)


// now with a type
typealias Adder = (Int) -> Int

func anotherFive(adder: Adder) -> Adder {
  return {
    adder($0) + 5
  }
}

let plusTen: Adder = {
  $0 + 10
}

let plusFifteen = anotherFive(plusTen)
plusFifteen(10)
