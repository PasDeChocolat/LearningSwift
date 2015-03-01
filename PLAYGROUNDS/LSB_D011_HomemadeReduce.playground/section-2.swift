import UIKit

/*
//  Homemade Reduce
// 
============================================================*/



/*---------------------------------------------------------/
//  decompose - Required Array extension
//                It helps with list recursion.
/---------------------------------------------------------*/
extension Array {
  var decompose: (head: T, tail: [T])? {
    return (count > 0) ? (self[0], Array(self[1..<count])) : nil
  }
}


let list = Array(1...5)
let (h, t) = list.decompose!
h
t


/*---------------------------------------------------------/
//  Reduce
//
//  reduce(<#sequence: S#>, <#initial: U#>, <#combine: @noescape (U, S.Generator.Element) -> U##@noescape (U, S.Generator.Element) -> U#>)
//
/---------------------------------------------------------*/
func freduce<A,T> (initial: A, xs: [T], f: (A, T) -> A) -> A {
  if let (head, tail) = xs.decompose {
    let acc = f(initial, head)
    return freduce(acc, tail, f)
  } else {
    return initial
  }
}

freduce(0, list, +)

func freduce<T> (xs: [T], f: (T, T) -> T) -> T? {
  if let (head, tail) = xs.decompose {
    return freduce(head, tail, f)
  } else {
    return nil
  }
}

freduce(list, +)!



/*---------------------------------------------------------/
//  Partition
/---------------------------------------------------------*/
func fpartition<T> (xs: [T], f: (T) -> Bool) -> ([T], [T]) {
  return freduce(([],[]), xs) { acc, next in
    let (incl, excl) = acc
    if f(next) {
      return (incl + [next], excl         )
    } else {
      return (incl,          excl + [next])
    }
  }
}

let part0 = fpartition(list) { (x) -> Bool in
  return x > 3
}
part0

let part1 = fpartition(list) { $0 > 3 }
part1



/*---------------------------------------------------------/
//  All? - "And"
/---------------------------------------------------------*/
func isAll<T> (xs: [T], f: (T) -> Bool) -> Bool {
  if let (head, tail) = xs.decompose {
    return f(head) ? isAll(tail, f) : false
  } else {
    return true
  }
}

let all0 = isAll(list) { $0 > 3 }
all0

let all1 = isAll(list) { $0 < 100 }
all1



/*---------------------------------------------------------/
//  Any? - "Or"
/---------------------------------------------------------*/
func isAny<T> (xs: [T], f: (T) -> Bool) -> Bool {
  if let (head, tail) = xs.decompose {
    return f(head) ? true : isAny(tail, f)
  } else {
    return false
  }
}

let any0 = isAny(list) { $0 < 3 }
any0

let any1 = isAny(list) { $0 > 100 }
any1



/*---------------------------------------------------------/
//  Drop
/---------------------------------------------------------*/
func fdrop <A> (n: Int, xs: [A]) -> [A] {
  if let (head, tail) = xs.decompose {
    return n <= 0 ? xs : fdrop(n-1, tail)
  } else {
    return xs
  }
}

fdrop(2, list)
fdrop(3, list)
fdrop(30, list)



/*---------------------------------------------------------/
//  Take
/---------------------------------------------------------*/
func ftake <A> (n: Int, xs: [A]) -> [A] {
  if let (head, tail) = xs.decompose {
    return n <= 0 ? [] : [head] + ftake(n-1, tail)
  } else {
    return xs
  }
}

ftake(2, list)
ftake(3, list)
ftake(30, list)


func ftake2 <A> (n: Int, xs: [A]) -> [A] {
  return reduce(xs, []) { accum, x in
    return accum.count < n ? accum + [x] : accum
  }
}

ftake2(2, list)
ftake2(3, list)
ftake2(30, list)



/*---------------------------------------------------------/
//  Drop While
/---------------------------------------------------------*/
func fdropwhile <A> (xs: [A], f: (A) -> Bool) -> [A] {
  if let (head, tail) = xs.decompose {
    return f(head) ? fdropwhile(tail, f) : xs
  } else {
    return xs
  }
}

let dropped0 = fdropwhile(list) { $0 < 3 }
dropped0

let dropped1 = fdropwhile(list) { $0 > 30 }
dropped1

let dropped2 = fdropwhile(list) { $0 < 30 }
dropped2



/*---------------------------------------------------------/
//  Take While
/---------------------------------------------------------*/
func ftakewhile <A> (xs: [A], f: (A) -> Bool) -> [A] {
  if let (head, tail) = xs.decompose {
    return f(head) ? [head] + ftakewhile(tail, f) : []
  } else {
    return xs
  }
}

let taken0 = ftakewhile(list) { $0 < 3 }
taken0

let taken1 = ftakewhile(list) { $0 < 4 }
taken1

let taken2 = ftakewhile(list) { $0 < 30 }
taken2

let taken3 = ftakewhile(list) { $0 > 30 }
taken3



