import UIKit

/*
//  Slices
//
//  Based on:
//  http://natecook.com/blog/2014/09/slicing-for-speed/
/===================================*/


//  But, what's a slice?
let numbers = [1, 2, 3, 4, 5, 6, 7, 8]
let aFewNumbers = numbers[0..<3]

numbers as [Int]

//aFewNumbers as [Int] // <-- Error
aFewNumbers as Slice<Int>


/*---------------------------------/
//  Use an array of Ints
/---------------------------------*/
func sumArray(ns: [Int]) -> Int {
  return ns.reduce(0) { $0 + $1 }
}
sumArray(numbers)
// sumArray(aFewNumbers) // <-- Slice<Int> is not convertible to [Int]


/*---------------------------------/
//  Use a Slice of Ints
/---------------------------------*/
func sumSlice(ns: Slice<Int>) -> Int {
  return ns.reduce(0) { $0 + $1 }
}
sumSlice(aFewNumbers)
//sumSlice(numbers) // <-- [Int] is not convertible to Slice<Int>


/*---------------------------------/
//  Generic Types?
/---------------------------------*/
func sumSeq<S: SequenceType>(ns: S) -> Int {
  return reduce(ns, 0) { $0 + ($1 as! Int) }
}
sumSeq(numbers)
sumSeq(aFewNumbers)


/*---------------------------------/
//  How to generate a Slice
/---------------------------------*/
let slice: Slice<Int> = numbers[1..<5]
//sumArray(slice) // <-- Slice<Int> is not convertible to [Int]




