protocol Edible {
    var name: String { get }
    var value: Int { get }
}

struct Banana: Edible {
    var name: String { get { return "Banana" } }
    var value: Int { get { return 10 } }
}

struct DogTreat: Edible {
    var name: String { get { return "Dog Treat" } }
    var value: Int { get { return 5 } }
}

class Animal {
    let name: String
    var energy = 100

    init (name: String) {
        self.name = name
    }

    private func makeSound() {
        energy -= 5
        printEnergy()
    }

    private func eat(food: Edible) {
        println("[\(name) is eating a \(food.name) for \(food.value) energy]")
        energy += food.value
        printEnergy()
    }

    private func printEnergy() {
        println("[\(name) now has \(energy) energy]")
    }
}

class Dog: Animal {
    override func makeSound() {
        println("Bark")
        super.makeSound()
    }
}

class Dubya: Dog {
    init () {
        super.init(name: "Dubya")
    }
    
    override func eat(food: Edible) {
        if food as? Banana {
            println("Yuck!")
        } else {
            super.eat(food)
        }
    }
}

func play(animal: Animal) {
    println ("Playing with \(animal.name)")
    animal.makeSound()
}

let dog = Dog(name: "fido")
play(dog)
play(dog)
play(dog)
play(dog)
play(dog)
play(dog)
dog.eat(Banana())

let dubya = Dubya()
play(dubya)
dubya.eat(Banana())
dubya.eat(DogTreat())
