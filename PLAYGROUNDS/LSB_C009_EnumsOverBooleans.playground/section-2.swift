import UIKit

/*
//  Enums Over Booleans
//
//  Suggested Reading:
//  http://www.objc.io/snippets/12.html
/===================================*/


// Consider car turn signals...


/*------------------------------------/
//  The old way, with booleans
/------------------------------------*/
func detectTurn(isLtBlink: Bool, isRtBlink: Bool) -> String {
  if isLtBlink {
    return "turning LEFT"
  } else if isRtBlink {
    return "turning RIGHT"
  } else if !isLtBlink && !isRtBlink {
    return "going STRAIGHT"
  } else {
    assertionFailure("This should never happen!")
  }
}

// For a left turn
var isLeftBlinkerOn  = true
var isRightBlinkerOn = false
detectTurn(isLeftBlinkerOn, isRightBlinkerOn)

// For a right turn
isLeftBlinkerOn  = false
isRightBlinkerOn = true
detectTurn(isLeftBlinkerOn, isRightBlinkerOn)

// For continuing straight
isLeftBlinkerOn  = false
isRightBlinkerOn = false
detectTurn(isLeftBlinkerOn, isRightBlinkerOn)


/*------------------------------------/
//  The old way, but with a tuple
/------------------------------------*/
func detectTurnTuple(blinkers: (Bool, Bool)) -> String {
  switch blinkers {
  case (true, true):
    assertionFailure("Both blinkers on at the same time!")
  case (true, _):
    return "turning LEFT"
  case (_, true):
    return "turning RIGHT"
  case (false, false):
    return "going STRAIGHT"
  default:
    // Swift is not smart enough to know this can never happen.
    assertionFailure("This can never happen!")
  }
}

// For a left turn
var blinkers = (true, false)
detectTurnTuple(blinkers)

// For a right turn
blinkers = (false, true)
detectTurnTuple(blinkers)

// For continuing straight
blinkers = (false, false)
detectTurnTuple(blinkers)


/*------------------------------------/
//  Now, with an Enum
/------------------------------------*/
enum Signal {
  case Left
  case Right
  case None
}

func detectTurnWithSignal(signal: Signal) -> String {
  switch signal {
  case .Left:
    return "turning LEFT"
  case .Right:
    return "turning RIGHT"
  case .None:
    return "going STRAIGHT"
  }
}

detectTurnWithSignal(.Left)
detectTurnWithSignal(.Right)
detectTurnWithSignal(.None)


