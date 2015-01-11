import UIKit

/*
//  Enumerations
/==============================*/

enum Weather {
  case Sunny
  case Cloudy
  case Rainy
}

Weather.Sunny

var conditions: Weather
conditions = .Sunny


enum Vehicle {
  case Van, Car, Train, Bus, Bicycle
}

Vehicle.Car


/*--------------------------/
// Raw member values
/--------------------------*/
enum Grades: Int {
  case A = 90
  case B = 80
  case C = 70
  case D = 60
  case F = 50
}

// infer consecutive raw values (must be Int)
enum SchoolYear: Int {
  case Freshman = 1
  case Sophomore
  case Junior
  case Senior
}

SchoolYear.Senior.rawValue == 4

if let yr = SchoolYear(rawValue: 3) {
  yr == .Junior
}


/*--------------------------/
// Associated values
/--------------------------*/
enum Color {
  case HEX(String)
  case RGB(UInt8, UInt8, UInt8)
  case RGBA(UInt8, UInt8, UInt8, UInt8)
  case ARGB(UInt8, UInt8, UInt8, UInt8)
  case HSV(Int, Int, Int)
  
  static func favorite() -> Color {
    return Color.HEX("AAFF00")
  }
  
  // enum method
  func description() -> String {
    switch self {
    case let .HEX(hex):
      return "#\(hex)"
      
    case let .RGB(r,g,b):
      return "\(r),\(g),\(b)"
      
    case let .RGBA(r,g,b,a):
      return "\(r),\(g),\(b),\(a)"
      
    case let .ARGB(a,r,g,b):
      return "\(a),\(r),\(g),\(b)"
      
    case let .HSV(h,s,v):
      return "\(h),\(s),\(v)"
      
    default:
      ""
    }
  }
}

// Same as any other Enum
let hexColor = Color.HEX("AAFF00")
switch hexColor {
case .HEX:
  "This is a HEX value"
default:
  ""
}

// Assignment of associated value
switch hexColor {
case let .HEX(hex):
  "HEX value: \(hex)"
default:
  ""
}
hexColor.description()

let rgbColor = Color.RGB(100, 10, 201)
switch rgbColor {
case let .RGB(r, g, b):
  "R:\(r) G:\(g) B:\(b)"
default:
  ""
}
rgbColor.description()


// type method
switch Color.favorite() {
case let .HEX(c):
  "Favorite: #\(c)"
default:
  ""
}





