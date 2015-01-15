import UIKit

/*
//  Ranges, Intervals, and Strides
//
//  Suggested Reading:
//  https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/BasicOperators.html
//  https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ControlFlow.html#//apple_ref/doc/uid/TP40014097-CH9-ID120
//  http://airspeedvelocity.net/2014/11/10/which-function-does-swift-call-part-5-range-vs-interval/
//  http://adampreble.net/blog/2014/09/iterating-over-range-of-dates-swift/
//  http://www.scottlogic.com/blog/2014/06/26/swift-sequences.html
/===================================*/


/*---------------------------------/
//  Ranges
/---------------------------------*/
1...5 // includes 1 and 5 (Closed Range)
1..<5 // includes 1 and 4 (Half-Open Range)

var s = ""
for i in 1...5 {
  s += " \(i)"
}
s

s = ""
for i in 1..<5 {
  s += " \(i)"
}
s

// This is a Range<Int>
// This is Comparable *and* ForwardIndexType
// Is an Interval in matching contexts, but Range otherwise
var ri = 1...5
ri.startIndex
ri.endIndex


/*---------------------------------/
//  Intervals
/---------------------------------*/
// This is Comparable only

// This is a ClosedInterval<String>
var r = "a"..."z"
r.start
r.contains("w")

// This is a ClosedInterval<Character>
let a: Character = "a"
let d: Character = "d"
var rc = a...d
rc.start
rc.end
rc.contains("x")



/*---------------------------------/
//  Strides
/---------------------------------*/
var strideByTwos = stride(from: 0, to: 4, by: 2)
s = ""
for i in strideByTwos {
  s += " \(i)"
}
s


var strideToFour = stride(from: 0, through: 4, by: 2)
s = ""
for i in strideToFour {
  s += " \(i)"
}
s

// Note: this contains the end point, even though "to" is specified.
// This is because floats are inexact.
var floatsAreTricky = stride(from:0.1, to: 0.8, by: 0.1)
s = ""
for i in floatsAreTricky {
  s += " \(i)"
}
s





