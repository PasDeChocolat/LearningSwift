import UIKit

/*
//  Memory Management
//
//  Recommeded Reading:
//  https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html
/==============================*/


/*-----------------------------/
//  Retain Cycle
/-----------------------------*/

class A {
  let name = "a"
  var otherB: B?
}
class B {
  let name = "b"
  var otherA: A?
}

var a: A? = A()
var b: B? = B()

a!.otherB = b
b!.otherA = a

a = nil
let oa = b!.otherA!
oa.name
b = nil

// and now we have a memory leak


/*-----------------------------/
//  Weak Cycle
/-----------------------------*/
class Renter {
  var apartment: Apartment?
}

class Apartment {
  // must be optional
  weak var tenant: Renter?
}

var trenton: Renter? = Renter()
var apt42: Apartment? = Apartment()

trenton!.apartment = apt42
apt42!.tenant = trenton

// renter and apartment have independent existences


/*-----------------------------/
//  Unowned Cycle
/-----------------------------*/
class Customer {
  var card: CreditCard?
}

class CreditCard {
  // must be non-optional
  unowned let customer: Customer
  
  init(customer: Customer) {
    self.customer = customer
  }
}

var bob: Customer? = Customer()
bob!.card = CreditCard(customer: bob!)

// credit card instance only exists as long as bob does


// Implicitly Unwrapped Example:
class Country {
  let capitalCity: City!
  let name: String
  
  init(name: String, capitalName: String) {
    self.name = name
    self.capitalCity = City(name: capitalName)
    self.capitalCity.country = self
  }
}

class City {
  var country: Country?
  
  let name: String
  
  init(name: String) {
    self.name = name
  }
}

var country = Country(name: "Russia", capitalName: "Moscow")
country.name
country.capitalCity.name


/*-------------------------------/
//  Retain Cycles and Closures
/-------------------------------*/
class Greeter {
  let name: String
  init(name: String) {
    self.name = name
  }
  
  func greet() -> String {
    
    var aClosure: () -> String = {
      [weak self] in
      var s = "Hello"
      if let weakSelf = self {
        return "Hello: \(weakSelf.name)"
      }
      return s
    }
    return aClosure()
  }
  
}

Greeter(name: "Ted").greet()


