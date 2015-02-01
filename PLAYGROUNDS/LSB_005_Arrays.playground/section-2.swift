import UIKit

/*---------------------/
//  Arrays
/---------------------*/
// create empty list
var ages = [Int]()


// add items
ages.append(0)
ages.append(1)
ages.append(2)


// access via subscript
ages[0] = 16
ages[1] = 17
ages[2] = 18

let drivingAge = ages.first!
let otherAge = ages[1]
let votingAge = ages.last!

ages.append(21)
ages.append(25)
ages.append(65)
let minors = ages[0...1]

ages.capacity
ages.count
ages.isEmpty

let hell = ["h", "e", "l", "l"]
let o = ["o"]
let hello = hell + o

// immutable
let immutableAges = [10, 11]
//immutableAges.append(19)

// mutable
var mutableAges = [Int]()
mutableAges.append(100)

// repeated values
let pies = [Double](count: 3, repeatedValue: 3.14)

// homogeneous
var homogeneous = [Int]()
String.fromCString(object_getClassName(homogeneous))
homogeneous.append(1)
homogeneous.append(2)
homogeneous.append(3)
//homogeneous.append(3.14)

var hints = [1, 2, 3]
String.fromCString(object_getClassName(hints))
let hint1 : Int = hints[0] // <-- infers an Int

// heterogeneous by default
// (More about this in Type Casting.)
// By default this is an Array of AnyObject:
var things = [3, 3.14, "pi"]
String.fromCString(object_getClassName(things))
_stdlib_getTypeName(things)
_stdlib_getDemangledTypeName(things)
let ta = things[0]
String.fromCString(object_getClassName(ta))
let anyThing : AnyObject = things[0]           // <--- It's any object
let firstThing : Int = things.first! as Int
let pieThing : String = things.last! as String

things[1]
things[2]
things.append(100)
things.append("another")

// Array are passed by value (in Objective-C they were passed by reference)
var myMutableArray = [1, 3, 5]
func changeToEvens(anArray : [Int]) -> [Int] {
  //    anArray[0] = 1000 // array is immutable
  return anArray.map { x in x + 1 }
}
changeToEvens(myMutableArray)
myMutableArray // is still odds
myMutableArray.map { x in x + 1 }
myMutableArray[0] = 101
myMutableArray


// Accessing elements...
// by subscript index
var smallArray = [0, 1, 2]
smallArray[0]


// by range
smallArray[1...2]
smallArray[0..<2]


// by name
smallArray.first
smallArray.first!
smallArray.last
smallArray.last!


// don't go beyond the last index
//smallArray[1000] // causes an exception


// Array properties...
// capacity
smallArray.capacity


// count
smallArray.count


// isEmpty
smallArray.isEmpty
var emptyArray : [Int] = []
emptyArray.isEmpty


// Modifying a mutable array...
// append
smallArray.append(3)


// +=
let constantArray = [101, 102]
//constantArray[0] = 100
smallArray += constantArray


// assignment by index
smallArray[0] = 5
smallArray


// range
smallArray[0...1] = [42, 42, 42, 42]
smallArray


// insert
smallArray.insert(2, atIndex: 1)


// removeAll
smallArray.capacity
smallArray.removeAll(keepCapacity: true)
smallArray.capacity


smallArray.removeAll(keepCapacity: false)
smallArray.capacity


// remove at index
smallArray = [1, 2, 3, 4, 5]
smallArray.removeAtIndex(2)
smallArray


// removeLast
smallArray.removeLast()
smallArray


// reserveCapacity
smallArray.capacity
smallArray.reserveCapacity(20)
smallArray.capacity


// sort
var letters = ["z", "e", "b", "r", "a"]
letters.sort { $0 < $1 }
letters

letters.sort { $1 < $0 }
letters

letters.sort { (a, b) -> Bool in
  a < b
}
letters


// Iterating over arrays...
let cats = ["morris", "simba", "felix"]
var catNames = ""
for cat in cats {
  catNames += cat + " "
}
catNames

catNames = ""
for (index, cat) in enumerate(cats) {
  catNames += "\(index): \(cat)  "
}
catNames


// Array algorithms (returning new arrays)...
// filter
var animals = ["dog", "cat", "swan", "meerkat"]
var longAnimals = animals.filter { countElements($0) > 3 }
longAnimals
animals


// map
var bigAnimals = animals.map { countElements($0) > 3 ? "big " + $0 : $0 }
bigAnimals
animals


// reduce
var someNumbers = [1, 3, 43, 35, 25, 23]
var sum = someNumbers.reduce(0, combine: { (a, b) -> Int in
  return a + b
})
sum
var sum2 = someNumbers.reduce(100) { $0 + $1 }
sum2


// reverse
animals.reverse()


// sorted
var sortedAnimals = animals.sorted { $0 < $1 }
sortedAnimals



