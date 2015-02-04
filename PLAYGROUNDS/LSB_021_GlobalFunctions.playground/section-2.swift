import UIKit

/*
//  Global Functions
/===================================*/
advance(0,0) // <-- Command click this function to see the header file for global functions.


/*------------------------------------/
//  advance (Strideable)
//  
//  with: successor and predecessor
//  See also: Strings
/------------------------------------*/
2 + 2
advance(5, 2)
5.successor()
5.predecessor()


/*---------------------------------/
//  abs
/---------------------------------*/
abs(-210)


/*---------------------------------/
//  assert
//
//  Suggested Reading:
//  https://developer.apple.com/swift/blog/?id=4
//  https://developer.apple.com/swift/blog/?id=15
/---------------------------------*/
assert(true, "BOOM!")
assert(1 + 1000 > 1000, "BOOM!")


/*---------------------------------/
//  distance
/---------------------------------*/
distance(1, 3)


/*---------------------------------/
//  count
/---------------------------------*/
count(1...3)
count(1..<5)


/*---------------------------------/
//  countElements
/---------------------------------*/
countElements([1, 2, 3])
countElements("word")
countElements(["a":1, "b":2])


/*---------------------------------/
//  isEmpty
/---------------------------------*/
isEmpty([Int]())
isEmpty([1,2])
isEmpty("")
isEmpty("word")
isEmpty([String:Int]())
isEmpty(["a":1, "b":2])


/*---------------------------------/
//  last
/---------------------------------*/
last([Int]())
last([1,2,3])!
last("")
last("word")!
last([String:Int]())
last(["a":1, "b":2])!.0
last(["a":1, "b":2])!.1


/*---------------------------------/
//  max
/---------------------------------*/
max(1,30,5)
max(3.14, 22/7, 1.0)
max("w", "o", "r", "d")


/*---------------------------------/
//  maxElement
/---------------------------------*/
maxElement([1,30,5])
maxElement([3.14, 22/7, 1.0])
maxElement("word")
maxElement(1...100)


/*---------------------------------/
//  min
/---------------------------------*/
min(1, 30, 5)
min(3.14, 22/7, 1.0)
min("w", "o", "r", "d")


/*---------------------------------/
//  minElement
/---------------------------------*/
minElement([1,30,5])
minElement([3.14, 22/7, 1.0])
minElement("word")
minElement(1...100)


/*---------------------------------/
//  print
/---------------------------------*/
print(1)
print(3.14)
print("word")
print([1,2,3])
print(["a":1, "b":2])


/*---------------------------------/
//  println
/---------------------------------*/
println(1)
println(3.14)
println("word")
println([1,2,3])
println(["a":1, "b":2])


/*---------------------------------/
//  removeAll
/---------------------------------*/
var v = [1,2,3]
removeAll(&v, keepCapacity: true)
v

v = [1,2,3]
removeAll(&v)
v

var s = "word"
removeAll(&s, keepCapacity: true)
s

s = "word"
removeAll(&s)
s


/*---------------------------------/
//  removeAtIndex
/---------------------------------*/
v = [1,2,3]
removeAtIndex(&v, 1)
v


/*---------------------------------/
//  removeLast
/---------------------------------*/
v = [1, 2, 3]
removeLast(&v)
v

s = "word"
removeLast(&s)
s


/*---------------------------------/
//  removeRange
/---------------------------------*/
v = [1, 2, 3, 4, 5]
removeRange(&v, 1...3)
v


/*---------------------------------/
//  reverse
/---------------------------------*/
v = [1, 2, 3]
reverse(v)
v


/*---------------------------------/
//  sort
/---------------------------------*/
v = [10, 2, 5, 3, 200, 30, 2]
sort(&v)
v

v = [10, 2, 5, 3, 200, 30, 2]
sort(&v, { (a, b) -> Bool in
  a > b
})
v

v = [10, 2, 5, 3, 200, 30, 2]
sort(&v) { $0 > $1 }
v


/*---------------------------------/
//  sorted
/---------------------------------*/
v = [10, 2, 5, 3, 200, 30, 2]
sorted(v)
v

v = [10, 2, 5, 3, 200, 30, 2]
sorted(v, { (a, b) -> Bool in
  b < a
})
v

v = [10, 2, 5, 3, 200, 30, 2]
let newV = sorted(v) { $1 < $0 }
newV
v


/*---------------------------------/
//  split
/---------------------------------*/
v = Array(1...10)
split(v, { (x) -> Bool in
  x == 5
})
var aryOfIntArys = split(v) { $0 == 5 }
aryOfIntArys

v = Array(1...10)
aryOfIntArys = split(v, { $0 % 2 == 0}, maxSplit: 2, allowEmptySlices: true)
aryOfIntArys

v = Array(1...10)
aryOfIntArys = split(v, { $0 < 3 || $0 % 2 == 0}, maxSplit: 5, allowEmptySlices: true)
aryOfIntArys

v = Array(1...10)
aryOfIntArys = split(v, { $0 < 3 || $0 % 2 == 0}, maxSplit: 5, allowEmptySlices: false)
aryOfIntArys

s = "The quick brown fox jumped."
var words = split(s, { $0 == " " }, maxSplit: 3, allowEmptySlices: true)
words

words = split(s) { $0 == " " }
words


/*---------------------------------/
//  swap
/---------------------------------*/
var a = "one"
var b = "two"
swap(&a, &b)
a
b

var ia = 1
var ib = 2
swap(&ia, &ib)
ia
ib


/*---------------------------------/
//  toString
/---------------------------------*/
toString(a)
toString(ia)

struct Rect: Printable {
  var x, y, width, height: Double

  init(x: Double, y: Double, width: Double, height: Double) {
    self.x = x
    self.y = y
    self.width = width
    self.height = height
  }
  
  var description: String {
    return "Rect[x:\(x), y:\(y), width:\(width), height:\(height)]"
  }

}

let r = Rect(x: 0, y: 10, width: 20, height: 40)

// This currently doesn't work in Playgrounds
// http://stackoverflow.com/questions/24068506/how-can-i-change-the-textual-representation-displayed-for-a-type-in-swift
toString(r)
"\(r)"

// should appear like this:
r.description


/*---------------------------------/
// dropFirst
// on a Sliceable
/---------------------------------*/
var animals = ["dog", "cat", "swan", "meerkat"]
dropFirst(animals)


/*---------------------------------/
// dropLast
// on a Sliceable
/---------------------------------*/
dropLast(animals)


/*---------------------------------/
// first (optional)
// on a Collection
/---------------------------------*/
first(animals)!


/*---------------------------------/
// last (optional)
// on a Collection
/---------------------------------*/
last(animals)!


/*---------------------------------/
// prefix
// on a Sliceable
/---------------------------------*/
prefix(animals, 2)


/*---------------------------------/
// suffix
// on a Sliceable
/---------------------------------*/
suffix(animals, 2)


/*---------------------------------/
// reversed
// on a Collection
/---------------------------------*/
let reversedAnimals = reverse(animals)
reversedAnimals
animals


/*---------------------------------/
// Backwards String
// Combine String -> [Char] . reverse -> String
/---------------------------------*/
let helloThere = "hello there"
String(reverse(helloThere))
