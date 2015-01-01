// Import a Swift classes (Giraffe, Elephant)
//   from an included Framework project (Animal)
//
import Animal

let giraffe = Giraffe()
let giraffeGreeting = giraffe.sayHello()



// But, what about similarly named classes?
class Elephant {
  // A local class which has clashing name.
}

// Must use a Framework qualifier (Animal):
let elephant = Animal.Elephant()
let elephantGreeting = elephant.sayHello()