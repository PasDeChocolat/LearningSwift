import UIKit


/*--------------------------/
// Tuples
/--------------------------*/
let rob = ("Rob", "Smith", 49)
let (firstName, lastName, age) = rob
firstName
rob.1

var person: (name: String, age: Int)
person.name = "Rob"
person.age = 21


// As argument type
func birth() -> (name: String, eyeColor: String) {
  return ("George", "blue")
}
let p = birth()
p.name
p.eyeColor


// As return type
func pickNumberFromBag() -> (result: Int, isLast: Bool) {
  return (Int(arc4random_uniform(10)), false)
}
pickNumberFromBag().0


// Type Alias
typealias human = (name: String, height: Double)
func enroll(h: human) -> String {
  return "\(h.name) is \(h.height) feet tall."
}
enroll(("Phil", 6.3))

