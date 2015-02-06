//
//  Token.swift
//  ExpressionParser
//
//  Created by Kyle Oba on 2/5/15.
//  Copyright (c) 2015 Pas de Chocolat. All rights reserved.
//

import Foundation

/*---------------------------------------------------------------------/
//  Tokens
/---------------------------------------------------------------------*/
public enum Token : Equatable {
  case Number(Int)
  case Operator(String)
  case Reference(String, Int)
  case Punctuation(String)
  case FunctionName(String)
}


public func ==(lhs: Token, rhs: Token) -> Bool {
  switch (lhs,rhs) {
  case (.Number(let x), .Number(let y)):
    return x == y
  case (.Operator(let x), .Operator(let y)):
    return x == y
  case (.Reference(let row, let column), .Reference(let row1, let column1)):
    return row == row1 && column == column1
  case (.Punctuation(let x), .Punctuation(let y)):
    return x == y
  case (.FunctionName (let x), .FunctionName(let y)):
    return x == y
  default:
    return false
  }
}


extension Token : Printable {
  public var description: String {
    switch (self) {
    case Number(let x):
      return "\(x)"
    case .Operator(let o):
      return o
    case .Reference(let row, let column):
      return "\(row)\(column)"
    case .Punctuation(let x):
      return x
    case .FunctionName(let x):
      return x
    }
  }
}


/*---------------------------------------------------------/
//  parse - Debug helper
/---------------------------------------------------------*/
public func parse<A>(parser: Parser<Character, A>, input: String) -> A? {
  for (result, _) in (parser <* eof()).p(input.slice) {
    return result
  }
  return nil
}

public func parse<A, B>(parser: Parser<A, B>, input: [A]) -> B? {
  for (result, _) in (parser <* eof()).p(input[0..<input.count]) {
    return result
  }
  return nil
}


/*---------------------------------------------------------------------/
//  const - Takes an arg and constructs a function that always
//          (constantly) returns the arg, diregarding the arguments
//          sent to the contructed function.
/---------------------------------------------------------------------*/
public func const<A, B>(x: A) -> (y: B) -> A {
  return { _ in x }
}


/*---------------------------------------------------------/
//  decompose - Required Array extension
/---------------------------------------------------------*/
extension Array {
  var decompose: (head: T, tail: [T])? {
    return (count > 0) ? (self[0], Array(self[1..<count])) : nil
  }
}


/*---------------------------------------------------------/
//  tokens - Constructs a parser that consumes all elements
//           passed into constructor via array.
/---------------------------------------------------------*/
func tokens<A: Equatable>(input: [A]) -> Parser<A, [A]> {
  if let (head, tail) = input.decompose {
    return prepend </> token(head) <*> tokens(tail)
  } else {
    return pure([])
  }
}


/*---------------------------------------------------------/
//  string - Constructs a parser that parses a string
//           given to the constructor.
/---------------------------------------------------------*/
func string(string: String) -> Parser<Character, String> {
  return const(string) </> tokens(string.characters)
}


/*---------------------------------------------------------/
//  oneOf - Allows combination of parsers in a mutually
//          exclusive manner
/---------------------------------------------------------*/
func oneOf<Token, A>(parsers: [Parser<Token, A>]) -> Parser<Token, A> {
  return parsers.reduce(fail(), combine: <|>)
}


/*---------------------------------------------------------/
//  naturalNumber - Parses natural numbers
/---------------------------------------------------------*/
let pDigit = oneOf(Array(0...9).map { const($0) </> string("\($0)") })

func toNaturalNumber(digits: [Int]) -> Int {
  return digits.reduce(0) { $0 * 10 + $1 }
}

let naturalNumber = toNaturalNumber </> oneOrMore(pDigit)


/*---------------------------------------------------------/
//  tNumber - Parses natural number and wraps in a Token
/---------------------------------------------------------*/
let tNumber = { Token.Number($0) } </> naturalNumber


/*---------------------------------------------------------/
//  tOperator - Parses an operator and wraps in a Token
/---------------------------------------------------------*/
let operatorParsers = ["*", "/", "+", "-", ":"].map { string($0) }
let tOperator = { Token.Operator($0) } </> oneOf (operatorParsers)


/*---------------------------------------------------------/
//  capital - For references, parse a single capital letter
/---------------------------------------------------------*/
let capitalSet = NSCharacterSet.uppercaseLetterCharacterSet()
let capital = characterFromSet(capitalSet)


/*---------------------------------------------------------/
//  tReference - Capital letter followed by natural number
/---------------------------------------------------------*/
let tReference = curry { Token.Reference(String($0), $1) } </> capital <*> naturalNumber


/*---------------------------------------------------------/
//  tPunctuation - Wraps open and close parens in a token
/---------------------------------------------------------*/
let punctuationParsers = ["(", ")"].map { string($0) }
let tPunctuation = { Token.Punctuation($0) } </> oneOf(punctuationParsers)


/*---------------------------------------------------------/
//  tName - Function names are one or more capitals
/---------------------------------------------------------*/
let tName = { Token.FunctionName(String($0)) } </> oneOrMore(capital)


/*---------------------------------------------------------/
//  ignoreLeadingWhitespace - Ignore whitespace between tokens
/---------------------------------------------------------*/
let whitespaceSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
let whitespace = characterFromSet(whitespaceSet)

func ignoreLeadingWhitespace<A>(p: Parser<Character, A>) -> Parser<Character, A> {
  return zeroOrMore(whitespace) *> p
}


/*---------------------------------------------------------/
//  tokenize - Putting it all together
/---------------------------------------------------------*/
public func tokenize() -> Parser<Character, [Token]> {
  let tokenParsers = [tNumber, tOperator, tReference, tPunctuation, tName]
  return zeroOrMore(ignoreLeadingWhitespace(oneOf(tokenParsers)))
}


/*---------------------------------------------------------/
//  Print tokens
/---------------------------------------------------------*/
public func readToken(t: Token) -> String {
  switch t {
  case .Number:
    return "Number: \(t.description)"
  case .Operator:
    return "Operator: \(t.description)"
  case .Reference:
    return "Reference: \(t.description)"
  case .Punctuation:
    return "Punctuation: \(t.description)"
  case .FunctionName:
    return "Function Name: \(t.description)"
  }
}

public func readTokens(tokens: [Token]) -> String {
  return tokens.reduce("") { $0 + "\n\(readToken($1))" }
}