import UIKit

/*
//  Types
/==============================*/


/*--------------------------/
//  Any and AnyObject
/--------------------------*/
class MyClass {}
struct MyStruct {}
func myFunc() -> () {}
typealias MyFunc = () -> ()
enum MyEnum {
  case First
}

// "Any" takes instance of any type
var anyArray = [Any]()
anyArray.append(1)
anyArray.append(3.14)
anyArray.append("word")
anyArray.append(MyClass())
anyArray.append(MyStruct())
anyArray.append(myFunc)
anyArray.append(MyFunc)
anyArray.append(MyEnum)
anyArray.append(MyEnum.First)

var anyArrayWithNils = [Any?]()
anyArrayWithNils.append(nil)


// "AnyObject" takes instance of any class
var anyObjectArray = [AnyObject]()
anyObjectArray.append(1)
anyObjectArray.append(3.14)
anyObjectArray.append("word")
anyObjectArray.append(MyClass())
//anyObjectArray.append(MyStruct())   // <- Not allowed
//anyObjectArray.append(myFunc)       // <- Not allowed
//anyObjectArray.append(MyFunc)       // <- Not allowed
//anyObjectArray.append(MyEnum)       // <- Not allowed
//anyObjectArray.append(MyEnum.First) // <- Not allowed

var anyObjectArrayWithNils = [AnyObject?]()
anyObjectArrayWithNils.append(nil)


/*--------------------------/
//  Testing
/--------------------------*/
class Mammal {}
class Dog: Mammal {}
class Clam {}

//Dog() is Mammal   // <- Compiler error
Mammal() is Dog
//Clam() is Mammal  // <- Compiler error


/*--------------------------/
//  Downcasting Types
/--------------------------*/
class Cat: Mammal {
  func meow() -> String {
    return "meow"
  }
}

class Bear: Mammal {
  func roar() -> String {
    return "Rooooar"
  }
}

let cat = Cat()
let bear = Bear()
var mammals = [Mammal]()
mammals.append(cat)
mammals.append(bear)

if let b = mammals[1] as? Bear {
  b.roar()
}

switch mammals[0] {
case let c as Cat:
  c.meow()
case let b as Bear:
  b.roar()
default:
  ""
}

let anotherCat = cat as Cat // because we're sure of it
anotherCat.meow()

//let notACat = bear as Cat // -> Compiler error


/*----------------------/
// Type Casting
// https://developer.apple.com/library/mac/documentation/Swift/Conceptual/Swift_Programming_Language/TypeCasting.html
// http://www.eswick.com/2014/06/inside-swift/
// https://www.mikeash.com/pyblog/friday-qa-2014-08-15-swift-name-mangling.html
//---------------------*/

var thingsao : [AnyObject] = [3, 3.14, "pi"]
//thingsao.dynamicType
//_stdlib_getTypeName(thingsao)
_stdlib_getDemangledTypeName(thingsao)
String.fromCString(object_getClassName(thingsao))
let ft : AnyObject = thingsao.first!

// An array of Any
var thingsa : [Any] = [3, 3.14, "pi"]
var fa : Any = thingsa[0]
var fi : Int = fa as! Int
var fs : String = thingsa[2] as! String

