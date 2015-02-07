import UIKit

/*
//  Functors
//
//  Based on:
//  http://www.objc.io/books/ (Chapter 14, Functors, Applicative Functors, and Monads)
//    (Functional Programming in Swift, by Chris Eidhof, Florian Kugler, and Wouter Swierstra)
/===================================*/


/*---------------------------------------------------------------------/
//  Map - Why are there two?
/---------------------------------------------------------------------*/

// func map<T, U>(xs: [T], transform: T -> U) -> [U]
let numbers: Array<Int> = Array(1...5)  // Array as type constructor
let numbersPlusOne = map(numbers) { $0 + 1 }
numbersPlusOne

// func map<T, U>(optional: T?, transform: T -> U) -> U?
let opt: Optional<Int> = 1  // Optional as type constructor
let optPlusOne = map(opt) { $0 + 1 }
optPlusOne!  // <-- unwrap!


/* 
   `Array` is a type constructor
   `Array` is not a valid type
   `Array<T>` is a valid type
   `Array<Int>` is a valid type (a concrete type)

   `Optional` is a type constructor
   `Optional<Int>` is a valid type (a concrete type)

   Type constructors that support a map operation are sometimes referred
   to as, "functors."

   They are sometimes described as "containers."

   Almost every generic enum you define in Swift is a functor.
*/

/*---------------------------------------------------------------------/
//  Trees are functors
//
//  From Learn You a Haskell for Great Good, Chapter 7
//  - by Miran Lipovača
//
//  instance Functor Tree where
//  fmap f EmptyTree = EmptyTree
//  fmap f (Node x left right) = Node (f x) (fmap f left) (fmap f right)
/---------------------------------------------------------------------*/

class Box<T> {
  let unbox: T
  init(_ value: T) { self.unbox = value }
}

/*---------------------------------------------------------/
//  Tree
/---------------------------------------------------------*/
enum Tree<T> {
  case Empty
  case Node(Box<T>, Box<Tree<T>>, Box<Tree<T>>)
}

let empty: Tree<Int> = Tree.Empty
let five: Tree<Int> = Tree.Node(Box(5), Box(empty), Box(empty))


/*---------------------------------------------------------/
//  Tree - Map
/---------------------------------------------------------*/
func map<T>(tree: Tree<T>, transform f: T -> T) -> Tree<T> {
  switch tree {
  case let .Node(value, left, right):
    return Tree.Node(Box(f(value.unbox)),
                     Box(map(left.unbox, f)),
                     Box(map(right.unbox, f)))
  case .Empty:
    return Tree.Empty
  }
}

let fivePlusFive = map(five, { $0 + 5 })


// List Tree node values in an array
func elements<T>(tree: Tree<T>) -> [T] {
  switch tree {
  case Tree.Empty:
    return []
  case let Tree.Node(value, left, right):
    return elements(left.unbox) + [value.unbox] + elements(right.unbox)
  }
}

elements(five)
elements(fivePlusFive)


/*---------------------------------------------------------/
//  Tree Insert
/---------------------------------------------------------*/
// create a tree with a single value
func singleton<T>(x: T) -> Tree<T> {
  return Tree.Node(Box(x), Box(Tree.Empty), Box(Tree.Empty))
}


func treeInsert<T: Comparable>(x: T, tree: Tree<T>) -> Tree<T> {
  switch tree {
  case .Empty:
    return singleton(x)
  case let .Node(value, _, _) where value.unbox == x:
    return tree
  case let .Node(value, left, right) where value.unbox > x:
    return Tree.Node(value, Box(treeInsert(x, left.unbox)), right)
  case let .Node(value, left, right) where value.unbox < x:
    return Tree.Node(value, left, Box(treeInsert(x, right.unbox)))
  default: assertionFailure("fail!")
  }
}

elements(singleton(4))

elements(treeInsert(5, five))
elements(treeInsert(6, five))
elements(treeInsert(4, five))


/*---------------------------------------------------------/
//  Check Element
/---------------------------------------------------------*/
func treeElem<T: Comparable>(x: T, tree: Tree<T>) -> Bool {
  switch tree {
  case .Empty:
    return false
  case let .Node(value, _, _) where x == value.unbox:
    return true
  case let .Node(value, left, _) where x < value.unbox:
    return treeElem(x, left.unbox)
  case let .Node(value, _, right) where x > value.unbox:
    return treeElem(x, right.unbox)
  default: assertionFailure("fail!")
  }
}

treeElem(5, five)
treeElem(4, five)
treeElem(6, treeInsert(6, treeInsert(4, five)))
treeElem(3, treeInsert(6, treeInsert(4, five)))


/*---------------------------------------------------------/
//  Fold to create a tree from a list
/---------------------------------------------------------*/
let treeValues = [8, 6, 4, 1, 7, 3, 5]
let vTree = reduce(treeValues, Tree.Empty) { treeInsert($1, $0) }
elements(vTree)


// Make this is a little nicer with `flip`
func flip<A, B, C>(f: (B, A) -> C) -> (A, B) -> C {
  return { (x, y) in f(y, x) }
}

let vTree2 = reduce(treeValues, Tree.Empty, flip(treeInsert))
elements(vTree2)


/*---------------------------------------------------------/
//  Tree - Map - Part 2
/---------------------------------------------------------*/
let vTreePlus10 = map(vTree) { $0 + 10 }
elements(vTreePlus10)


