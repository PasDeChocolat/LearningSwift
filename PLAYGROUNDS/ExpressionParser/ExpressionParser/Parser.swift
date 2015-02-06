//
//  Parser.swift
//  ExpressionParser
//
//  Created by Kyle Oba on 2/5/15.
//  Copyright (c) 2015 Pas de Chocolat. All rights reserved.
//

import Foundation

/*---------------------------------------------------------/
//  Extensions
/---------------------------------------------------------*/
public extension String {
  var characters: [Character] {
    var result: [Character] = []
    for c in self {
      result += [c]
    }
    return result
  }
  var slice: Slice<Character> {
    let res = self.characters
    return res[0..<res.count]
  }
}

extension Slice {
  var head: T? {
    return self.isEmpty ? nil : self[0]
  }
  
  var tail: Slice<T> {
    if (self.isEmpty) { return self }
    return self[(self.startIndex+1)..<self.endIndex]
  }
  
  var decompose: (head: T, tail: Slice<T>)? {
    return self.isEmpty ? nil : (self.head!, self.tail)
  }
}


/*---------------------------------------------------------/
//  Helpers
/---------------------------------------------------------*/
public func none<A>() -> SequenceOf<A> {
  return SequenceOf(GeneratorOf { nil } )
}

public func one<A>(x: A) -> SequenceOf<A> {
  return SequenceOf(GeneratorOfOne(x))
}


/*---------------------------------------------------------------------/
//  Parser Type
//  We use a struct because typealiases don't support generic types.
//
//  “We define a parser as a function that takes a slice of tokens,
//   processes some of these tokens, and returns a tuple of the result
//   and the remainder of the tokens.”
//  - Excerpt From: Chris Eidhof. “Functional Programming in Swift.” iBooks.
/---------------------------------------------------------------------*/
public struct Parser<Token, Result> {
  public init(_ p: Slice<Token> -> SequenceOf<(Result, Slice<Token>)>) {
    self.p = p
  }
  
  public let p: Slice<Token> -> SequenceOf<(Result, Slice<Token>)>
}


/*---------------------------------------------------------------------/
//  Simple example: Just parse single character "a"
/---------------------------------------------------------------------*/
func parseA() -> Parser<Character, Character> {
  let a: Character = "a"
  return Parser { x in
    if let (head, tail) = x.decompose {
      if head == a {
        return one((a, tail))
      }
    }
    return none()
  }
}


// Let's automate Parser testing
public func testParser<A>(parser: Parser<Character, A>, input: String) -> String {
  var result: [String] = []
  for (x, s) in parser.p(input.slice) {
    result += ["Success, found \(x), remainder: \(Array(s))"]
  }
  return result.isEmpty ? "Parsing failed." : join("\n", result)
}


/*---------------------------------------------------------------------/
//  Make generic over any kind of token
/---------------------------------------------------------------------*/
public func satisfy<Token>(condition: Token -> Bool) -> Parser<Token, Token> {
  return Parser { x in
    if let (head, tail) = x.decompose {
      if condition(head) {
        return one((head, tail))
      }
    }
    return none()
  }
}


// But we can make it shorter
public func token<Token: Equatable>(t: Token) -> Parser<Token, Token> {
  return satisfy { $0 == t }
}


/*---------------------------------------------------------------------/
//  Allow adding sequences
/---------------------------------------------------------------------*/
struct JoinedGenerator<A>: GeneratorType {
  typealias Element = A
  
  var generator: GeneratorOf<GeneratorOf<A>>
  var current: GeneratorOf<A>?
  
  init(_ g: GeneratorOf<GeneratorOf<A>>) {
    generator = g
    current = generator.next()
  }
  
  mutating func next() -> A? {
    if var c = current {
      if let x = c.next() {
        return x
      } else {
        current = generator.next()
        return next()
      }
    }
    return nil
  }
}


func map<A, B>(var g: GeneratorOf<A>, f: A -> B) -> GeneratorOf<B> {
  return GeneratorOf { map(g.next(), f) }
}


func join<A>(s: SequenceOf<SequenceOf<A>>) -> SequenceOf<A> {
  return SequenceOf {
    JoinedGenerator(map(s.generate()) {
      $0.generate()
      })
  }
}


func +<A>(l: SequenceOf<A>, r: SequenceOf<A>) -> SequenceOf<A> {
  return join(SequenceOf([l, r]))
}


/*---------------------------------------------------------------------/
//  Choice operator - Combining multiple parsers
/---------------------------------------------------------------------*/
infix operator <|> { associativity right precedence 130 }
public func <|> <Token, A>(l: Parser<Token, A>,
  r: Parser<Token, A>) -> Parser<Token, A> {
    return Parser { input in
      return l.p(input) + r.p(input)
    }
}


/*---------------------------------------------------------------------/
//  Sequence the Parsers: The hard way
/---------------------------------------------------------------------*/
func map<A, B>(var s: SequenceOf<A>, f: A -> B) -> SequenceOf<B> {
  return SequenceOf {  map(s.generate(), f) }
}


func flatMap<A, B>(ls: SequenceOf<A>, f: A -> SequenceOf<B>)
  -> SequenceOf<B> {
    
    return join(map(ls, f))
}


// This is our first attempt. It's a little confusing, due to the nesting.
func sequence<Token, A, B>(l: Parser<Token, A>, r: Parser<Token, B>)
  -> Parser<Token, (A, B)> {
    
    return Parser { input in
      let leftResults = l.p(input)
      return flatMap(leftResults) { a, leftRest in
        let rightResults = r.p(leftRest)
        return map(rightResults, { b, rightRest in
          ((a, b), rightRest)
        })
      }
    }
}


/*---------------------------------------------------------------------/
//  Sequence the Parsers: The refined way
/---------------------------------------------------------------------*/
// The Combinator
func combinator<Token, A, B>(l: Parser<Token, A -> B>,
  r: Parser<Token, A>)
  -> Parser<Token, B> {
    
    return Parser { input in
      let leftResults = l.p(input)
      return flatMap(leftResults) { f, leftRemainder in
        let rightResults = r.p(leftRemainder)
        return map(rightResults) { x, rightRemainder in
          (f(x), rightRemainder)
        }
      }
    }
}


/*---------------------------------------------------------------------/
//  Pure - Returns a value in a default context
//  pure :: a -> f a
/---------------------------------------------------------------------*/
public func pure<Token, A>(value: A) -> Parser<Token, A> {
  return Parser { one((value, $0)) }
}


/*---------------------------------------------------------------------/
//  Fail - Returns an unsuccessful parser
/---------------------------------------------------------------------*/
public func fail<Token, Result>() -> Parser<Token, Result> {
  return Parser { _ in none() }
}


/*---------------------------------------------------------------------/
//  <*>
//
//  “for Maybe, <*> extracts the function from the left value if it’s
//   a Just and maps it over the right value. If any of the parameters
//   is Nothing, Nothing is the result.”
//   - Excerpt From: Miran Lipovaca. “Learn You a Haskell for Great Good!.” iBooks.
/---------------------------------------------------------------------*/
infix operator <*> { associativity left precedence 150 }
public func <*><Token, A, B>(l: Parser<Token, A -> B>,
                             r: Parser<Token, A>)
                             -> Parser<Token, B> {
    return combinator(l, r)
}


/*---------------------------------------------------------------------/
//  Combine several existing strings
/---------------------------------------------------------------------*/
func string(characters: [Character]) -> String {
  var s = ""
  s.extend(characters)
  return s
}


func combine(a: Character)(b: Character)(c: Character) -> String {
  return string([a, b, c])
}


/*---------------------------------------------------------------------/
//  Any character from a set
/---------------------------------------------------------------------*/
func member(set: NSCharacterSet, character: Character) -> Bool {
  let unichar = (String(character) as NSString).characterAtIndex(0)
  return set.characterIsMember(unichar)
}


public func characterFromSet(set: NSCharacterSet) -> Parser<Character, Character> {
  return satisfy { return member(set, $0) }
}


let decimals = NSCharacterSet.decimalDigitCharacterSet()
let decimalDigit = characterFromSet(decimals)


/*---------------------------------------------------------------------/
//  Zero or More
/---------------------------------------------------------------------*/
public func prepend<A>(l: A) -> [A] -> [A] {
  return { (x: [A]) in [l] + x }
}


// So we use an autoclosure instead
public func lazy<Token, A>(f: @autoclosure () -> Parser<Token, A>) -> Parser<Token, A> {
  return Parser { x in f().p(x) }
}


public func zeroOrMore<Token, A>(p: Parser<Token, A>) -> Parser<Token, [A]> {
  return (pure(prepend) <*> p <*> lazy(zeroOrMore(p))) <|> pure([])
}


/*---------------------------------------------------------------------/
//  One or More
/---------------------------------------------------------------------*/
public func oneOrMore<Token, A>(p: Parser<Token, A>) -> Parser<Token, [A]> {
  return pure(prepend) <*> p <*> zeroOrMore(p)
}


/*---------------------------------------------------------------------/
//  </> ==> pure(l) <*> r
//
//  a.k.a Haskell's <$>
/---------------------------------------------------------------------*/
infix operator </> { precedence 170 }
public func </> <Token, A, B>(l: A -> B,
  r: Parser<Token, A>) -> Parser<Token, B> {
    
    return pure(l) <*> r
}


/*---------------------------------------------------------------------/
//  Add two integers with "+"
//
//  We'll see an easier way to "skip" the operator below (<*)
/---------------------------------------------------------------------*/
let plus: Character = "+"
func add(x: Int)(_: Character)(y: Int) -> Int {
  return x + y
}

let number = { characters in string(characters).toInt()! } </> oneOrMore(decimalDigit)


/*---------------------------------------------------------------------/
//  <*  Throw away the right-hand result
/---------------------------------------------------------------------*/
infix operator <*  { associativity left precedence 150 }
public func <* <Token, A, B>(p: Parser<Token, A>,
                             q: Parser<Token, B>)
                             -> Parser<Token, A> {
    
    return {x in {_ in x} } </> p <*> q
}


/*---------------------------------------------------------------------/
//  *>  Throw away the left-hand result
/---------------------------------------------------------------------*/
infix operator  *> { associativity left precedence 150 }
public func *> <Token, A, B>(p: Parser<Token, A>,
  q: Parser<Token, B>) -> Parser<Token, B> {
    
    return {_ in {y in y} } </> p <*> q
}


public func curry<A, B, C>(f: (A, B) -> C) -> A -> B -> C {
  return { x in { y in f(x, y) } }
}


/*---------------------------------------------------------------------/
//  </  Consumes, but doesn't use its right operand
/---------------------------------------------------------------------*/
infix operator </  { precedence 170 }
func </ <Token, A, B>(l: A, r: Parser<Token, B>) -> Parser<Token, A> {
  return pure(l) <* r
}


func optionallyFollowed<A>(l: Parser<Character, A>,
  r: Parser<Character, A -> A>)
  -> Parser<Character, A> {
    
    let apply: A -> (A -> A) -> A = { x in { f in f(x) } }
    return apply </> l <*> (r <|> pure { $0 })
}


func flip<A, B, C>(f: (B, A) -> C) -> (A, B) -> C {
  return { (x, y) in f(y, x) }
}


public typealias Calculator = Parser<Character, Int>
typealias Op = (Character, (Int, Int) -> Int)
let operatorTable: [Op] = [("*", *), ("/", /), ("+", +), ("-", -)]


func op(character: Character,
  evaluate: (Int, Int) -> Int,
  operand: Calculator) -> Calculator {
    
    let withOperator = curry(flip(evaluate)) </ token(character) <*> operand
    return optionallyFollowed(operand, withOperator)
}


public func eof<A>() -> Parser<A, ()> {
  return Parser { stream in
    if (stream.isEmpty) {
      return one(((), stream))
    }
    return none()
  }
}
