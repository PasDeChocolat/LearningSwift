import UIKit

/*
//  Applicative Functors - ZipLists
//    There's more than one way for a list to be an applicative functor.
//
//  Based on:
//  Learn You a Haskell for Great Good,
//    Chapter 11, Applicative Functors
//    - by Miran Lipovača

//  http://www.objc.io/books/ (Chapter 14, Functors, Applicative Functors, and Monads)
//    (Functional Programming in Swift, by Chris Eidhof, Florian Kugler, and Wouter Swierstra)
/===================================*/


/*---------------------------------------------------------------------/
//  Repeating Generator
/---------------------------------------------------------------------*/
class RepeatGenerator<T> : GeneratorType {
  let value: Element
  
  typealias Element = T
  
  init(_ value: Element) {
    self.value = value
  }
  
  func next() -> Element? {
    return value
  }
}
var g = RepeatGenerator(5)
g.next()

var gf = RepeatGenerator({$0 + 1})
gf.next()


/*---------------------------------------------------------------------/
//  Repeating Sequence
/---------------------------------------------------------------------*/
class Repeater<T> : SequenceType {
  typealias GeneratorType = RepeatGenerator<T>
  
  let value: T
  init(_ value: T) {
    self.value = value
  }
  
  func generate() -> RepeatGenerator<T> {
    return RepeatGenerator(value)
  }
  
  subscript(index: Int) -> T {
    return value
  }
  
  func take(count: Int) -> [T] {
    return Array<T>(count: count, repeatedValue: value)
  }
}

let rpt = Repeater(9)
rpt[0]
rpt[1000]
rpt.take(5)


/*---------------------------------------------------------------------/
//  zipWith
/---------------------------------------------------------------------*/
func zipWith<A, B, C>(f: (A, B)->C, xs: [A], ys: [B]) -> [C] {
  let minCount = min(xs.count, ys.count)
  return Array(0..<minCount).reduce([]) { $0 + [f(xs[$1], ys[$1])] }
}

let xs = [1, 2, 3]
let ys = [10, 20, 30]
zipWith({ $0 + $1 }, xs, ys)



enum ZipList<B,C> {
  case Pure(Repeater<B>)
  case List([C])
}

func count<B,C>(z: ZipList<B,C>) -> Int? {
  switch z {
  case .Pure:
    return nil
  case let .List(list):
    return list.count
  }
}

typealias Int2Int = Int->Int
count(ZipList<Int2Int,Int>.List([1,2,3]))
count(ZipList<Int2Int,Int>.Pure(Repeater({$0 + 5})))

func map<B,C,D>(z: ZipList<B,C>, transform: C->D) -> ZipList<B,D> {
  switch z {
  case let .Pure(repeater):
    assertionFailure("We don't allow mapping infinite lists (yet).")
  case let .List(list):
    return ZipList.List(list.map(transform))
  }
}

let zPlus10 = map(ZipList<Int2Int,Int>.List([1,2,3])) { $0 + 10 }

func getZipList<B,C>(z:ZipList<B,C>) -> [C] {
  switch z {
  case let .Pure(repeater):
    assertionFailure("Can't display an infinite list!")
  case let .List(list):
    return list
  }
}

getZipList(zPlus10)



/*---------------------------------------------------------------------/
//  pure
/---------------------------------------------------------------------*/
func pure<B,C>(value: B) -> ZipList<B,C> {
  return ZipList.Pure(Repeater(value))
}


func curry<A, B, C>(f: (A, B) -> C) -> A -> B -> C {
  return { x in { y in f(x, y) } }
}

2 + 2
/*---------------------------------------------------------------------/
//  <*>
/---------------------------------------------------------------------*/
infix operator <*> { associativity left precedence 150 }
func <*><B,C,D>(fs: ZipList<C->D,C->D>, xs: ZipList<B,C>) -> ZipList<B,D> {
  switch fs {
  case let .Pure(repeater):
    let xList = getZipList(xs)
    let xCount = count(xs)!
    let fns = repeater.take(xCount)
    let ls = Array(0..<xCount).reduce([]) { $0 + [fns[$1]( xList[$1] )] }
    return ZipList.List(ls)
    
  case let .List(fns):
    let xList = getZipList(xs)
    let minCount = min(fns.count, xList.count)
    let ls = Array(0..<minCount).reduce([]) { $0 + [fns[$1]( xList[$1] )] }
    return ZipList.List(ls)
  }
}


/*---------------------------------------------------------------------/
//  Example: Zip two lists
/---------------------------------------------------------------------*/
func addOne(x: Int) -> Int {
  return x + 1
}

let zList123 = ZipList<Int2Int,Int>.List([1,2,3])
let zListTens = ZipList<Int2Int,Int>.List([10,20,30])

let rr1 = ZipList.Pure(Repeater<Int->Int>(addOne)) <*> zList123
getZipList(rr1)

let rr2 = pure(addOne) <*> zList123
getZipList(rr2)

func adder(x: Int, y: Int) -> Int {
  return x + y
}
let rr3 = pure(curry(adder)) <*> zList123 <*> zListTens
getZipList(rr3)


/*---------------------------------------------------------------------/
//  </> 
//
//  ==> Haskell's <$>
//
//  (<$>) :: (Functor f) => (a -> b) -> f a -> f b
//  f <$> x = fmap f x
/---------------------------------------------------------------------*/
//infix operator </> { precedence 170 }
//public func </> <A, B>(l: A -> B, r: [A]) -> [B] {
//  return pure(l) <*> r
//}
//
//curry(+) </> [10, 20, 30] <*> [1, 2, 3]


