import UIKit


/*--------------------------/
//  Closures
/--------------------------*/

// "close over"
var x = 10

let add: () -> Int = {
  x = x + 2
  return x
}

x
add()
x

x = 15
add()


// "close over" with private var
var y = 1000
func createAdder() -> () -> Int {
  var y = 10
  return {
    y = y + 2
    return y
  }
}

let addAgain = createAdder()

y
addAgain()
addAgain()
addAgain()
y

y = 0
addAgain()
y


// With a parameter
let addOne = { (x: Int) -> Int in
  return x + 1
}
addOne(10)


// With two parameters
let addTwoNumbers = { (x: Int, y: Int) -> Int in
  return x + y
}
addTwoNumbers(10, 12)


/*--------------------------/
//  Sorting
/--------------------------*/

let movies = ["ET", "alien", "ID", "Howard the Duck"]
sorted(movies)

// with explicit sort order
sorted(movies, { (mov1: String, mov2: String) -> Bool in
  return mov1 < mov2
})

// with assumed input types
sorted(movies, { (mov1, mov2) -> Bool in
  return mov1 < mov2
})

// with trailing closure
sorted(movies) { (mov1, mov2) -> Bool in
    return mov1 < mov2
}

// with default argument names
sorted(movies) {
  $0 < $1
}


// "named closures"
typealias SortStrings = (String, String) -> Bool
let byAlpha: SortStrings = {
  $0 < $1
}
sorted(movies, byAlpha)

let byUncasedAlpha: SortStrings = {
  $0.lowercaseString < $1.lowercaseString
}
sorted(movies, byUncasedAlpha)

let byLength: SortStrings = {
  count($0) < count($1)
}
sorted(movies, byLength)


/*--------------------------/
//  Capturing Values
/--------------------------*/
func makeGreeting(greeting: String) -> (Int) -> String {
  var count = 0
  return { (customerNumber: Int) -> String in
    count++
    return "\(count)) \(greeting), customer #\(customerNumber)!"
  }
}

let englishGreeting = makeGreeting("Hello")
let frenchGreeting = makeGreeting("Bonjour")
englishGreeting(123)
englishGreeting(222)
frenchGreeting(333)


