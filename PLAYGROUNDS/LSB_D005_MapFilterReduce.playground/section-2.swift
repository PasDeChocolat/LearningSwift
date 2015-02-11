import UIKit

/*
//  Let's implement Map, Filter, & Reduce
// 
//  I got the inspiration for this from a 
//  book or a paper, I'll try to remember
//  which and post it here.
/==========================================*/


let nums = [1,2,3,4,5]


/*----------------------------------------/
//  Map: Imperative Style
/----------------------------------------*/
// Add ten to each number in the array.
var mappedNums = [Int]()
for n in nums {
  mappedNums.append(n * 10)
}
mappedNums


/*----------------------------------------/
//  Map: Functional (Fun) Style
/----------------------------------------*/
// Pass a function
func byTen(x: Int) -> Int {
  return x * 10
}
nums.map(byTen)


// Pass a closure
let closureResult = nums.map { $0 * 10 }
closureResult


// Create the `by` function on the fly
func by(n: Int) -> (Int) -> Int {
  return { x in
    x * 10
  }
}
nums.map(by(10))


// Use the global function `map`
map(nums, byTen)
map(nums) { $0 * 10 }
map(nums, by(10))



/*----------------------------------------/
//  Filter: Imperative Style
/----------------------------------------*/
// Only include the even numbers
var evens = [Int]()
for n in nums {
  if n % 2 == 0 { evens.append(n) }
}
evens


/*----------------------------------------/
//  Filter: Fun Style
/----------------------------------------*/
// Pass a function
func isEven(x: Int) -> Bool {
  return x % 2 == 0
}
nums.filter(isEven)


// Pass a closure
let evenClosureResult = nums.filter { isEven($0) }
evenClosureResult


// Pass predicate function on the fly
let oddClosureResult = nums.filter { $0 % 2 != 0 }
oddClosureResult


// Use the global function `filter`
filter(nums, isEven)
let multiplesOfThree = filter(nums) { $0 % 3 == 0 }
multiplesOfThree


/*----------------------------------------/
//  Reduce: Imperative Style
/----------------------------------------*/
//  Calculating a Sum
var sum = 0
for n in nums {
  sum += n
}
sum


/*----------------------------------------/
//  Reduce: Fun Style
/----------------------------------------*/
// Pass a function
func adder(x: Int, y: Int) -> Int {
  return x + y
}
nums.reduce(0, combine: adder)


// Pass an operator
nums.reduce(0, combine: +)


// Pass a closure
let closureSum = nums.reduce(0) { $0 + $1 }
closureSum


// Pass a new operation
let fac5 = nums.reduce(1) { $0 * $1 }
fac5


// Use the global function `reduce`
reduce(nums, 0, adder)
reduce(nums, 0, +)
reduce(nums, 0) { $0 + $1 }


/*----------------------------------------/
//  Build Map from Reduce
/----------------------------------------*/
func myMap(source: [Int], transform: (Int) -> Int) -> [Int] {
  return reduce(source, []) { $0 + [transform($1)] }
}


// It's just like the native `map`
myMap(nums, byTen)

let doubleResult = myMap(nums) { $0 * 2 }
doubleResult


/*----------------------------------------/
//  Build Filter from Reduce
/----------------------------------------*/
func myFilter(source: [Int], includeElement: (Int) -> Bool) -> [Int] {
  return reduce(source, []) { includeElement($1) ? $0 + [$1] : $0 }
}


// It's just like the native `filter`
myFilter(nums, isEven)

let myFilterEvens = myFilter(nums) { $0 % 2 == 0 }
myFilterEvens


/*----------------------------------------/
//  Build a Generic Map from Reduce
/----------------------------------------*/
func genericMap<T,U>(source: [T], transform: (T) -> U) -> [U] {
  return reduce(source, []) { $0 + [transform($1)] }
}


// Works on any array of elements
let byPi = genericMap([1.1, 2.2, 3.3]) { $0 * 3.14 }
byPi

let exclamations = genericMap(["cat", "dog", "ice cream"]) { $0 + "!" }
exclamations

let aarray = genericMap([[1, 2, 3], [4, 5], [6]]) { map($0, byTen) }
aarray


/*----------------------------------------/
//  Build a Generic Filter from Reduce
/----------------------------------------*/
func genericFilter<T>(source: [T], includeElement: (T) -> Bool) -> [T] {
  return reduce(source, []) { includeElement($1) ? $0 + [$1] : $0 }
}


// Works on any array of elements
let doubleFilterResult = genericFilter([1.1, 2.2, 3.3]) { $0 > 2 }
doubleFilterResult

let stringFilterResult = genericFilter(["dog", "mouse", "raccoon"]) { count($0) > 4 }
stringFilterResult

let charsFilterResult = genericFilter(Array("raccoon")) { $0 > "m" }
charsFilterResult






