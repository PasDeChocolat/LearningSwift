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



/*------------------------------------/
//  Stanford: Test 3, 4, +
/------------------------------------*/
var calcBrain = CalculatorBrain()
calcBrain.pushOperand(3)
calcBrain.pushOperand(4)
calcBrain.performOperation("+")
calcBrain.evaluate()!


func stringOperandToDouble(operand: String) -> Double {
  return NSNumberFormatter().numberFromString(operand)!.doubleValue
}


/*------------------------------------/
//  Stanford: The RPN Expression
/------------------------------------*/
calcBrain = CalculatorBrain()
let expression = "10 4 3 + 2 × -"
var ops = expression.componentsSeparatedByString(" ")
for op in ops {
  if calcBrain.isKnownOp(op) {
    calcBrain.performOperation(op)
  } else {
    calcBrain.pushOperand(stringOperandToDouble(op))
  }
}
calcBrain.evaluate()!


/*------------------------------------/
//  The Haskell Way
/------------------------------------*/
func words(sentence: String) -> [String] {
  return sentence.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
}
words(expression)

/*------------------------------------/
//  Head : Tail
/------------------------------------*/
extension Array {
  var decompose: (head: T, tail: [T])? {
    return (count > 0) ? (self[0], Array(self[1..<count])) : nil
  }
  
  var ddecompose: (head: T, htail: T, ttail: [T])? {
    return (count > 1) ? (self[0], self[1], Array(self[2..<count])) : nil
  }
}

var (head, htail, ttail) = [1, 2].ddecompose!
head
htail
ttail
ttail.first

(head, htail, ttail) = [1, 2, 3, 4].ddecompose!
head
htail
ttail


/*------------------------------------------------------------------/
//  These wouldn't be necessary if we could do more sophisticated
//  pattern matching, as in Haskell.
/------------------------------------------------------------------*/
func performBinary(all: [Double], op: (Double, Double) -> Double) -> [Double] {
  if var (x, y, ys) = all.ddecompose {
    return [op(x, y)] + ys
  }
  assertionFailure("Could not perform binary op on: \(all)")
}

func performUnary(all: [Double], op: Double -> Double) -> [Double] {
  if var (x, xs) = all.decompose {
    return [op(x)] + xs
  }
  assertionFailure("Could not perform unary op on: \(all)")
}


/*------------------------------------------------------------------/
//  Calculate expression via a left fold, placing either operands
//  (converted to double), or operations (applied to operands from
//  the accumulator), onto the accumulator.
//
//  The resulting accumulator value is the answer.
/------------------------------------------------------------------*/
func foldingFunction(all: [Double], op: String) -> [Double] {
  switch op {
  case "×":
    return performBinary(all, *)
  case "+":
    return performBinary(all, +)
  case "-":
    return performBinary(all) { $1 - $0 }
  case "÷":
    return performBinary(all) { $1 / $0 }
    case "√":
      return performUnary(all, sqrt)
  default:
    return [stringOperandToDouble(op)] + all
  }
}

func solveRPN(expression: String) -> Double {
  let words = expression.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
  return words.reduce([], combine: foldingFunction).first!
}

solveRPN(expression)


/*----------------------------------------/
//  Attempt at a More Haskelly Solution
//
//  My apologies to people who actually
//  know how to write Haskell gud.
/----------------------------------------*/

/*------------------------------------/
//  Head: HTail: TTail
/------------------------------------*/
extension Array {
  var ddecomp: (head: T?, htail: T?, ttail: [T]) {
    switch self.count {
    case 0: return (nil, nil, self)
    case 1: return (self[0], nil,     [])
    case 2: return (self[0], self[1], [])
    case _: return (self[0], self[1], Array(self[2..<count]))
    }
  }
}


func foldingFunction2(all: [Double], op: String) -> [Double] {
  switch (all.ddecomp, op) {
  case (let (x, y, ys), "×"):
    return [x! * y!] + ys
  case (let (x, y, ys), "+"):
    return [x! + y!] + ys
  case (let (x, y, ys), "-"):
    return [y! - x!] + ys
  case (let (x, y, ys), "÷"):
    return [y! / x!] + ys
  case (let (x, y, ys), "√"):
    return [sqrt(x!)] + (y != nil ? [y!] + ys : ys)
  default:
    return [stringOperandToDouble(op)] + all
  }
}


words("1 2 3 4").reduce([], combine: foldingFunction2)
words(expression).reduce([], combine: foldingFunction2).first!
words("4 √ 3 × 4 + 1 - √").reduce([], combine: foldingFunction2).first!


