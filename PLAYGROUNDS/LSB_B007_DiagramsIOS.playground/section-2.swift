import UIKit
import FunctionalDiagrams


/*
//  Diagrams, a DSL (now in iOS)
//
//  Suggested Reading:
//  http://www.objc.io/books/ (Chapter 10)
//    (Functional Programming in Swift, by Chris Eidhof, Florian Kugler, and Wouter Swierstra)
/===================================*/


/*---------------------------------------------------------/
//  x
/---------------------------------------------------------*/
var str = "Hello, playground"

//Define a UILabel with a frame and set some display text
let helloLabel = UILabel(frame: CGRectMake(0.0, 0.0, 200.0, 44.0))
helloLabel.text = str;

helloLabel


// Split
let x = splitVertical(CGRect(x: 0, y: 0, width: 100, height: 50), CGSize(width: 10, height: 20))
x.0
x.1


// Fit
fit(Vector2D(x: 0.5, y: 0.5), CGSizeMake(1, 1),
  CGRectMake(0, 0, 200, 100))

fit(Vector2D(x: 0, y: 0.5), CGSizeMake(1, 1),
  CGRectMake(0, 0, 200, 100))


/*---------------------------------------------------------/
//  Examples: Shapes
/---------------------------------------------------------*/
let blueSquare = square(side: 1).fill(UIColor.blueColor())
let redSquare = square(side: 2).fill(UIColor.redColor())
let greenCircle = circle(diameter: 1).fill(UIColor.greenColor())
let example1 = blueSquare ||| redSquare ||| greenCircle
let cyanCircle = circle(diameter: 1).fill(UIColor.cyanColor())
let example2 = blueSquare ||| cyanCircle |||
  redSquare ||| greenCircle


class DrawView: UIView {
  let diagram: Diagram
  
  init(frame frameRect: CGRect, diagram: Diagram) {
    self.diagram = diagram
    super.init(frame:frameRect)
  }
  
  required init(coder: NSCoder) {
    fatalError("NSCoding not supported")
  }
  
//  override func drawRect(dirtyRect: CGRect) {
//    if let context = NSGraphicsContext.currentContext() {
//      draw(context.cgContext, self.bounds, diagram)
//    }
//  }
}






//func docDirURL() -> NSURL {
//  return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
//}
//
//func docDirURLString() -> String {
//  return "\(docDirURL())"
//}

//func writepdf(name: String, diagram: Diagram) -> Bool {
//  let data = pdf(diagram, 300)
//  var error: NSError? = nil
//  
//  // get URL to the the documents directory in the sandbox
//  let documentsUrl = docDirURL()
//  
//  // add a filename
//  let fileUrl = documentsUrl.URLByAppendingPathComponent("\(name).pdf")
//  println("PDF written to: \(fileUrl)")
//  data.writeToURL(fileUrl, options: NSDataWritingOptions.AtomicWrite, error: &error)
//  if let e = error {
//    println(e.description)
//    return false
//  } else {
//    return true
//  }
//}

//docDirURLString()
//writepdf("example1", example1)
//writepdf("example2", example2)




