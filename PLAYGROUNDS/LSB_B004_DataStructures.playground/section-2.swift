import UIKit

/*
//  Data Structures
//
//  Suggested Reading:
//  http://www.objc.io/books/ (Chapter 9)
//    (Functional Programming in Swift, by Chris Eidhof, Florian Kugler, and Wouter Swierstra)
/===================================*/


/*---------------------------------------------------------/
//  Box, a hack
/---------------------------------------------------------*/
class Box<T> {
  let unbox: T
  init(_ value: T) { self.unbox = value }
}


enum Result<T> {
  case Success(Box<T>)
  case Failure(String)
}


// Box a Result containing a Success String
func successResultString() -> Result<String> {
  return Result.Success(Box("Success"))
}

switch successResultString() {
case let Result.Success(box):
  box.unbox
default:
  assert(false, "Unexpected!")
}


// Box a Result containing a Success void type, ()
func successResultVoid() -> Result<()> {
  return Result.Success(Box(()))
}

switch successResultVoid() {
case let Result.Success(box):
  box.unbox
  "Successful void type received!"
default:
  assert(false, "Unexpected!")
}


/*---------------------------------------------------------/
//  Tree
/---------------------------------------------------------*/
enum Tree<T> {
  case Leaf
  case Node(Box<Tree<T>>, Box<T>, Box<Tree<T>>)
}

let leaf: Tree<Int> = Tree.Leaf
let five: Tree<Int> = Tree.Node(Box(leaf), Box(5), Box(leaf))


// create a tree with a single value
func single<T>(x: T) -> Tree<T> {
  return Tree.Node(Box(Tree.Leaf), Box(x), Box(Tree.Leaf))
}


// count elements
func count<T>(tree: Tree<T>) -> Int {
  switch tree {
  case Tree.Leaf:
    return 0
  case let Tree.Node(left, x, right):
    return count(left.unbox) + 1 + count(right.unbox)
  }
}

count(five)
count(single(10))


// list elements
func elements<T>(tree: Tree<T>) -> [T] {
  switch tree {
  case Tree.Leaf:
    return []
  case let Tree.Node(left, x, right):
    return elements(left.unbox) + [x.unbox] + elements(right.unbox)
  }
}

elements(five)
elements(single(10))


/*---------------------------------------------------------/
//  Tree as a Set
/---------------------------------------------------------*/
func setInsert<T: Comparable>(x: T, tree: Tree<T>) -> Tree<T> {
  switch tree {
  case Tree.Leaf:
    return single(x)
    
  case let Tree.Node(left, y, right) where x == y.unbox:
    // duplicate value
    return tree
    
  case let Tree.Node(left, y, right) where x < y.unbox:
    // new value is smaller
    return Tree.Node(Box(setInsert(x, left.unbox)), y, right)
  
  case let Tree.Node(left, y, right) where x > y.unbox:
    // new value is bigger
    return Tree.Node(left, y, Box(setInsert(x, right.unbox)))
    
  default:
    assert(false, "Unexpected failure!")
  }
}

var bigTree = setInsert(42, setInsert(10, single(5)))
elements(bigTree)


/*---------------------------------------------------------/
//  Custom operator for adding values to a set
//
//  Suggested Reading:
//    http://nshipster.com/swift-operators/
/---------------------------------------------------------*/
infix operator |> { associativity right }
func |><T: Comparable>(x: T, tree: Tree<T>) -> Tree<T> {
  return setInsert(x, tree)
}

var biggerTree = 32 |> 100 |> 42 |> 5 |> single(10)
elements(biggerTree)


// Or, the reverse direction
infix operator <| { associativity left }
func <|<T: Comparable>(tree: Tree<T>, x: T) -> Tree<T> {
  return setInsert(x, tree)
}
var biggerTree2 = single(10) <| 5 <| 42 <| 100 <| 32
elements(biggerTree2)


/*---------------------------------------------------------/
//  More set operations
/---------------------------------------------------------*/
func emptySet<T>() -> Tree<T> {
  return Tree.Leaf
}

func isEmptySet<T>(tree: Tree<T>) -> Bool {
  switch tree {
  case let Tree.Leaf:
    return true
  case Tree.Node:
    return false
  }
}

isEmptySet(biggerTree)

let empty: Tree<Int> = emptySet()
isEmptySet(empty)


// Need a helper method to check if predicate is true for all members
func all<T>(xs: [T], predicate: T -> Bool) -> Bool {
  for x in xs {
    if !predicate(x) { return false }
  }
  return true
}


// Verify the set in a binary search tree
func isBST<T: Comparable>(tree: Tree<T>) -> Bool {
  switch tree {
  case Tree.Leaf:
    return true
  case let Tree.Node(left, x, right):
    let leftElements = elements(left.unbox)
    let rightElements = elements(right.unbox)
    return
      all(leftElements)  { y in y < x.unbox } &&
      all(rightElements) { y in y > x.unbox } &&
      isBST(left.unbox) &&
      isBST(right.unbox)
  }
}
isBST(biggerTree2)


// Check for set membership
func setContains<T: Comparable>(x: T, tree: Tree<T>) -> Bool {
  switch tree {
  case Tree.Leaf:
    return false
    
  case let Tree.Node(left, y, right) where x == y.unbox:
    // found match
    return true
    
  case let Tree.Node(left, y, right) where x < y.unbox:
    // search value is smaller
    return setContains(x, left.unbox)
    
  case let Tree.Node(left, y, right) where x > y.unbox:
    // search value is bigger
    return setContains(x, right.unbox)
    
  default:
    assert(false, "Unexpected failure!")
  }
}
setContains(42, biggerTree2)
setContains(1000, biggerTree2)








