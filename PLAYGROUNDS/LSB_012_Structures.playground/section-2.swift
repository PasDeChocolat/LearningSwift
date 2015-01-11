import UIKit

/*
//  Structures
/==============================*/


/*--------------------------/
//  Methods and Properties
/--------------------------*/
struct Circle {
  // type constant
  static let pi = 3.14
  
  // type method 
  static func area(# radius: Double) -> Double {
    return pi * pow(radius, 2.0)
  }
  
  // property
  var radius: Double = 10.0
  
  // method
  func area() -> Double {
    return Circle.area(radius: radius)
  }
  
  // mutating method
  mutating func scalex(factor: Double) {
    radius *= factor
  }
  
}

var c = Circle()
c.radius
c.area()

c.scalex(2.0) // only works if "Circle" instance is a `var`
c.radius
c.area()


/*------------------------------------/
// Automatically creates initializer
/------------------------------------*/
c = Circle(radius: 20.0)
c.radius


/*------------------------------------/
// Initializer delegation
/------------------------------------*/
struct Square {
  var side: Double

  init(_ side: Double) {
    self.side = side
  }
  
  init() {
    // call designated initializer
    self.init(10.0)
  }
}

let s1 = Square(20.0)
s1.side

let s2 = Square()
s2.side





