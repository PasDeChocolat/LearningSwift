import UIKit

/*
//  Type Inference
//
//  Based on:
//  https://skillsmatter.com/skillscasts/6142-swift-beauty-by-default
/===================================*/



/*------------------------------------/
//  Type Inference
/------------------------------------*/
var nums1: [Int] = [1, 42, 32, 4, 5]
var nums2 = [1, 42, 32, 4, 5]


nums1.sort { (a: Int, b: Int) -> Bool in
  return a < b
}
nums1

nums1.sort { a, b in a < b }
nums1

nums1.sort { $0 < $1 }
nums1

nums1.sort(<)
nums1




