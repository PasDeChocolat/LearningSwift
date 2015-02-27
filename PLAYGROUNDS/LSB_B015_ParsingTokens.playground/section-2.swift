// Since @autoclosure was discontinued in Swift 1.2, lazy won't work.
// Attempting to use Box here will result in an infinite loop.
// Requires fix in ExpressionParser / Parser.swift


//import UIKit
//import ExpressionParser
//
///*
////  Parsing Tokens
////
////  Based on:
////  http://www.objc.io/books/ (Chapter 13, Case Study: Build a Spreadsheet Application)
////    (Functional Programming in Swift, by Chris Eidhof, Florian Kugler, and Wouter Swierstra)
///===================================*/
//
//
//// This is just a test of the import from the "ExpressionParser" module.
//let myParser: Parser<Character, Character> = Parser { _ in
//  return none()
//}
//
//// Here goes nothing...
//
//
///*=====================================================================/
////  Parsing Tokens - Be sure to read "Tokenzation" first.
///=====================================================================*/
//
//
///*---------------------------------------------------------------------/
////  Expressions - Can be numbers, references, binary expressions with,
////                an operator, or function calls.
////
////  This recursive Enum is the Abstract Syntax Tree for our
////  spreadsheet expressions.
////
////  ExpressionLike is a work around because Swift doesn't currently
////  allow recursive Enums.
///---------------------------------------------------------------------*/
//protocol ExpressionLike {
//  func toExpression() -> Expression
//}
//
//enum Expression {
//  case Number(Int)
//  case Reference(String, Int)
//  case BinaryExpression(String, ExpressionLike, ExpressionLike)
//  case FunctionCall(String, ExpressionLike)
//}
//
//extension Expression: ExpressionLike {
//  func toExpression() -> Expression {
//    return self
//  }
//}
//
//
//// Computes expression values from a stream of tokens
//typealias ExpressionParser = Parser<Token, Expression>
//
//
///*---------------------------------------------------------------------/
////  optionalTransform - Generates a parser that satisfies a predicate
////                      or returns nil
///---------------------------------------------------------------------*/
//func optionalTransform<A, T>(f: T -> A?) -> Parser<T, A> {
//  return { f($0)! } </> satisfy { f($0) != nil }
//}
//
//
///*---------------------------------------------------------------------/
////  pNumber - Number parser
///---------------------------------------------------------------------*/
//let pNumber: ExpressionParser = optionalTransform {
//  switch $0 {
//  case .Number(let number):
//    return Expression.Number(number)
//  default:
//    return nil
//  }
//}
//
//
///*---------------------------------------------------------------------/
////  pReference - Cell reference parser
///---------------------------------------------------------------------*/
//let pReference: ExpressionParser = optionalTransform {
//  switch $0 {
//  case .Reference(let column, let row):
//    return Expression.Reference(column, row)
//  default:
//    return nil
//  }
//}
//
//
//let pNumberOrReference = pNumber <|> pReference
//
//let result42 = parse(pNumberOrReference, parse(tokenize(), "42")!)
//
//
//extension Expression : Printable {
//  var description: String {
//    switch (self) {
//    case Number(let x):
//      return "\(x)"
//    case let .Reference(col, row):
//      return "\(col)\(row)"
//    case let Expression.BinaryExpression(binaryOp, expLike1, expLike2):
//      let operand1 = expLike1.toExpression().description
//      let operand2 = expLike2.toExpression().description
//      return "\(operand1) \(binaryOp) \(operand2)"
//    case let .FunctionCall(fn, expLike):
//      let expr = expLike.toExpression().description
//      return "\(fn)(\(expr))"
//    }
//  }
//}
//
//
//func readExpression(expr: Expression) -> String {
//  var header = ""
//  switch (expr) {
//  case .Number:
//    header = "Number"
//  case .Reference:
//    header = "Reference"
//  case .BinaryExpression:
//    header = "Binary Expression"
//  case .FunctionCall:
//    header = "Function"
//  }
//  return "\(header): \(expr.description)"
//}
//
//result42!.description
//readExpression(result42!)
//
//let resultA5 = parse(pNumberOrReference, parse(tokenize(), "A5")!)
//resultA5!.description
//readExpression(resultA5!)
//
//
///*---------------------------------------------------------------------/
////  pFunctionName - Function name parser
///---------------------------------------------------------------------*/
//let pFunctionName: Parser<Token, String> = optionalTransform {
//  switch $0 {
//  case .FunctionName(let name):
//    return name
//  default:
//    return nil
//  }
//}
//
//
///*---------------------------------------------------------------------/
////  pList - List parser
///---------------------------------------------------------------------*/
//func makeList(l: Expression, r: Expression) -> Expression {
//  return Expression.BinaryExpression(":", l, r)
//}
//
//func op(opString: String) -> Parser<Token, String> {
//  return const(opString) </> token(Token.Operator(opString))
//}
//
//let pList: ExpressionParser = curry(makeList) </> pReference <* op(":") <*> pReference
//
//
///*---------------------------------------------------------------------/
////  parenthesized - Generates Parser for parenthesized expression
///---------------------------------------------------------------------*/
//func parenthesized<A>(p: Parser<Token, A>) -> Parser<Token, A> {
//  return token(Token.Punctuation("(")) *> p <* token(Token.Punctuation(")"))
//}
//
//
///*---------------------------------------------------------------------/
////  pFunctionCall - Put it all together to create function call Parser
///---------------------------------------------------------------------*/
//func makeFunctionCall(name: String, arg: Expression) -> Expression {
//  return Expression.FunctionCall(name, arg)
//}
//
//let pFunctionCall = curry(makeFunctionCall) </> pFunctionName <*> parenthesized(pList)
//
//
//let fnResult = parse(pFunctionCall, parse(tokenize(), "SUM(A1:A3)")!)
//fnResult!.description
//readExpression(fnResult!)
//
//
//
///*---------------------------------------------------------------------/
////  Parsers for formula primitives - start with the smallest
///---------------------------------------------------------------------*/
//var expression:() -> ExpressionParser = {
////  return pSum // This is what we really want
//  return pList // This is temporary, becase pSum isn't defined yet
//               // This is a limitation of playgrounds
//}
//
//let pParenthesizedExpression = parenthesized(lazy(expression()))
//let pPrimitive = pNumberOrReference <|> pFunctionCall <|> pParenthesizedExpression
//
//
///*---------------------------------------------------------------------/
////  pMultiplier - Multiplication or Division are equal
///---------------------------------------------------------------------*/
//let pMultiplier = curry { ($0, $1) } </> (op("*") <|> op("/")) <*> pPrimitive
//
//
///*---------------------------------------------------------------------/
////  combineOperands - Build an expression tree from primitive and
////                    multipier tuples
///---------------------------------------------------------------------*/
//func combineOperands(first: Expression, rest: [(String, Expression)]) -> Expression {
//    
//    return rest.reduce(first, combine: { result, pair in
//      let (op, exp) = pair
//      return Expression.BinaryExpression(op, result, exp)
//    })
//}
//
//
///*---------------------------------------------------------------------/
////  pProduct - Combine tuples from pMultiplier (also handles division)
///---------------------------------------------------------------------*/
//let pProduct = curry(combineOperands) </> pPrimitive <*> zeroOrMore(pMultiplier)
//
//
///*---------------------------------------------------------------------/
////  pSum - Do the same for addition and subtraction
///---------------------------------------------------------------------*/
//let pSummand = curry { ($0, $1) } </> (op("-") <|> op("+")) <*> pProduct
//let pSum = curry(combineOperands) </> pProduct <*> zeroOrMore(pSummand)
//
//
///*---------------------------------------------------------------------/
////  expression() is redefined by Sum, which can handle all operations
///---------------------------------------------------------------------*/
//expression = { pSum }
//
//
///*---------------------------------------------------------------------/
////  parseExpression - Tokenizer combined with Parsers
///---------------------------------------------------------------------*/
//func parseExpressionWithoutFlatmap(input: String) -> Expression? {
//  if let tokens = parse(tokenize(), input) {
//    return parse(expression(), tokens)
//  }
//  return nil
//}
//
//// Can also use `flatMap` for this
//func flatMap<A, B>(x: A?, f: A -> B?) -> B? {
//  if let value = x {
//    return f(value)
//  }
//  return nil
//}
//
//
//func parseExpression(input: String) -> Expression? {
//  return flatMap(parse(tokenize(), input)) {
//    parse(expression(), $0)
//  }
//}
//
//
///*---------------------------------------------------------------------/
////  Tokenize and parse a sample expression
///---------------------------------------------------------------------*/
//let finalParseResult = parseExpression("1 + 2*3 - MIN(A5:A9)")
//finalParseResult!.description
//
//
//
//
//
