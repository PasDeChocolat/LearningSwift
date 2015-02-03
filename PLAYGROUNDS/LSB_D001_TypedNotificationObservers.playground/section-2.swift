import UIKit

/*
//  Typed Notification Observers
//
//  Based on:
//  http://www.objc.io/snippets/16.html
/===================================*/


/*------------------------------------/
//  Box: A hack for self-reference
//
//  Suggested Reading:
//  http://www.quora.com/How-can-enumerations-in-Swift-be-recursive
/------------------------------------*/
class Box<T> {
  let unbox: T
  init(_ value: T) { self.unbox = value }
}


/*------------------------------------/
//  Notifications
/------------------------------------*/
struct Notification<A> {
  let name: String
}

func postNotification<A>(note: Notification<A>, value: A) {
  let userInfo = ["value": Box(value)]
  NSNotificationCenter.defaultCenter().postNotificationName(note.name, object: nil, userInfo: userInfo)
}

class NotificationObserver {
  let observer: NSObjectProtocol
  
  init<A>(notification: Notification<A>, block aBlock: A -> ()) {
    observer = NSNotificationCenter.defaultCenter().addObserverForName(notification.name, object: nil, queue: nil) { note in
      if let value = (note.userInfo?["value"] as? Box<A>)?.unbox {
        aBlock(value)
      } else {
        assert(false, "Bad user info value")
      }
    }
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(observer)
  }
  
}

let globalPanicNotification: Notification<NSError> = Notification(name: "Super bad error")


let myError: NSError = NSError(domain: "com.pasdechocolat.example", code: 42, userInfo: [:])

let panicObserver = NotificationObserver(notification: globalPanicNotification) { err in
  println(err.localizedDescription)
}


/*------------------------------------/
//  Run it!
//  Uncomment this.
/------------------------------------*/
//postNotification(globalPanicNotification, myError)



