import UIKit

/*
//  Memory Management
//
//  Recommeded Reading:
//  https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Generics.html#//apple_ref/doc/uid/TP40014097-CH26-ID179
/==============================*/


/*-----------------------------/
// Generic Function
/-----------------------------*/
func swapVals<T>(inout v1: T, inout v2: T) {
  let temp = v1
  v1 = v2
  v2 = temp
}

var sA = "one"
var sB = "two"
swapVals(&sA, &sB)
sA
sB

var iA = 1
var iB = 2
swapVals(&iA, &iB)
iA
iB


/*-----------------------------/
// Generic Type
/-----------------------------*/
struct Stack<T> {
  var q = [T]()
  
  mutating func push(item: T) {
    q.append(item)
  }
  
  mutating func pop() -> T {
    return q.removeLast()
  }
}

var ints = Stack<Int>()
ints.push(1)
ints.push(2)
ints.push(3)
ints.pop()
ints.pop()
ints.pop()

var strs = Stack<String>()
strs.push("un")
strs.push("deux")
strs.push("trois")
strs.pop()
strs.pop()
strs.pop()


/*----------------------------------/
// Constraining Types: Subclasses
/----------------------------------*/
class Dog {
  func bark() -> String {
    return "bark"
  }
}
class Dachshund: Dog {
  override func bark() -> String {
    return "yap"
  }
}
class Mastiff: Dog {
  override func bark() -> String {
    return "RAWR"
  }
}

struct BarkStack<T: Dog> {
  var q = [T]()
  mutating func add(dog: T) {
    q.append(dog)
  }
  func sing() -> String {
    var s = ""
    for dog in q {
      s += dog.bark()
    }
    return s
  }
}

var dachshunds = BarkStack<Dachshund>()
dachshunds.add(Dachshund())
dachshunds.add(Dachshund())
dachshunds.sing()

var mastiffs = BarkStack<Mastiff>()
mastiffs.add(Mastiff())
mastiffs.add(Mastiff())
mastiffs.sing()

var dogs = BarkStack<Dog>()
dogs.add(Mastiff())
dogs.add(Dachshund())
dogs.add(Mastiff())
dogs.add(Dachshund())
dogs.sing()


/*----------------------------------/
// Constraining Types: Protocols
/----------------------------------*/
struct OrderableStack<T: Comparable> {
  var q = [T]()
  
  mutating func push(item: T) {
    q.append(item)
  }
  
  mutating func pop() -> T {
    return q.removeLast()
  }
  
  // New Stuff
  mutating func sorted() -> [T] {
    return q.sorted { $0 < $1 }
  }
}

var orderable = OrderableStack<Double>()
orderable.push(3.14)
orderable.push(22.0/7.0)
orderable.push(1.0)
orderable.push(42.0)
orderable.sorted()


/*------------------------------------------/
//  Generic Protocols and Associated Types
/------------------------------------------*/
protocol Stackable {
  typealias ItemType
  mutating func push(item: ItemType)
  mutating func pop() -> ItemType
}

// Explicit implementation of Stackable protocol with `Int`s
struct ExplicitStack<Int>: Stackable {
  typealias ItemType = Int
  
  var q = [ItemType]()
  
  mutating func push(item: ItemType) {
    q.append(item)
  }
  
  mutating func pop() -> ItemType {
    return q.removeLast()
  }
}


// No need to explicity give ItemType's type
// and can use a generic type for the items.
struct ImplicitStack<T>: Stackable {
  var q = [T]()
  
  mutating func push(item: T) {
    q.append(item)
  }
  
  mutating func pop() -> T {
    return q.removeLast()
  }
}



