import UIKit

/*
//  Classes and Structs
//
//  What's difference between Classes and Structs?
//
//  Suggested Reading:
//  https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ClassesAndStructures.html
//
// From Apple's docs...
//
// Classes have additional capabilities that structures do not:
// - Inheritance enables one class to inherit the characteristics of another.
// - Type casting enables you to check and interpret the type of a class instance at runtime.
// - Deinitializers enable an instance of a class to free up any resources it has assigned.
// - Reference counting allows more than one reference to a class instance.
//
/===================================*/


/*---------------------------------------------------------/
//  Classes are reference types, Structs are value types
/---------------------------------------------------------*/

class RectClass {
  var width: Double = 0.0
  var height: Double = 0.0
}
var rc1 = RectClass()
rc1.width = 42
var rc2 = rc1
rc2.width = 100
rc2.height

// original object has changed
rc1.width


struct RectStruct {
  var width: Double = 0.0
  var height: Double = 0.0
}
var rs1 = RectStruct()
rs1.width = 42
var rs2 = rs1
rs2.width = 100

// original struct instance has *not* changed
rs1.width


/*---------------------------------------------------------/
//  Objects are pass by reference
//  Structs are pass by value
/---------------------------------------------------------*/
func makeSquare(rect: RectClass) {
  rect.height = rect.width
}

rc1.width
makeSquare(rc1)
rc1.width
rc1.height

//func makeSquare(rect: RectStruct) {
//  rect.width = rect.height // Not allowed!
//}

// requires *explicit* pass by reference `inout`
func makeSquare(inout rect: RectStruct) {
    rect.height = rect.width
}

rs1.width
rs1.height
makeSquare(&rs1)
rs1.width
rs1.height


/*---------------------------------------------------------/
//  Classes can inherit from super-classes.
/---------------------------------------------------------*/
class SquareClass: RectClass {
  override var height: Double {
    get { return self.width }
    set { self.width = newValue }
  }
}
let sc1 = SquareClass()
sc1.width = 10
sc1.height


// Inheritance not allowed by Struct from Struct
//struct SquareStruct: RectStruct {
//}


