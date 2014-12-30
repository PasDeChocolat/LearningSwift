// Playground - noun: a place where people can play

import UIKit



// iBook: 
//   Language Guide:
//     Automatic Reference Counting:
//       Resolving Strong Reference Cycles for Closures:
//         Defining a Capture List
class Dog {
    init() {
        
    }
    
    func bark () -> String {
        return "hello"
    }
}

let a = Dog()

a.bark()

var b : Dog?

b?.bark()

var c : Dog?
c = Dog()
let greeting = c?.bark()

greeting! + " world"
