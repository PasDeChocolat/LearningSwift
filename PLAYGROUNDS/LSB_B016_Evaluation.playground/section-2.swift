import UIKit
import ExpressionParser

/*
//  Evaluation
//
//  Based on:
//  http://www.objc.io/books/ (Chapter 13, Case Study: Build a Spreadsheet Application)
//    (Functional Programming in Swift, by Chris Eidhof, Florian Kugler, and Wouter Swierstra)
/===================================*/


// This is just a test of the import from the "ExpressionParser" module.
let myParser: Parser<Character, Character> = Parser { _ in
  return none()
}

// Here goes nothing...


/*=====================================================================/
//  Evaluation
/=====================================================================*/


/*---------------------------------------------------------------------/
//  Result
/---------------------------------------------------------------------*/
enum Result {
  case IntResult(Int)
  case ListResult([Result])
  case EvaluationError(String)
}


/*---------------------------------------------------------------------/
//  lift - Allows use of func on Ints to be used on Result enums
/---------------------------------------------------------------------*/
func lift(f: (Int, Int) -> Int) -> ((Result, Result) -> Result) {
  return { l, r in
    switch (l, r) {
    case (.IntResult(let x), .IntResult(let y)):
      return .IntResult(f(x, y))
    default:
      return .EvaluationError("Type error, couldn't evaluate \(l) + \(r)")
    }
  }
}


/*---------------------------------------------------------------------/
//  integerOperators - List of operators
//  ("o" currently required to appease compiler)
/---------------------------------------------------------------------*/
func o(f: (Int, Int) -> Int) -> (Int, Int) -> Int {
  return f
}

let integerOperators: Dictionary<String, (Int, Int) -> Int> =
[ "+": o(+), "/": o(/), "*": o(*), "-": o(-) ]



/*---------------------------------------------------------------------/
//  evaluateIntegerOperator - Evaluates the Result of an binary Int 
//                            operation
/---------------------------------------------------------------------*/
func evaluateIntegerOperator(op: String,
                             l: Expression,
                             r: Expression,
                             evaluate: Expression? -> Result)
                             -> Result? {

    return integerOperators[op].map {
      lift($0)(evaluate(l), evaluate(r))
    }
}


/*---------------------------------------------------------------------/
//  evaluateListOperator - Evaluates the Result of list expression
//
//  NOTE: We only handle single column spreadsheets right now.
/---------------------------------------------------------------------*/
func evaluateListOperator(op: String,
                          l: Expression,
                          r: Expression,
                          evaluate: Expression? -> Result)
                          -> Result? {
    
    switch (op, l, r) {
    case (":", .Reference("A", let row1),
      .Reference("A", let row2)) where row1 <= row2:
      return Result.ListResult(Array(row1...row2).map {
        evaluate(Expression.Reference("A", $0))
        })
    default:
      return nil
    }
}

/*---------------------------------------------------------------------/
//  evaluateBinary - Evaluates the Result of any binary expression
/---------------------------------------------------------------------*/
func evaluateBinary(op: String,
                    l: Expression,
                    r: Expression,
                    evaluate: Expression? -> Result) -> Result {
    
    return evaluateIntegerOperator(op, l, r, evaluate)
      ?? evaluateListOperator(op, l, r, evaluate)
      ?? .EvaluationError("Couldn't find operator \(op)")
}


/*---------------------------------------------------------------------/
//  evaluateFunction - Evaluates the Result of some functions
//
//  NOTE: We only support limited set of functions, of one parameter.
/---------------------------------------------------------------------*/
func evaluateFunction(functionName: String, parameter: Result) -> Result {
  switch (functionName, parameter) {
  case ("SUM", .ListResult(let list)):
    return list.reduce(Result.IntResult(0), lift(+))
  case ("MIN", .ListResult(let list)):
    return list.reduce(Result.IntResult(Int.max),
      lift { min($0, $1) })
  default:
    return .EvaluationError("Couldn't evaluate function")
  }
}


/*---------------------------------------------------------------------/
//  evaluateExpression - Evaluates a single express
//
//  Takes a context to lookup saved cell value expressions
/---------------------------------------------------------------------*/
func evaluateExpression(context: [Expression?]) -> Expression? -> Result {
    
  return { (e: Expression?) in
    e.map { expression in
      let recurse = evaluateExpression(context)
      switch (expression) {
      case .Number(let x):
        return Result.IntResult(x)
      case .Reference("A", let idx):
        return recurse(context[idx])
      case .BinaryExpression(let s, let l, let r):
        return evaluateBinary(s, l.toExpression(),
          r.toExpression(), recurse)
      case .FunctionCall(let f, let p):
        return evaluateFunction(f,
          recurse(p.toExpression()))
      default:
        return .EvaluationError("Couldn't evaluate " +
          "expression")
      }
      } ?? .EvaluationError("Couldn't parse expression")
  }
}


/*---------------------------------------------------------------------/
//  evaluateExpressions - Convenience function for evaluating many
//                        optional expressions
/---------------------------------------------------------------------*/
func evaluateExpressions(expressions: [Expression?]) -> [Result] {
  return expressions.map(evaluateExpression(expressions))
}


let result6 = evaluateExpressions([parseExpression("3 * 2")])
result6[0]

func readResult(r: Result) -> String {
  switch r {
  case let .IntResult(i):
    return "Int: \(i)"
  case let .ListResult(list):
    return list.reduce("") { $0 + readResult($1) }
  case let .EvaluationError(er):
    return er
  }
}

readResult(result6[0])


// This is a spreadsheet!
let a0 = parseExpression("3 * 2")
let a1 = parseExpression("9")
let a2 = parseExpression("A0 + A1")
var r = evaluateExpressions([a0, a1, a2])
readResult(r[0])
readResult(r[1])
readResult(r[2])





