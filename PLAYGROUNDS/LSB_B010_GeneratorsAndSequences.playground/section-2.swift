import UIKit

/*
//  Generators and Sequences
//
//  Suggested Reading:
//  http://www.objc.io/books/ (Chapter 11, Generators and Sequences)
//    (Functional Programming in Swift, by Chris Eidhof, Florian Kugler, and Wouter Swierstra)
/===================================*/


// First, we'll take a look at a standard Fibonacci function.
// Then, we'll use this to generate a FibonacciGenerator.


/*------------------------------------/
//  Fibonacci Number Sequence
//
//  For: n
//  0, 1, 2, 3, 4, 5,  6,  7
//
//  Fibonacci is:
//  1, 1, 2, 3, 5, 8, 13, 21
/------------------------------------*/
// Fibonacci
func fib(n: Int) -> Int {
  switch n {
  case 0, 1:
    return 1
  default:
    return fib(n-2) + fib(n-1)
  }
}

fib(0)
fib(1)
fib(2)
fib(5) // = 3 +  5
fib(7) // = 8 + 13


/*------------------------------------/
//  Generators
/------------------------------------*/
// Fibonnaci Generator:
class FibonnaciGenerator: GeneratorType {
  typealias Element = Int
  
  var currentIndex: Int
  
  init(startIndex: Int) {
    currentIndex = startIndex
  }
  
  func next() -> Element? {
    if currentIndex < 0 { return nil }
    return fib(currentIndex++)
  }
}


// Iterate over first five elements
var fibGenerator = FibonnaciGenerator(startIndex: 0)
var fibs = [Int]()
for var i=0; i<5; i++ {
  if let nextFib = fibGenerator.next() {
    fibs.append(nextFib)
  }
}
fibs


// Do this again, using `reduce`
fibGenerator = FibonnaciGenerator(startIndex: 0)
Array(1...5).reduce([Int]()) { acc, _ in
  if let nextFib = fibGenerator.next() {
    return acc + [nextFib]
  }
  return acc
}


/*------------------------------------/
//  Faster Fibonacci Generators
/------------------------------------*/
// The older generator will slow down as n gets larger.

// Faster Fibonnaci Generator:
class MemoizedFibonnaciGenerator: GeneratorType {
  typealias Element = Int
  
  var memo: (last: Element?, lastLast: Element?)
  var currentIndex: Int
  
  init(startIndex: Int) {
    currentIndex = startIndex
  }
  
  func next() -> Element? {
    if currentIndex < 0 { return nil }
    
    let calcFib = {
      (self.memo.last ?? fib(self.currentIndex-1)) + (self.memo.lastLast ?? fib(self.currentIndex-2))
    }
    let nextFib = currentIndex < 2 ? 1 : calcFib()
    
    memo = (last: nextFib, lastLast: memo.last)
    currentIndex++
    return nextFib
  }
}


// Iterate over first five elements
var memoFibGenerator = MemoizedFibonnaciGenerator(startIndex: 0)
fibs = [Int]()
for var i=0; i<5; i++ {
  if let nextFib = memoFibGenerator.next() {
    fibs.append(nextFib)
  }
}
fibs


// Do this again, using `reduce`
memoFibGenerator = MemoizedFibonnaciGenerator(startIndex: 3)
fibs = Array(1...5).reduce([]) { acc, _ in
  if let nextFib = memoFibGenerator.next() {
    return acc + [nextFib]
  }
  return acc
}


/*------------------------------------/
//  Find a Fib
/------------------------------------*/
func findFib(predicate: Int -> Bool) -> Int? {
  let g = MemoizedFibonnaciGenerator(startIndex: 0)
  while let x = g.next() {
    if predicate(x) { return x }
  }
  return nil
}

let bigFib = findFib { $0 > 20 }
bigFib!


/*------------------------------------/
//  Generic Find
/------------------------------------*/
func find<G: GeneratorType>(var generator: G, predicate: G.Element -> Bool) -> G.Element? {
  while let x = generator.next() {
    if predicate(x) { return x }
  }
  return nil
}

let myFibs = MemoizedFibonnaciGenerator(startIndex: 0)
let multThreeFib = find(myFibs) { $0 % 3 == 0 && $0 > 3 }
multThreeFib!


/*------------------------------------/
//  GeneratorOf<T>
/------------------------------------*/
func easyFib(startIndex: Int) -> GeneratorOf<Int> {
  var i = startIndex
  return GeneratorOf {
    if i < 0 { return nil}
    
    let nextN = i; i++
    switch nextN {
    case 0, 1:
      return 1
    default:
      return fib(nextN)
    }
  }
}

var easyFibs = easyFib(0) // Note: this must be a var.
fibs = Array(1...5).reduce([]) { acc, _ in
  if let nextFib = easyFibs.next() {
    return acc + [nextFib]
  }
  return acc
}


/*------------------------------------/
//  Memoized Fib GeneratorOf<T>
/------------------------------------*/
func easyMemoFib(startIndex: Int) -> GeneratorOf<Int> {
  var i = startIndex
  var memo: (last: Int?, lastLast: Int?)
  
  return GeneratorOf {
    if i < 0 { return nil }
    
    let calcFib = { (memo.last ?? fib(i-1)) + (memo.lastLast ?? fib(i-2)) }
    let nextFib = i < 2 ? 1 : calcFib()
    
    memo = (last: nextFib, lastLast: memo.last)
    i++
    return nextFib
  }
}

var easyMemoFibs = easyFib(0) // Note: this must be a var.
fibs = Array(1...5).reduce([]) { acc, _ in
  if let nextFib = easyMemoFibs.next() {
    return acc + [nextFib]
  }
  return acc
}


/*------------------------------------/
//  Just a few Fibs:
//  Only produces a few Fibs
/------------------------------------*/
class ShortFibGenerator: GeneratorType {
  typealias Element = Int
  
  var memo: (last: Element?, lastLast: Element?)
  var currentIndex: Int
  let fibCount = 5
  var lastIndex: Int
  
  let g: MemoizedFibonnaciGenerator
  
  init(startIndex: Int) {
    currentIndex = startIndex
    lastIndex = startIndex + fibCount - 1
    g = MemoizedFibonnaciGenerator(startIndex: startIndex)
  }
  
  func next() -> Element? {
    if currentIndex < 0 || currentIndex > lastIndex { return nil }
    currentIndex++
    return g.next()
  }
}

let fewFibs = ShortFibGenerator(startIndex: 0)
fibs = Array(1...20).reduce([]) { acc, _ in
  if let nextFib = fewFibs.next() {
    return acc + [nextFib]
  }
  return acc
}
fibs // Only contains 5 fibs, even though we tried to generate 20


/*------------------------------------/
//  Sequences
/------------------------------------*/
struct ShortFibSequence: SequenceType {
  let startIndex: Int
  init(startIndex: Int) {
    self.startIndex = startIndex
  }
  
  typealias Generator = ShortFibGenerator
  func generate() -> Generator {
    return Generator(startIndex: startIndex)
  }
  
}


// Creates generators, as expected
var shortFibSeq = ShortFibSequence(startIndex: 0)
var shortFibs = shortFibSeq.generate()
fibs = Array(1...20).reduce([]) { acc, _ in
  if let nextFib = shortFibs.next() {
    return acc + [nextFib]
  }
  return acc
}
fibs // Only contains 5 fibs, even though we tried to generate 20


// Can regenerate again
shortFibs = shortFibSeq.generate()
fibs = Array(1...20).reduce([]) { acc, _ in
  if let nextFib = shortFibs.next() {
    return acc + [nextFib]
  }
  return acc
}
fibs


/*------------------------------------/
//  Sequences and For
/------------------------------------*/
var fibsBanner = ""
for x in ShortFibSequence(startIndex: 5) {
  if fibsBanner != "" { fibsBanner += "-" }
  fibsBanner += String(x)
}
fibsBanner


/*------------------------------------/
//  Sequences and Map
/------------------------------------*/
var doubleSeq = map(ShortFibSequence(startIndex: 5)) { $0 * 2 }
fibsBanner = ""
for x in doubleSeq {
  if fibsBanner != "" { fibsBanner += "-" }
  fibsBanner += String(x)
}
fibsBanner


/*------------------------------------/
//  Sequences and Filter
/------------------------------------*/
var oddFibs = filter(ShortFibSequence(startIndex: 5)) { $0 % 2 == 1 }
fibsBanner = ""
for x in oddFibs {
  if fibsBanner != "" { fibsBanner += "-" }
  fibsBanner += String(x)
}
fibsBanner



