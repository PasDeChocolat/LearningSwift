import UIKit

/*
//  Reduce
//
//  Suggested Reading:
//  http://www.objc.io/snippets/5.html
/===================================*/



/*------------------------------------/
//  Reduce!
/------------------------------------*/
let sum: [Int] -> Int = { $0.reduce(0, combine: +) }
sum([1,2,3,4,5])

let product: [Int] -> Int = { $0.reduce(1, combine: *) }
product([1,2,3,4,5])

let all: [Bool] -> Bool = { $0.reduce(true, combine: { $0 && $1 }) }
all([true, true, true])
all([true, true, false])
all([false, false, false])




