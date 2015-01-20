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


/*---------------------------------------------------------/
//  Naive custom UIView for drawing diagrams
/---------------------------------------------------------*/
class DrawView: UIView {
  let diagram: Diagram
  
  init(frame frameRect: CGRect, diagram: Diagram) {
    self.diagram = diagram
    super.init(frame:frameRect)
  }
  
  required init(coder: NSCoder) {
    fatalError("NSCoding not supported")
  }
  
  override func drawRect(dirtyRect: CGRect) {
    if let context = UIGraphicsGetCurrentContext() {
      draw(context, self.bounds, diagram)
    }
  }
}

DrawView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), diagram: blueSquare)
DrawView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), diagram: example2)


/*---------------------------------------------------------/
//  Bar graph example
/---------------------------------------------------------*/
// Swift does not currently support adding a public
// declaration to an extension of a generic type from a 
// different module. (2015/1/19)
extension Dictionary {
  var keysAndValues: [(Key, Value)] {
    var result: [(Key, Value)] = []
    for item in self {
      result.append(item)
    }
    return result
  }
}

func barGraph(input: [(String, Double)]) -> Diagram {
  let values: [CGFloat] = input.map { CGFloat($0.1) }
  let nValues = normalize(values)
  let bars = hcat(nValues.map { (x: CGFloat) -> Diagram in
    return rect(width: 1, height: 3 * x)
      .fill(UIColor.blackColor()).alignBottom()
    })
  let labels = hcat(input.map { x in
    return text(width: 1, height: 0.3, text: x.0).alignTop()
    })
  return bars --- labels
}
let cities = ["Shanghai": 14.01, "Istanbul": 13.3, "Moscow": 10.56, "New York": 8.33, "Berlin": 3.43]
let example3 = barGraph(cities.keysAndValues)
let ex3View = DrawView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), diagram: example3)
ex3View.backgroundColor = UIColor.whiteColor()


