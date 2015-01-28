import UIKit

/*
//  Named Parameters
//
//  Based on:
//  https://skillsmatter.com/skillscasts/6142-swift-beauty-by-default
/===================================*/



/*------------------------------------/
//  Functions: Unnamed
//
//  Looks like C
/------------------------------------*/
func add(x: Int, y: Int) -> Int {
  return x + y
}
add(1, 2)


/*------------------------------------/
//  Methods: First is Unnamed,
//           Rest Named
//
//  Because of Objective-C
/------------------------------------*/
class Adder {
  class func addX(x:Int, y:Int) -> Int {
    return x + y
  }
  
  func addX(x: Int, y:Int) -> Int {
    return x + y
  }
}

Adder.addX(1, y: 2)
Adder().addX(1, y: 2)


/*------------------------------------/
//  Initializer: Named
//
//  Because of Objective-C
/------------------------------------*/
class Rect {
  var x, y, width, height: Double
  init(x: Double, y: Double, width: Double, height: Double) {
    self.x = x
    self.y = y
    self.width = width
    self.height = height
  }
}

Rect(x: 0, y: 0, width: 100, height: 100)


/*-----------------------------------------/
//  Parameters with default value: Named
//
//  Makes optional parameter clearer
/-----------------------------------------*/
func greeting(name: String, yell: Bool = false) -> String {
  let greet = "Hello, \(name)"
  return yell ? greet.uppercaseString : greet
}
greeting("Jim")
greeting("Jim", yell: true)




