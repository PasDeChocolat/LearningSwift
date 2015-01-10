import UIKit

/*
//  Program Flow
/==============================*/


/*---------------------/
//  For Loops
/---------------------*/

for var i=0; i<3; i++ {
  i // --> Click on circle to right to open Assistant
}


/*---------------------/
//  For-in Loops
/---------------------*/

for animal in ["dog", "cat", "squirrel"] {
  animal // --> Click on circle to right to open Assistant
}

for i in 3...5 {
  i // --> Click on circle to right to open Assistant
}

for (name, age) in ["George": 12, "Mike": 20, "Sarah": 30] {
  // --> Click on circle to right to open Assistant
  age
  name
}


/*---------------------/
//  While Loops
/---------------------*/

var i = 0
while i < 5 {
  i++
}


/*---------------------/
//  Do-while Loops
/---------------------*/

var x = 0
do {
  x + 5
  x++
} while x < 5

do {
  // this happens once, no matter what
  x + 5
} while false


/*---------------------/
//  Break
/---------------------*/

x = 0
do {
  if x > 5 { break }
  // this happens 6 times
  x++
} while true


/*---------------------/
//  If-else
/---------------------*/

x = 0
if x > 1 {
  // this never happens
} else if x == 0 {
  //this happens
  ++x
} else {
  // default
}


/*---------------------/
//  Switch
/---------------------*/

x = 0
switch x {
case 0:
  ++x
case 1:
  x += 10
default:
  x = 1000
}
x


// multiple values
x = 2
switch x {
case 0, 1, 2:
  // multiple values in single case
  ++x
case 2...10:
  // range as case
  x += 10
default:
  x = 1000
}
x


// fallthrough
x = 0
switch x {
case 0:
  ++x
  fallthrough
case 10:
  // x is 0 or 10
  // executed on fallthrough, no matter the case
  // (as long as the first case matches)
  x += 10
default:
  x = 1000
}
x


/*---------------------/
//  Switch w/ Tuples
/---------------------*/

let person = (name: "George", age: 21, favColor: "red")

// match by "name"
switch person {
case ("George", _, _):
  x = 1
default:
  x = 0
}
x

// match by "age"
switch person {
case (_, 21, _):
  x = 1
default:
  x = 0
}
x

// match by "age" range
switch person {
case (_, 0...21, _):
  x = 1
default:
  x = 0
}
x

// match by multiple values
switch person {
case (_, 21, "red"):
  x = 1
default:
  x = 0
}
x



/*-----------------------/
//  Switch w/ Tuples
//    and value binding
/-----------------------*/

switch person {
case (_, let age, "red"):
  x = age
default:
  x = 0
}
x

// with "where" qualifier
switch person {
case (_, let age, _) where age > 21:
  x = age
case (_, let age, _):
  x = age + 10
default:
  x = 0
}
x


/*-----------------------/
//  Switch w/ Enums
/-----------------------*/

enum Suit {
  case Heart, Spade, Diamond, Club
}

var card = Suit.Heart

x = 0
switch card {
case .Heart:
  x = 1
case .Spade:
  x = 2
case .Diamond:
  x = 3
case .Club:
  x = 4
}
// Note: No "default" required.
x


/*-----------------------/
//  Labels
/-----------------------*/
// continue
x = 0
outerloop: for i in 0...2 {
  x += i
  for j in 1000...2000 {
    if j > 1 { continue outerloop }
    x += j
  }
}
x

// break
x = 0
outerloop: for i in 0...2 {
  x += i
  for j in 1000...2000 {
    if j > 1 { break outerloop }
    x += j
  }
}
x








