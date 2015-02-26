import UIKit

/*
//  Everything is Reduce
// 
//  Based on: Brandon Willams' talk on Functional Programming in a Playground
//    at the Functional Swift Conference, Dec. 6th, 2014, Brooklyn, NY
//  http://2014.funswiftconf.com/speakers/brandon.html
/==========================================*/



/*------------------------------------------------------/
//  Implement everything on arrays via `reduce`
/------------------------------------------------------*/

func map <A, B> (f: A -> B) -> [A] -> [B] {
  return { xs in
    return reduce(xs, []) { accum, x in
      return accum + [f(x)]
    }
  }
}

func filter <A> (p: A -> Bool) -> [A] -> [A] {
  return { xs in
    return reduce(xs, []) { accum, x in
      return p(x) ? accum + [x] : accum
    }
  }
}

func take <A> (n: Int) -> [A] -> [A] {
  return { xs in
    return reduce(xs, []) { accum, x in
      return accum.count < n ? accum + [x] : accum
    }
  }
}

func flatten <A> (xxs: [[A]]) -> [A] {
  return reduce(xxs, []) { accum, xs in
    return accum + xs
  }
}


