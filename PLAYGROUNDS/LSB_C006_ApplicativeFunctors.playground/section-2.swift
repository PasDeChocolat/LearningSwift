import UIKit

/*
//  Applicative Functors
//  a.k.a. Optionals
//
//  Suggested Reading:
//  http://www.objc.io/snippets/7.html
/===================================*/



/*------------------------------------/
//  Login again
/------------------------------------*/
func login(email: String, pw: String, success: Bool -> String) -> String {
  return success(email == "email" && pw == "pass")
}

func getEmail() -> String? {
  return "email"
}

func getPw() -> String? {
  return "pass"
}


// This is what you have to do to protect against nils
var returnVal = ""
if let email = getEmail() {
  if let pw = getPw() {
    returnVal = login(email, pw) { "success: \($0)" }
  } else {
    // error...
  }
} else {
  // error...
}
returnVal


/*---------------------------------------/
//  Optionals are Applicative Functors
/---------------------------------------*/
infix operator <*> { associativity left precedence 150 }
func <*><A, B>(lhs: (A -> B)?, rhs: A?) -> B? {
  if let lhs1 = lhs {
    if let rhs1 = rhs {
      return lhs1(rhs1)
    }
  }
  return nil
}

func curry<A, B, C, R>(f: (A, B, C) -> R) -> A -> B -> C -> R {
  return { a in { b in { c in f(a, b, c) } } }
}


// Use the new <*> operator
returnVal = ""
if let f = curry(login) <*> getEmail() <*> getPw() {
  returnVal = f { "success \($0)" }
} else {
  // error...
}
returnVal



