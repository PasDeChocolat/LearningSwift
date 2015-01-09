import UIKit


/*----------------------/
// Dictionaries
//---------------------*/

// Initialization
let namesAndAges1 : Dictionary<String,Int> = ["Charles":18]

// preferred shorthand
let namesAndAges2 : [String:Int] = ["Charles":18]

// inferred types
let namesAndAges3 = ["Charles":18]


// declare an empty Dictionary
var namesAndAges4 = [String:Int]()
namesAndAges4["Charles"] = 18
namesAndAges4["Charles"]!


// Declare capacity on creation, for performance reasons.
// Can't change or determine capacity later.
var namesAndAges5 = [String:Int](minimumCapacity: 5)
namesAndAges5["Charles"] = 18


// Value Type
var myAge = 28
namesAndAges5["Kyle"] = myAge
var anotherAge = namesAndAges5["Kyle"]!
anotherAge = 30
myAge

// It's a Value Type, but classes...
class MyPerson {
  var age = 28
}
var namesAndPersons : [String:MyPerson] = ["Kyle":MyPerson()]
namesAndPersons["Kyle"]!.age

var personKyle = namesAndPersons["Kyle"]!
personKyle.age = 30
namesAndPersons["Kyle"]!.age


// isEmpty
namesAndAges5.isEmpty

var namesAndAgesEmpty = [String:Int]()
namesAndAgesEmpty.isEmpty

// count
namesAndAges5.count
namesAndAgesEmpty.count

// keys
// first modify the dictionary with subscript notation:
namesAndAges5["Joe"] = 22
namesAndAges5["Ada"] = 45

namesAndAges5.keys
//namesAndAges5.keys[1] // <-- Doesn't work
// but this does...
var theNamesString = ""
for name in namesAndAges5.keys {
  theNamesString += name + " "
}
theNamesString

// if you need keys as a proper array, do this:
let theNames = [String](namesAndAges5.keys)
theNames[1]

// values
let theValues = [Int](namesAndAges5.values)


// Modifying Dictionaries

// remove with nil
namesAndAges5["Ada"] = nil
[String](namesAndAges5.keys)

// removeValueForKey
namesAndAges5.removeValueForKey("Joe")
[String](namesAndAges5.keys)

// returns nil if key doesn't exist
namesAndAges5.removeValueForKey("Xerxes")

// updateValue
namesAndAges5["Kyle"]!
namesAndAges5.updateValue(99, forKey: "Kyle")
namesAndAges5["Kyle"]!

// returns nil if key doesn't exist:
namesAndAges5.updateValue(99, forKey: "Xerxes")
namesAndAges5["Xerxes"]!

// removeAll
namesAndAges5.removeAll()
[String](namesAndAges5.keys)


// Iteration
namesAndAges5 = ["Kyle":28, "Joe":22, "Ada":45, "Charles": 18]
theNamesString = ""
for (name, age) in namesAndAges5 {
  theNamesString += "\(name) is \(age) years old. "
}
theNamesString
