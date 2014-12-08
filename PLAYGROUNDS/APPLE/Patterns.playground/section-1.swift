func fizzBuzz(number: Int) -> String {
    switch (number % 3, number % 5) {
    case (0, 0):
        // number divides by both 3 and 5
        return "FizzBuzz!"
    case (0, _):
        // number divides by 3
        return "Fizz!"
    case (_, 0):
        // number divides by 5
        return "Buzz!"
    case (_, _):
        // number does not divide by either 3 or 5
        return "\(number)"
    }
}