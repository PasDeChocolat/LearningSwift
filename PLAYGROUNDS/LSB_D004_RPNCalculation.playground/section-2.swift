import UIKit

/*
//  RPN Calculation
//
//  Based on:
//  https://itunesu.itunes.apple.com/WebObjects/LZDirectory.woa/ra/directory/courses/961180099/feed (Developing iOS 8 Apps with Swift, Lecture 3, Stanford CS193p)
//  http://learnyouahaskell.com/functionally-solving-problems#reverse-polish-notation-calculator (Learn You a Haskell for Great Good!, Ch 10)
//
//
//  Note: "Reverse Polish notation (RPN) is a mathematical notation in which every operator follows all of its operands, in contrast to Polish notation, which puts the operator in the prefix position. It is also known as postfix notation and is parenthesis-free as long as operator arities are fixed. The description "Polish" refers to the nationality of logician Jan Łukasiewicz, who invented (prefix) Polish notation in the 1920s, and to the fact that people who speak English but not Polish find his family name intimidating and possibly unpronounceable."
//  - Excerpt from Wikipedia (1/29/2015): https://en.wikipedia.org/wiki/Reverse_Polish_notation
/===================================*/



/*------------------------------------/
//  The Stanford Way
/------------------------------------*/
class CalculatorBrain {
  private enum Op {
    case Operand(Double)
    case UnaryOperation(String, Double -> Double)
    case BinaryOperation(String, (Double, Double) -> Double)
  }
  
  private var opStack = [Op]()
  private var knownOps = [String:Op]()
  
  init() {
    knownOps["×"] = Op.BinaryOperation("×", *)
    knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
    knownOps["+"] = Op.BinaryOperation("+", +)
    knownOps["-"] = Op.BinaryOperation("-") { $1 - $0 }
    knownOps["√"] = Op.UnaryOperation("√", sqrt)
  }
  
  private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
    if !ops.isEmpty {
      var remainingOps = ops
      let op = remainingOps.removeLast()
      switch op {
      case .Operand(let operand):
        return (operand, remainingOps)
      case .UnaryOperation(_, let operation):
        let operandEvaluation = evaluate(remainingOps)
        if let operand = operandEvaluation.result {
          return (operation(operand), operandEvaluation.remainingOps)
        }
      case .BinaryOperation(_, let operation):
        let op1Evaluation = evaluate(remainingOps)
        if let operand1 = op1Evaluation.result {
          let op2Evaluation = evaluate(op1Evaluation.remainingOps)
          if let operand2 = op2Evaluation.result {
            return (operation(operand1, operand2), op2Evaluation.remainingOps)
          }
        }
      }
    }
    return (nil, ops)
  }
  
  func isKnownOp(symbol: String) -> Bool {
    return knownOps[symbol] != nil
  }
  
  func evaluate() -> Double? {
    let (result, remainder) = evaluate(opStack)
    return result
  }
  
  func pushOperand(operand: Double) {
    opStack.append(Op.Operand(operand))
  }
  
  func performOperation(symbol: String ) {
    if let operation = knownOps[symbol] {
      opStack.append(operation)
    }
  }
}



// Test: 3, 4, +
var calcBrain = CalculatorBrain()
calcBrain.pushOperand(3)
calcBrain.pushOperand(4)
calcBrain.performOperation("+")
calcBrain.evaluate()!


func stringOperandToDouble(operand: String) -> Double {
  return NSNumberFormatter().numberFromString(operand)!.doubleValue
}

// The RPN Expression
calcBrain = CalculatorBrain()
//let expression = "10 4 3 + 2 * -"
let expression = "10 4 3 + 2 × -"
var ops = expression.componentsSeparatedByString(" ")
for op in ops {
  switch op {
  case "×", "÷", "+", "-", "√":
    calcBrain.performOperation(op)
  default:
    calcBrain.pushOperand(stringOperandToDouble(op))
  }
}
calcBrain.evaluate()!






