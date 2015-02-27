import UIKit

/*
//  Protocols
/==============================*/


/*-----------------------------/
// Pure Swift - No Optionals
/-----------------------------*/

protocol Talking {
  static var word: String { get }
  var verbosity: Int { get set }
  func speak() -> String
}

class Dog: Talking {
  
  class var word: String {
    return "Woof"
  }
  
  var verbosity = 3
  
  func speak() -> String {
    var s = ""
    for i in 1...verbosity {
      s += Dog.word
    }
    return s
  }
  
}

let d = Dog()
d.speak()

d.verbosity = 5
d.speak()



/*-----------------------------/
//  Extending classes
/-----------------------------*/
protocol Smashable {
  func smush() -> String
}

extension String: Smashable {
  func smush() -> String {
    return "\(self) is smushed."
  }
}

"The ant".smush()


// Some slightly more useful Monkey Patching
protocol OddEvenCheckable {
  func isOdd() -> Bool
  func isEven() -> Bool
}

extension Int: OddEvenCheckable {
  func isOdd() -> Bool {
    return (self % 2) == 1
  }
  func isEven() -> Bool {
    return (self % 2) == 0
  }
}

1.isOdd()
1.isEven()
2.isOdd()
2.isEven()


/*-----------------------------/
//  Protocol as Type
/-----------------------------*/

protocol Tooting {
  func toot() -> String
}

class Trumpet: Tooting {
  func toot() -> String {
    return "Toot!"
  }
}

class TimeMachine: Tooting {
  func toot() -> String {
    return "Toot!"
  }
}

// Can hold any type, based on behavior!
var tooters = [Tooting]()
tooters.append(Trumpet())
tooters.append(TimeMachine())

tooters[0].toot()
tooters[1].toot()


/*-----------------------------/
//  Protocol Conformance
/-----------------------------*/
// Only works for @objc protocols!
func checkObjcType(t: AnyObject) -> Bool {
  return t is Digging
}

checkObjcType(Gopher())
checkObjcType(1)

//Trumpet() is Tooting // Not Allowed



