import UIKit

/*
//  Currying
//
/===================================*/



/*------------------------------------/
//  Login
//
//  Suggested Reading:
//  http://www.objc.io/snippets/6.html
/------------------------------------*/
func success(s: Bool) -> String {
  if s {
    return "Logging in"
  } else {
    return "Not loggin in!"
  }
}

func login(email: String, pw: String, success: Bool -> String) -> String {
  return success(email == "email" && pw == "pass")
}

login("email", "pass", success)
login("email", "bad", success)


/*------------------------------------/
//  Native Swift curry
/------------------------------------*/
func curriedLogin1(# email: String)(pw: String)(success: Bool -> String) -> String {
  return success(email == "email" && pw == "pass")
}

let userLogin1 = curriedLogin1(email: "email")(pw: "pass")
userLogin1(success)
let userLoginResult = userLogin1({ _ in "Log in no matter what!" })
userLoginResult


/*------------------------------------/
//  Curry with generic function
/------------------------------------*/
func curry<A, B, C, R>(f: (A, B, C) -> R) -> A -> B -> C -> R {
  return { a in { b in { c in f(a, b, c) } } }
}

let curriedLogin2 = curry(login)

let userLogin2 = curriedLogin2("email")("pass")
userLogin2(success)

curriedLogin2("email")("bad")(success)



/*------------------------------------/
//  Instance Variables
//  ...an implementation detail
//
//  Suggested Reading:
//  http://oleb.net/blog/2014/07/swift-instance-methods-curried-functions/
/------------------------------------*/
class BankAccount {
  var balance: Double = 0.0
  
  func deposit(amount: Double) {
    balance += amount
  }
}

// You can do this, of course
let account = BankAccount()
account.deposit(100)
account.balance

// But, you can also do this
let depositor = BankAccount.deposit
depositor(account)(100)
account.balance

// Which is also
BankAccount.deposit(account)(100)
account.balance




