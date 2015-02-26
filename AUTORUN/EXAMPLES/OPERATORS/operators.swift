import Foundation

// MARK: - Regex!

class Regex {
    let pattern: String

    init(_ pattern: String) {
        self.pattern = pattern
    }

    func test(input: String) -> Bool {
        let range = input.rangeOfString(pattern, options: .RegularExpressionSearch)
        if let r = range {
            return true
        } else {
            return false
        }
    }
}

infix operator =~ {}

func =~(input: String, pattern: String) -> Bool {
    return Regex(pattern).test(input)
}

let input = "2345"
if input =~ "\\d+" {
    println("Matches")
} else {
    println("doesn't match")
}


// MARK: - Dot Product!
struct Vector {
    let x: Float
    let y: Float
    
    func dotProduct(other: Vector) -> Float {
        return x * other.x + y * other.y
    }
}

let a = Vector(x: 1, y: 8)
let b = Vector(x: 6, y: 2)

infix operator .. {}

func ..(a: Vector, b: Vector) -> Float {
    return a.dotProduct(b)
}

println("result of a.dotProduct(b) is: \(a.dotProduct(b))")
println("result of a .. b is: \(a .. b)")