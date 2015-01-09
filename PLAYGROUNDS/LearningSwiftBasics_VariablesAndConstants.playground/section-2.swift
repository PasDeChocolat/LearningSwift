import UIKit


/*--------------------------/
//  Variables and Constants
/--------------------------*/


/*---------------------/
// Let and Var
/---------------------*/
let x = 10
//x++ // error
var y = 10
y++


/*---------------------/
// Computed Variables
/---------------------*/
var w = 10.0
var h = 20.0
var area: Double {
  get {
    return w * h
  }

  set(newArea) {
    w = newArea
    h = 1.0
  }
}

w
h
area
area = 100.0
w
h

// Use the default `newValue` in the setter:
var squareArea: Double {
  get {
    return w * h
  }

  set {
    w = sqrt(newValue)
    h = sqrt(newValue)
  }
}
w = 100.0
h = 20.0
squareArea
squareArea = 100.0
w
h

// No setter, so we can omit the `get` and `set` keywords:
var fortune: String {
  return "You will find \(arc4random_uniform(100)) potatoes."
}
fortune
fortune



/*---------------------/
// Variable Observers
/---------------------*/
var calMsg0 = ""
var calMsg1 = ""
var caloriesEaten: Int = 0 {
  willSet(cals) {
    calMsg0 = "You are about to eat \(cals) calories."
  }

  didSet(cals) {
    calMsg1 = "Last time you ate \(cals) calories"
  }
}

calMsg0
calMsg1
caloriesEaten = 140
calMsg0
calMsg1


// Default variable names:
var alert0 = ""
var alert1 = ""
var alertLevel: Int = 1 {
  willSet {
    alert0 = "The new alert level is: \(newValue)"
  }

  didSet {
    alert1 = "No longer at alert level: \(oldValue)"
  }
}

alert0
alert1
alertLevel = 5
alert0
alert1


// Pick and choose:
alert0 = ""
var defcon: Int = 1 {
  willSet {
    if newValue >= 5 {
      alert0 = "BOOM!"
    }
  }
}
defcon = 4
alert0
defcon = 5
alert0


