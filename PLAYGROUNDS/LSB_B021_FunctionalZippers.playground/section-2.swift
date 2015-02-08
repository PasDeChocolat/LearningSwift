import UIKit

/*
//  Functional Zippers
//
//  Based on:
//  Learn You a Haskell for Great Good,
//    Chapter 15, Zippers
//    - by Miran Lipovača
/===================================*/


/*---------------------------------------------------------------------/
//  Box, a hack
/---------------------------------------------------------------------*/
class Box<T> {
  let unbox: T
  init(_ value: T) { self.unbox = value }
}


/*---------------------------------------------------------------------/
//  Tree
/---------------------------------------------------------------------*/
enum Tree<T> {
  case Empty
  case Node(Box<T>, Box<Tree<T>>, Box<Tree<T>>)
}

let empty: Tree<String> = Tree.Empty
let five: Tree<String> = Tree.Node(Box("five"), Box(empty), Box(empty))


// create a tree with a single value
func singleton<T>(x: T) -> Tree<T> {
  return Tree.Node(Box(x), Box(Tree.Empty), Box(Tree.Empty))
}

func node<T>(x: T, l: Tree<T>, r: Tree<T>) -> Tree<T> {
  return Tree.Node(Box(x), Box(l), Box(r))
}

let freeTree = node("P",
                 node("O",
                   node("L",
                     node("N", empty, empty),
                     node("T", empty, empty)),
                   node("Y",
                     node("S", empty, empty),
                     node("A", empty, empty))),
                 node("L",
                   node("W",
                     node("C", empty, empty),
                     node("R", empty, empty)),
                   node("A",
                     node("A", empty, empty),
                     node("C", empty, empty))))


/*---------------------------------------------------------------------/
//  Breadcrumbs
/---------------------------------------------------------------------*/
extension Array {
  var decompose: (head: T, tail: [T])? {
    return (count > 0) ? (self[0], Array(self[1..<count])) : nil
  }
}

enum Crumb<T> {
  case Left(Box<T>, Tree<T>)
  case Right(Box<T>, Tree<T>)
}

func goLeft<T>(zipper: (Tree<T>, [Crumb<T>])) -> (Tree<T>, [Crumb<T>])? {
  let (t, crumbs) = zipper
  switch t {
  case .Empty:
    return nil
  case let .Node(x, l, r):
    return (l.unbox, [Crumb.Left(x, r.unbox)] + crumbs)
  }
}

func goRight<T>(zipper: (Tree<T>, [Crumb<T>])) -> (Tree<T>, [Crumb<T>])? {
  let (t, crumbs) = zipper
  switch t {
  case .Empty:
    return nil
  case let .Node(x, l, r):
    return (r.unbox, [Crumb.Right(x, l.unbox)] + crumbs)
  }
}

func goUp<T>(zipper: (Tree<T>, [Crumb<T>])) -> (Tree<T>, [Crumb<T>])? {
  let (t, crumbs) = zipper
  if let (c, bs) = crumbs.decompose {
    switch c {
    case let .Left(x, r):
      return (node(x.unbox, t, r), bs)
    case let .Right(x, l):
      return (node(x.unbox, l, t), bs)
    }
  } else {
    return nil
  }
}


/*---------------------------------------------------------------------/
//  elements
/---------------------------------------------------------------------*/
// list elements
func elements<T>(tree: Tree<T>) -> [T] {
  switch tree {
  case .Empty:
    return []
  case let .Node(x, left, right):
    return elements(left.unbox) + [x.unbox] + elements(right.unbox)
  }
}
elements(freeTree)


/*---------------------------------------------------------------------/
//  modify
/---------------------------------------------------------------------*/
func modify<T>(f: T->T, zipper: (Tree<T>, [Crumb<T>])) -> (Tree<T>, [Crumb<T>]) {
  let (t, crumbs) = zipper
  switch t {
  case .Empty:
    return (Tree.Empty, crumbs)
  case let .Node(x, l, r):
    return (node(f(x.unbox), l.unbox, r.unbox), crumbs)
  }
}

let freeZipper = (freeTree, [Crumb<String>]())

goRight(freeZipper)!
goLeft(freeZipper)!

let (leftTree, leftCrumbs) = goLeft(freeZipper)!
elements(leftTree)
leftCrumbs

goRight( goLeft(freeZipper)! )!

func makeP(x: String) -> String {
  return "P"
}

let newFocus = modify(makeP, goRight(goLeft(freeZipper)!)!)
elements(newFocus.0)


/*---------------------------------------------------------------------/
//  Allow modification to any letter
/---------------------------------------------------------------------*/
func makeLetter(letter: String) -> String -> String {
  func makeX(_: String) -> String {
    return letter
  }
  return makeX
}

let newFocus1 = modify(makeLetter("P"), goRight(goLeft(freeZipper)!)!)
elements(newFocus1.0)


let newFocus2 = modify(makeLetter("X"), goUp(newFocus1)!)
elements(newFocus2.0)


/*---------------------------------------------------------------------/
//  attach
/---------------------------------------------------------------------*/
func attach<T>(t: Tree<T>, zipper: (Tree<T>, [Crumb<T>])) -> (Tree<T>, [Crumb<T>]) {
  let (_, crumbs) = zipper
  return (t, crumbs)
}

let farLeft = goLeft( goLeft( goLeft( goLeft( freeZipper )!)!)!)!
let newFocus3 = attach(node("Z", empty, empty), farLeft)
elements(newFocus3.0)


/*---------------------------------------------------------------------/
//  topMost
/---------------------------------------------------------------------*/
func topMost<T>(zipper: (Tree<T>, [Crumb<T>])) -> (Tree<T>, [Crumb<T>]) {
  let (t, crumbs) = zipper
  if crumbs.isEmpty { return zipper }
  return topMost(goUp( zipper )!)
}

let top = topMost(newFocus3)
elements(top.0)


/*---------------------------------------------------------------------/
//  Optionals are monads!... use >>=
/---------------------------------------------------------------------*/
infix operator >>= { associativity left}
func >>=<U, T>(optional: T?, f: T -> U?) -> U? {
  return optional.map { f($0)! }
}

func opt<T>(zipper: (Tree<T>, [Crumb<T>])) -> (Tree<T>, [Crumb<T>])? {
  return zipper
}

let bindRight = opt(freeZipper) >>= goRight
elements(bindRight!.0)

let bindLeft = opt(freeZipper) >>= goLeft
elements(bindLeft!.0)

let bindLLLeft = opt(freeZipper) >>= goLeft >>= goLeft >>= goLeft
elements(bindLLLeft!.0)



