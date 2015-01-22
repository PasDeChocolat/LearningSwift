import UIKit

/*
//  Decomposing Arrays
//
//  Suggested Reading:
//  http://www.objc.io/snippets/1.html
/===================================*/



/*------------------------------------/
//  Head : Tail
/------------------------------------*/
extension Array {
  var decompose: (head: T, tail: [T])? {
    return (count > 0) ? (self[0], Array(self[1..<count])) : nil
  }
}

func sum(xs: [Int]) -> Int {
  if let (head, tail) = xs.decompose {
    return head + sum(tail)
  } else {
    return 0
  }
}

sum([5])
sum([1, 2, 3])
sum([])

