import UIKit

/*
//  Typed Notification Observers
//
//  Based on:
//  http://www.objc.io/snippets/16.html
//  https://gist.github.com/chriseidhof/9bf7280063db3a249fbe
/===================================*/



/*------------------------------------/
//  Posting a Notification
/------------------------------------*/
class Box<T> {
  let unbox: T
  init(_ value: T) { self.unbox = value }
}

struct Notification<A> {
  let name: String
}

func postNotification<A>(note: Notification<A>, value: A) {
  let userInfo = ["value": Box(value)]
  NSNotificationCenter.defaultCenter().postNotificationName(note.name, object: nil, userInfo: userInfo)
}


/*------------------------------------/
//  Observing Notifications
/------------------------------------*/
class NotificationObserver {
  let observer: NSObjectProtocol
  
  init<A>(notification: Notification<A>, block aBlock: A -> ()) {
    observer = NSNotificationCenter.defaultCenter().addObserverForName(notification.name, object: nil, queue: nil) { note in
      if let value = (note.userInfo?["value"] as? Box<A>)?.unbox {
        aBlock(value)
      } else {
        assert(false, "Couldn't understand user info")
      }
    }
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(observer)
  }
  
}


/*------------------------------------/
//  See it in action
/------------------------------------*/
let globalPanicNotification: Notification<NSError> = Notification(name: "Global panic")


let myError: NSError = NSError(domain: "com.learningswiftbasics.d001", code: 42, userInfo: [:])

let panicObserver = NotificationObserver(notification: globalPanicNotification) { err in
  println("Error Description: \(err.localizedDescription)")
}

// Uncomment this line and check the console for log messages
//postNotification(globalPanicNotification, myError)
//postNotification(globalPanicNotification, myError)


