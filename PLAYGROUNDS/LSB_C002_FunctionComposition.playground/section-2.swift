import UIKit

/*
//  Function Compostions
//
//  Suggested Reading:
//  http://www.objc.io/snippets/2.html
/===================================*/



/*------------------------------------/
//  Contrived random string example
/------------------------------------*/
let max = 5

func rand() -> Int {
  return Int(arc4random_uniform(UInt32(max))) + 1
}

func randomize(xs: [Int]) -> [Int] {
  return xs.map { _ in rand() }
}

func letterize(xs: [Int]) -> [[Character]] {
  return xs.map { [Character](count: $0, repeatedValue: "i") }
}

func stringize(xs: [[Character]]) -> [String] {
  return xs.map { String($0) }
}


let starter = [Int](count: 10, repeatedValue: 1)
stringize(letterize(randomize(starter)))



/*------------------------------------/
//  Composition operator
/------------------------------------*/
infix operator >>> { associativity left }
func >>> <A, B, C>(f: B -> C, g: A -> B) -> A -> C {
  return { x in f(g(x)) }
}

let codify = stringize >>> letterize >>> randomize
codify(starter)


// and also...
func randInt(n: Int) -> Int {
  let UInt32ToInt = { (x: UInt32) -> Int in Int(x) }
  let randomUInt32 = { (x: UInt32) -> UInt32 in arc4random_uniform(x) }
  let IntToUInt32 = { (x: Int) -> UInt32 in UInt32(x) }
  let f = UInt32ToInt >>> randomUInt32 >>> IntToUInt32
  return f(n) + 1
}
randInt(10)





