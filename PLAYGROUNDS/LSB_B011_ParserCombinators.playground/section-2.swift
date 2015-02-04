import UIKit

/*
//  Parser Combinators
//
//  Based on:
//  http://www.objc.io/books/ (Chapter 12, Parser Combinators)
//    (Functional Programming in Swift, by Chris Eidhof, Florian Kugler, and Wouter Swierstra)
/===================================*/


/*---------------------------------------------------------/
//  Extensions
/---------------------------------------------------------*/
extension String {
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
    return self.isEmpty ? nil : (self[self.startIndex], self.tail)
  }
}


/*---------------------------------------------------------/
//  Helpers
/---------------------------------------------------------*/
func none<A>() -> SequenceOf<A> {
  return SequenceOf(GeneratorOf { nil } )
}

func one<A>(x: A) -> SequenceOf<A> {
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
struct Parser<Token, Result> {
  let p: Slice<Token> -> SequenceOf<(Result, Slice<Token>)>
}

//  But, what's a slice?
//  http://natecook.com/blog/2014/09/slicing-for-speed/


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

func testParser<A>(parser: Parser<Character, A>, input: String) -> String {
    var result: [String] = []
    for (x, s) in parser.p(input.slice) {
      result += ["Success, found \(x), remainder: \(Array(s))"]
    }
    return result.isEmpty ? "Parsing failed." : join("\n", result)
}

testParser(parseA(), "abcd")
testParser(parseA(), "test")


/*---------------------------------------------------------------------/
//  Generalize to any character
/---------------------------------------------------------------------*/
func parseCharacter(character: Character) -> Parser<Character, Character> {
    return Parser { x in
      if let (head, tail) = x.decompose {
        if head == character {
          return one((character, tail))
        }
      }
      return none()
    }
}

testParser(parseCharacter("t"), "test")


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
//  Make generic over any kind of token
/---------------------------------------------------------------------*/
func satisfy<Token>(condition: Token -> Bool) -> Parser<Token, Token> {
  return Parser { x in
    if let (head, tail) = x.decompose {
      if condition(head) {
        return one((head, tail))
      }
    }
    return none()
  }
}


func token<Token: Equatable>(t: Token) -> Parser<Token, Token> {
  return satisfy { $0 == t }
}


/*---------------------------------------------------------------------/
//  Choice operator
/---------------------------------------------------------------------*/
infix operator <|> { associativity right precedence 130 }
func <|> <Token, A>(l: Parser<Token, A>,
                    r: Parser<Token, A>) -> Parser<Token, A> {
    return Parser { input in
      return l.p(input) + r.p(input)
    }
}


testParser(token("a") <|> token("b"), "bcd")
testParser(token("b") <|> token("a"), "bcd")
testParser(token("a") <|> token("x"), "bcd")


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


let parserXY: Parser<Character, (Character, Character)> = sequence(token("x"), token("y"))
testParser(parserXY, "xyz")


/*---------------------------------------------------------------------/
//  Sequence the Parsers: The refined way
/---------------------------------------------------------------------*/










