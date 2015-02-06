//
//  TokenParser.swift
//  ExpressionParser
//
//  Created by Kyle Oba on 2/6/15.
//  Copyright (c) 2015 Pas de Chocolat. All rights reserved.
//

import Foundation


/*---------------------------------------------------------------------/
//  Expressions - Can be numbers, references, binary expressions with,
//                an operator, or function calls.
//
//  This recursive Enum is the Abstract Syntax Tree for our
//  spreadsheet expressions.
//
//  ExpressionLike is a work around because Swift doesn't currently
//  allow recursive Enums.
/---------------------------------------------------------------------*/
public protocol ExpressionLike {
  func toExpression() -> Expression
}

public enum Expression {
  case Number(Int)
  case Reference(String, Int)
  case BinaryExpression(String, ExpressionLike, ExpressionLike)
  case FunctionCall(String, ExpressionLike)
}

extension Expression: ExpressionLike {
  public func toExpression() -> Expression {
    return self
  }
}


// Computes expression values from a stream of tokens
typealias ExpressionParser = Parser<Token, Expression>


/*---------------------------------------------------------------------/
//  optionalTransform - Generates a parser that satisfies a predicate
//                      or returns nil
/---------------------------------------------------------------------*/
func optionalTransform<A, T>(f: T -> A?) -> Parser<T, A> {
  return { f($0)! } </> satisfy { f($0) != nil }
}


/*---------------------------------------------------------------------/
//  pNumber - Number parser
/---------------------------------------------------------------------*/
let pNumber: ExpressionParser = optionalTransform {
  switch $0 {
  case .Number(let number):
    return Expression.Number(number)
  default:
    return nil
  }
}


/*---------------------------------------------------------------------/
//  pReference - Cell reference parser
/---------------------------------------------------------------------*/
let pReference: ExpressionParser = optionalTransform {
  switch $0 {
  case .Reference(let column, let row):
    return Expression.Reference(column, row)
  default:
    return nil
  }
}


let pNumberOrReference = pNumber <|> pReference


extension Expression : Printable {
  public var description: String {
    switch (self) {
    case Number(let x):
      return "\(x)"
    case let .Reference(col, row):
      return "\(col)\(row)"
    case let Expression.BinaryExpression(binaryOp, expLike1, expLike2):
      let operand1 = expLike1.toExpression().description
      let operand2 = expLike2.toExpression().description
      return "\(operand1) \(binaryOp) \(operand2)"
    case let .FunctionCall(fn, expLike):
      let expr = expLike.toExpression().description
      return "\(fn)(\(expr))"
    }
  }
}


func readExpression(expr: Expression) -> String {
  var header = ""
  switch (expr) {
  case .Number:
    header = "Number"
  case .Reference:
    header = "Reference"
  case .BinaryExpression:
    header = "Binary Expression"
  case .FunctionCall:
    header = "Function"
  }
  return "\(header): \(expr.description)"
}


/*---------------------------------------------------------------------/
//  pFunctionName - Function name parser
/---------------------------------------------------------------------*/
let pFunctionName: Parser<Token, String> = optionalTransform {
  switch $0 {
  case .FunctionName(let name):
    return name
  default:
    return nil
  }
}


/*---------------------------------------------------------------------/
//  pList - List parser
/---------------------------------------------------------------------*/
func makeList(l: Expression, r: Expression) -> Expression {
  return Expression.BinaryExpression(":", l, r)
}

func op(opString: String) -> Parser<Token, String> {
  return const(opString) </> token(Token.Operator(opString))
}

let pList: ExpressionParser = curry(makeList) </> pReference <* op(":") <*> pReference


/*---------------------------------------------------------------------/
//  parenthesized - Generates Parser for parenthesized expression
/---------------------------------------------------------------------*/
func parenthesized<A>(p: Parser<Token, A>) -> Parser<Token, A> {
  return token(Token.Punctuation("(")) *> p <* token(Token.Punctuation(")"))
}


/*---------------------------------------------------------------------/
//  pFunctionCall - Put it all together to create function call Parser
/---------------------------------------------------------------------*/
func makeFunctionCall(name: String, arg: Expression) -> Expression {
  return Expression.FunctionCall(name, arg)
}

let pFunctionCall = curry(makeFunctionCall) </> pFunctionName <*> parenthesized(pList)


/*---------------------------------------------------------------------/
//  Parsers for formula primitives - start with the smallest
/---------------------------------------------------------------------*/
func expression() -> ExpressionParser {
  return pSum
}

let pParenthesizedExpression = parenthesized(lazy(expression()))
let pPrimitive = pNumberOrReference <|> pFunctionCall <|> pParenthesizedExpression


/*---------------------------------------------------------------------/
//  pMultiplier - Multiplication or Division are equal
/---------------------------------------------------------------------*/
let pMultiplier = curry { ($0, $1) } </> (op("*") <|> op("/")) <*> pPrimitive


/*---------------------------------------------------------------------/
//  combineOperands - Build an expression tree from primitive and
//                    multipier tuples
/---------------------------------------------------------------------*/
func combineOperands(first: Expression, rest: [(String, Expression)]) -> Expression {
  
  return rest.reduce(first, combine: { result, pair in
    let (op, exp) = pair
    return Expression.BinaryExpression(op, result, exp)
  })
}


/*---------------------------------------------------------------------/
//  pProduct - Combine tuples from pMultiplier (also handles division)
/---------------------------------------------------------------------*/
let pProduct = curry(combineOperands) </> pPrimitive <*> zeroOrMore(pMultiplier)


/*---------------------------------------------------------------------/
//  pSum - Do the same for addition and subtraction
/---------------------------------------------------------------------*/
let pSummand = curry { ($0, $1) } </> (op("-") <|> op("+")) <*> pProduct
let pSum = curry(combineOperands) </> pProduct <*> zeroOrMore(pSummand)


/*---------------------------------------------------------------------/
//  parseExpression - Tokenizer combined with Parsers
/---------------------------------------------------------------------*/
func parseExpressionWithoutFlatmap(input: String) -> Expression? {
  if let tokens = parse(tokenize(), input) {
    return parse(expression(), tokens)
  }
  return nil
}

// Can also use `flatMap` for this
func flatMap<A, B>(x: A?, f: A -> B?) -> B? {
  if let value = x {
    return f(value)
  }
  return nil
}


public func parseExpression(input: String) -> Expression? {
  return flatMap(parse(tokenize(), input)) {
    parse(expression(), $0)
  }
}


