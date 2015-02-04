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
    return self.isEmpty ? nil : (self.head!, self.tail)
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


// Structs get an init() method for free, that will take the properties
// as arguments. So, since Parser only has one property, which stores a
// function, the trailing closure syntax acts as an initializer.
let nullParser1: Parser<Character, Character> = Parser { _ in none() }


// This is equivalent, but long-winded
let nullParser2: Parser<Character, Character> = Parser(p: { _ in none() })


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


// Let's inspect the results of applying a Parser
typealias ParseToken = Character
typealias Remaining = Slice<Character>
typealias ParsePair = (ParseToken, Remaining)
let parserA: Parser<Character, Character> = parseA()
let sequenceParseA: SequenceOf<ParsePair> = parserA.p("abcd".slice)
var generatorParseA: GeneratorOf<ParsePair> = sequenceParseA.generate()
let resultParseA: ParsePair? = generatorParseA.next()
resultParseA!.0
resultParseA!.1


// Let's automate Parser testing
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


// This is better
let charZ: Character = "z"
let parserZ = satisfy { $0 == charZ }
testParser(parserZ, "zed")
testParser(parserZ, "abc")


// But we can make it shorter
func token<Token: Equatable>(t: Token) -> Parser<Token, Token> {
  return satisfy { $0 == t }
}


// Syntactic Sugar for a Parser for the "x" character
testParser(token("x"), "xyz")
testParser(token("a"), "xyz")


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
func <|> <Token, A>(l: Parser<Token, A>,
                    r: Parser<Token, A>) -> Parser<Token, A> {
    return Parser { input in
      return l.p(input) + r.p(input)
    }
}


testParser(token("a") <|> token("b"), "bcd")
testParser(token("b") <|> token("a"), "bcd")
testParser(token("a") <|> token("x"), "bcd")
testParser(token("a") <|> token("b") <|> token("c"), "cde")


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


// And shorter
let a: Character = "a"
let b: Character = "b"
let parserAB = sequence(token(a), token(b))
testParser(parserAB, "abc")


// Let's pick this apart
let sequenceParseAB = parserAB.p("abc".slice)
var generatorParseAB = sequenceParseAB.generate()
let resultParseAB = generatorParseAB.next()
resultParseAB!      // ((a, b), [c])
resultParseAB!.0    //  (a, b)
resultParseAB!.1    //          [c]
resultParseAB!.0.0  //   a
resultParseAB!.0.1  //      b


/*---------------------------------------------------------------------/
//  Sequence more Parsers
/---------------------------------------------------------------------*/
// You could do it brute force, but this doesn't scale.
func sequence3<Token, A, B, C>(p1: Parser<Token, A>,
                               p2: Parser<Token, B>,
                               p3: Parser<Token, C>)
                               -> Parser<Token, (A, B, C)> {
    
    return Parser { input in
      let p1Results = p1.p(input)
      return flatMap(p1Results) { a, p1Rest in
        let p2Results = p2.p(p1Rest)
        return flatMap(p2Results) { b, p2Rest in
          let p3Results = p3.p(p2Rest)
          return map(p3Results, { c, p3Rest in
            ((a, b, c), p3Rest)
          })
        }
      }
    }
}

let c: Character = "c"
let p3 = sequence3(token(a), token(b), token(c))
testParser(p3, "abcd")


/*---------------------------------------------------------------------/
//  Sequence the Parsers: The refined way
/---------------------------------------------------------------------*/

// Doesn't consume any tokens, returns a function that just returns an
// integer conversion of its input
func integerParser<Token>() -> Parser<Token, Character -> Int> {
  return Parser { input in
    return one(({ x in String(x).toInt()! }, input))
  }
}

let intParser: Parser<Character, Character -> Int> = integerParser()
var generatorIntParser = intParser.p("74".slice).generate()
let (intFunc, rest) = generatorIntParser.next()!
intFunc("9")  // converts to Int
rest          // nothing consumed


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

// The Combinator in action
let three: Character = "3"
testParser(combinator(integerParser(), token(three)), "3")

let combinatorParser = combinator(integerParser(), token(three))
let combinatorSeq = combinatorParser.p("34".slice)
var combinatorGen = combinatorSeq.generate()
let combinatorResult = combinatorGen.next()
combinatorResult!
combinatorResult!.0 == 3


/*---------------------------------------------------------------------/
//  Pure - Returns a value in a default context
//  pure :: a -> f a
/---------------------------------------------------------------------*/
func pure<Token, A>(value: A) -> Parser<Token, A> {
  return Parser { one((value, $0)) }
}

let pureA: Parser<Character, Character> = pure(a)
let seqPureA = pureA.p("abc".slice)
var genPureA = seqPureA.generate()
let resultPureA = genPureA.next()
resultPureA!
resultPureA!.0
resultPureA!.1


// Always returns the value
testParser(pureA, "x")


// Can now wrap a simple predicate in `pure`
func toInteger(c: Character) -> Int {
  return String(c).toInt()!
}
testParser(combinator(pure(toInteger), token(three)), "3")


// Due to currying, can go through the combination process multiple times
func toInteger2(c1: Character)(c2: Character) -> Int {
  let combined = String(c1) + String(c2)
  return combined.toInt()!
}
testParser(combinator(combinator(pure(toInteger2), token(three)),
  token(three)), "33")


/*---------------------------------------------------------------------/
//  <*>
//
//  “for Maybe, <*> extracts the function from the left value if it’s 
//   a Just and maps it over the right value. If any of the parameters
//   is Nothing, Nothing is the result.”
//   - Excerpt From: Miran Lipovaca. “Learn You a Haskell for Great Good!.” iBooks.
/---------------------------------------------------------------------*/
infix operator <*> { associativity left precedence 150 }
func <*><Token, A, B>(l: Parser<Token, A -> B>,
                      r: Parser<Token, A>)
                      -> Parser<Token, B> {
  return combinator(l, r)
}


// Using the new operator
testParser(pure(toInteger2) <*> token(three) <*> token(three), "33")


/*---------------------------------------------------------------------/
//  <|>
//
//  Combines several existing strings
/---------------------------------------------------------------------*/
func string(characters: [Character]) -> String {
  var s = ""
  s.extend(characters)
  return s
}

let aOrB = token(a) <|> token(b)

func combine(a: Character)(b: Character)(c: Character) -> String {
  return string([a, b, c])
}

let parser = pure(combine) <*> aOrB <*> aOrB <*> token(b)
testParser(parser, "abb")


// With our own currying for three parameter functions
func curry<A, B, C, D>(f: (A, B, C) -> D) -> A -> B -> C -> D {
  return { a in { b in { c in f(a, b, c) } } }
}

let parser2 = pure(curry { string([$0, $1, $2]) })
              <*> aOrB <*> aOrB <*> token(b)
testParser(parser2, "abb")



