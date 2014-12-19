import UIKit


/*---------------------/
// Type Casting
// https://developer.apple.com/library/mac/documentation/Swift/Conceptual/Swift_Programming_Language/TypeCasting.html
//---------------------*/

var thingsao : [AnyObject] = [3, 3.14, "pi"]
//thingsao.dynamicType
_stdlib_getTypeName(thingsao)
_stdlib_getDemangledTypeName(thingsao)
String.fromCString(object_getClassName(thingsao))
let ft : AnyObject = thingsao.first!

// An array of Any
var thingsa : [Any] = [3, 3.14, "pi"]
var fa : Any = thingsa[0]
var fi : Int = fa as Int
var fs : String = thingsa[2] as String


/*---------------------/
   Pattern Matching
/---------------------*/
// See Patterns.playground
// FizzBuzz example.

// Enumerations: Show example of how to use in `switch` first.





