import UIKit

/*
//  Classes
/==============================*/


/*---------------------/
//  Person Class
/---------------------*/
class Person {
  // with constant property
  let legs = 2
}

let joe = Person()
joe.legs


// constant property initialized in init method
class Dog {
  let legs: Int
  init() {
    legs = 4
  }
}
let fido = Dog()
fido.legs


// setup in initializer
class Cat {
  let lives: Int
  init(lives: Int) {
    self.lives = lives
  }
}
let garfield = Cat(lives: 9)
garfield.lives


/*---------------------/
//  Subclass: Artist
/---------------------*/
class Artist: Person {
  // with property
  var favoriteColor = "red"
}

let fred = Artist()
fred.legs
fred.favoriteColor
fred.favoriteColor = "blue"
fred.favoriteColor


/*-----------------------/
//  Computed Properties
/-----------------------*/

class Rect {
  var width, height: Double
  
  init(width w: Double, height h: Double) {
    width = w
    height = h
  }
  
  var area: Double {
    get {
      return width * height
    }
    
    set(area) {
      width = area / 2.0
      height = area / width
    }
  }
}

let r = Rect(width: 10.0, height: 10.0)
r.area
r.area = 20.0
r.width
r.height


// only getter
class Circle {
  var radius: Double

  init(radius r: Double) {
    radius = r
  }
  
  // no need for "get" and "set"
  var area: Double {
    return 3.14 * pow(radius, 2.0)
  }
}

let c = Circle(radius: 10.0)
c.area


/*-----------------------/
//  Property Observers
/-----------------------*/
// computed properties would probably be a better idea...
class Toaster {
  
  // constant property
  let freezingF = 32.0
  
  // class function
  class func celsiusFrom(fahrenheit f: Double) -> Double {
    return (f - 32.0) / 1.8
  }
  
  // observe changes to F
  var tempF: Double = 0.0 {
    willSet(f) {
      tempC = Toaster.celsiusFrom(fahrenheit: f)
    }
    
    didSet(oldF) {
      if tempF > freezingF && oldF <= freezingF {
        "thawing!"
      } else if tempF <= freezingF && oldF > freezingF {
        "freezing!"
      }
    }
  }
  
  var tempC: Double = Toaster.celsiusFrom(fahrenheit: 0.0)
}

let t = Toaster()
t.tempF
t.tempC

t.tempF = 100.0
t.tempC


/*----------------------------/
//  Computed Type Properties
//    and Type Methods
/----------------------------*/
class Weather {
//  class var avgConditions: String = "Something" // <-- "Class variables not yet supported"
  
  // type property
  class var conditions: String {
    get {
      // It's always sunny
      return "Sunny"
    }
    
    set {
      // do something with `newValue` here
    }
  }
  
  // type method
  class func forecast () -> String {
    return "\(conditions) and 73 degrees F."
  }
}

Weather.conditions // of dubious value
Weather.forecast()


/*----------------------------/
//  Methods
/----------------------------*/
class Frog {
  func sayHello() -> String {
    return "ribbit"
  }
}

let f = Frog()
f.sayHello()


// local and external param names
class Cow {
  
  // internal only
  func eat(food: String) -> String {
    return "Moo, I ate some \(food)."
  }
  
  // different internal and external
  func moo(times n: Int) -> String {
    if n == 0 { return "!" }
    
    // refer to the actual instance as "self"
    var s: String = self.moo(times: n-1)
    if s != "!" {
      s = " " + s
    }
    
    return "moo" + s
  }
  
  // same internal and external
  func sayHello(# to: String) -> String {
    return "Moo, hello there \(to)."
  }
}

let bessie = Cow()
bessie.eat("grass")

bessie.sayHello(to: "Fred")

bessie.moo(times: 3)


/*----------------------------/
//  Subscripts
/----------------------------*/
class Forecast {
  var description: String = "sunny"
  
  subscript(index: Int) -> String {
    get {
      var day = ""
      switch index {
      case 0, 7:
        day = "Weekend weather is"
      case 1...6:
        day = "Weekday conditions are"
      default:
        day = "It's always"
      }
      
      return "\(day) \(description)."
    }
    
    set {
      description = newValue
    }
  }
}

let forecast = Forecast()
forecast[0]
forecast[1]

forecast[0] = "cloudy"
forecast[100]


/*----------------------------/
//  Initialization
/----------------------------*/

class Square {
  var side: Double
  
  // 1) a simple designated initializer
  init() {
    side = 10.0
  }
  
  // 2) with automatic external parameter name
  init(side: Double) {
    self.side = side
  }
  
  // 3) with no external parameter name
  init (_ side: Double) {
    self.side = side
  }
  
  // 4) convenience initializer
  convenience init(side: String) {
    self.init(side: (side as NSString).doubleValue)
  }
  
  deinit {
    // do something before deallocation
  }
}

let sq1 = Square()
sq1.side

let sq2 = Square(side: 20.0)
sq2.side

let sq3 = Square(30.0)
sq3.side

let sq4 = Square(side: "123.4")
sq4.side


/*-------------------------------/
//  Classes are reference types
/-------------------------------*/
let x = Square(42.0)
x.side

let y = x
y.side
y.side = 100.1
x.side

x === y






