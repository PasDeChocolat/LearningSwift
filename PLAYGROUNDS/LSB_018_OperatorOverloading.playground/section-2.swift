import UIKit

/*
//  Operator Overloading
//  
//  Suggested Reading:
//  https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AdvancedOperators.html#//apple_ref/doc/uid/TP40014097-CH27-ID28
//  http://nshipster.com/swift-operators/
/==============================*/


/*---------------------------------/
//  Overload an operator
/---------------------------------*/
func * (s: String, n: Int) -> String {
  var t = ""
  for i in 0..<n {
    t += s
  }
  return t
}

"hello" * 3


/*---------------------------------------/
//  Overload operator for Vectors
/---------------------------------------*/
struct V {
  static let defaultValue = 0.0
  var x, y, z: Double
  
  init(x: Double = V.defaultValue, y: Double = V.defaultValue, z:Double = V.defaultValue) {
    self.x = x
    self.y = y
    self.z = z
  }
  
  init(_ x: Double = V.defaultValue, _ y: Double = V.defaultValue, _ z: Double = V.defaultValue) {
    self.init(x: x, y: y, z: z)
  }
}

let vel3D = V(x: 1.0, y: 1.0, z: 1.0)
let vel2D = V(x: 1.0, y: 1.0)

let acc3D = V(1.0, 1.0, 1.0)
let acc2D = V(1.0, 1.0)


// Adding Vectors
func + (a: V, b: V) -> V {
  return V(a.x + b.x, a.y + b.y, a.z + b.z)
}

vel3D + acc3D
vel2D + acc2D


/*---------------------------------------/
//  Overload operator for Vectors
//  with n dimensions
/---------------------------------------*/
struct VV {
  var c = [Double]() // It's not possible to make this private yet.
  
  init (_ components: [Double]) {
    c = components
  }
  
  var components: [Double] {
    return c
  }
  
  var count: Int {
    return c.count
  }
  
  var magnitude: Double {
    let sum = components.reduce(0.0, combine: { (sum, x) -> Double in
      return sum + pow(x, 2)
    })
    return sqrt(sum)
  }
  
  func getComponentAtIndex(i: Int) -> Double? {
    if c.count > i {
      return c[i]
    } else {
      return nil
    }
  }
  
  mutating func setComponentAtIndex(i: Int, newValue: Double) {
    if c.count > i {
      c[i] = newValue
    } else {
      c.append(newValue)
    }
  }
  
  subscript(index: Int) -> Double? {
    get { return getComponentAtIndex(index) }
    set { setComponentAtIndex(index, newValue: newValue!) }
  }
  
  var x: Double? {
    get { return getComponentAtIndex(0) }
    set { setComponentAtIndex(0, newValue: newValue!) }
  }
  var y: Double? {
    get { return getComponentAtIndex(1) }
    set { setComponentAtIndex(1, newValue: newValue!) }
  }
  var z: Double? {
    get { return getComponentAtIndex(2) }
    set { setComponentAtIndex(2, newValue: newValue!) }
  }
}

var c = [1.0, 2.0, 3.0]
var v = VV(c)
v.x!
v.y!
v.z!
v.x = 3.14
v.y = 4.14
v.z = 5.14
v.x!
v.y!
v.z!

v[0]!
v[0] = 100.0
v[0]!

// Adding vectors of n dimensions
// where uneven vector gets zeros
func + (a: VV, b: VV) -> VV {
  let maxCount = max(a.count, b.count)
  var c = [Double]()
  for var i=0; i<maxCount; i++ {
//    let va = i < a.count ? a[i]! : 0.0
//    let vb = i < b.count ? b[i]! : 0.0
    let va = a[i] ?? 0.0
    let vb = b[i] ?? 0.0
    c.append(va+vb)
  }
  return VV(c)
}

let w = VV([1.0, 2.0, 3.0]) + VV([0.1, 0.2, 0.3, 0.4])
w


/*---------------------------------/
//  Overload unary operator
/---------------------------------*/
prefix func ++ (inout v: VV) -> VV {
  let c = v.components.map { $0 + 1.0 }
  v = VV(c)
  return v
}

v
++v // return changed values
v

postfix func ++ (inout v: VV) -> VV {
  let temp = v
  v = ++v
  return temp
}

v
v++ // return original values
v


/*---------------------------------/
//  Custom operators
/---------------------------------*/
v.magnitude

prefix operator |^^| {}
prefix func |^^| (v: VV) -> Double {
  return v.components.reduce(0.0, combine: { $0 + pow($1, 2) })
}

prefix operator ||| {}
prefix func ||| (v: VV) -> Double {
  return sqrt(|^^|v)
}
|^^|v
|||v




