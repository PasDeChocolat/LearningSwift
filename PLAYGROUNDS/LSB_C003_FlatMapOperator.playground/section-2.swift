import UIKit

/*
//  Flat Map Operator
//
//  Suggested Reading:
//  http://www.objc.io/snippets/4.html
/===================================*/


/*------------------------------------/
//  Deck of cards
/------------------------------------*/
let ranks = ["A", "K", "Q", "J", "10",
  "9", "8", "7", "6", "5",
  "4", "3", "2"]
let suits = ["♠", "♥", "♦", "♣"]


// All the cards!
typealias Card = (String, String)
var allCards1 = [Card]()
for rank in ranks {
  for suit in suits {
    allCards1.append((rank, suit))
  }
}
allCards1
allCards1.count

// But nested for loops are nasty.
func cardsForSuit(suit: String, ranks: [String]) -> [Card] {
  return ranks.map { ($0, suit) }
}

let cardsBySuit = suits.map { cardsForSuit($0, ranks) }
cardsBySuit
cardsBySuit.count
cardsBySuit[0]
cardsBySuit[1]
let allCards2 = cardsBySuit.reduce([], combine: +)
allCards2.count


/*------------------------------------/
//  Flat Map
/------------------------------------*/
infix operator >>= { associativity left }
func >>=<A, B>(xs: [A], f: A -> [B]) -> [B] {
  return xs.map(f).reduce([], combine: +)
}


// But nested for loops are nasty.
let allCards3 = ranks >>= { rank in
  suits >>= { suit in [(rank, suit)] }
}
allCards3
allCards3.count






