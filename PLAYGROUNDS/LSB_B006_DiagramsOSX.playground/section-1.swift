import Cocoa

/*
//  Diagrams, a DSL
//
//  Suggested Reading:
//  http://www.objc.io/books/ (Chapter 10)
//    (Functional Programming in Swift, by Chris Eidhof, Florian Kugler, and Wouter Swierstra)
/===================================*/


/*---------------------------------------------------------/
//  Our Framework Library
/---------------------------------------------------------*/
class Box<T> {
  let unbox: T
  init(_ value: T) { self.unbox = value }
}

extension NSGraphicsContext {
  var cgContext : CGContextRef {
    let opaqueContext = COpaquePointer(self.graphicsPort)
    return Unmanaged<CGContextRef>.fromOpaque(opaqueContext)
      .takeUnretainedValue()
  }
}

func *(l: CGPoint, r: CGRect) -> CGPoint {
  return CGPointMake(r.origin.x + l.x*r.size.width,
    r.origin.y + l.y*r.size.height)
}

func *(l: CGFloat, r: CGPoint) -> CGPoint {
  return CGPointMake(l*r.x, l*r.y)
}
func *(l: CGFloat, r: CGSize) -> CGSize {
  return CGSizeMake(l*r.width, l*r.height)
}

func pointWise(f: (CGFloat, CGFloat) -> CGFloat,
  l: CGSize, r: CGSize) -> CGSize {
    
    return CGSizeMake(f(l.width, r.width), f(l.height, r.height))
}

func pointWise(f: (CGFloat, CGFloat) -> CGFloat,
  l: CGPoint, r:CGPoint) -> CGPoint {
    
    return CGPointMake(f(l.x, r.x), f(l.y, r.y))
}

func /(l: CGSize, r: CGSize) -> CGSize {
  return pointWise(/, l, r)
}
func *(l: CGSize, r: CGSize) -> CGSize {
  return pointWise(*, l, r)
}
func +(l: CGSize, r: CGSize) -> CGSize {
  return pointWise(+, l, r)
}
func -(l: CGSize, r: CGSize) -> CGSize {
  return pointWise(-, l, r)
}

func -(l: CGPoint, r: CGPoint) -> CGPoint {
  return pointWise(-, l, r)
}
func +(l: CGPoint, r: CGPoint) -> CGPoint {
  return pointWise(+, l, r)
}
func *(l: CGPoint, r: CGPoint) -> CGPoint {
  return pointWise(*, l, r)
}


extension CGSize {
  var point : CGPoint {
    return CGPointMake(self.width, self.height)
  }
}

func isHorizontalEdge(edge: CGRectEdge) -> Bool {
  switch edge {
  case .MaxXEdge, .MinXEdge:
    return true
  default:
    return false
  }
}

func splitRect(rect: CGRect, sizeRatio: CGSize,
  edge: CGRectEdge) -> (CGRect, CGRect) {
    
    let ratio = isHorizontalEdge(edge) ? sizeRatio.width
      : sizeRatio.height
    let multiplier = isHorizontalEdge(edge) ? rect.width
      : rect.height
    let distance : CGFloat = multiplier * ratio
    var mySlice : CGRect = CGRectZero
    var myRemainder : CGRect = CGRectZero
    CGRectDivide(rect, &mySlice, &myRemainder, distance, edge)
    return (mySlice, myRemainder)
}

func splitHorizontal(rect: CGRect,
  ratio: CGSize) -> (CGRect, CGRect) {
    
    return splitRect(rect, ratio, CGRectEdge.MinXEdge)
}

func splitVertical(rect: CGRect,
  ratio: CGSize) -> (CGRect, CGRect) {
    
    return splitRect(rect, ratio, CGRectEdge.MinYEdge)
}

extension CGRect {
  init(center: CGPoint, size: CGSize) {
    let origin = CGPointMake(center.x - size.width/2,
      center.y - size.height/2)
    self.init(origin: origin, size: size)
  }
}

// A 2-D Vector
struct Vector2D {
  let x: CGFloat
  let y: CGFloat
  
  var point : CGPoint { return CGPointMake(x, y) }
  
  var size : CGSize { return CGSizeMake(x, y) }
}

func *(m: CGFloat, v: Vector2D) -> Vector2D {
  return Vector2D(x: m * v.x, y: m * v.y)
}

extension Dictionary {
  var keysAndValues: [(Key, Value)] {
    var result: [(Key, Value)] = []
    for item in self {
      result.append(item)
    }
    return result
  }
}

func normalize(input: [CGFloat]) -> [CGFloat] {
  let maxVal = input.reduce(0) { max($0, $1) }
  return input.map { $0 / maxVal }
}


/*---------------------------------------------------------/
//  Core Data Primitives
/---------------------------------------------------------*/
enum Primitive {
  case Ellipse
  case Rectangle
  case Text(String)
}


/*---------------------------------------------------------/
//  Diagram
/---------------------------------------------------------*/
enum Diagram {
  case Prim(CGSize, Primitive)
  case Beside(Box<Diagram>, Box<Diagram>)
  case Below(Box<Diagram>, Box<Diagram>)
  case Attributed(Attribute, Box<Diagram>)
  case Align(Vector2D, Box<Diagram>)
}


/*---------------------------------------------------------/
//  Attribute
/---------------------------------------------------------*/
enum Attribute {
  case FillColor(NSColor)
}


/*---------------------------------------------------------/
//  Calculating Diagram Size
/---------------------------------------------------------*/
extension Diagram {
  var size: CGSize {
    switch self {
    case .Prim(let size, _):
      return size
    case .Attributed(_, let x):
      return x.unbox.size
    case .Beside(let l, let r):
      let sizeL = l.unbox.size
      let sizeR = r.unbox.size
      return CGSizeMake(sizeL.width + sizeR.width,
        max(sizeL.height, sizeR.height))
    case .Below(let l, let r):
      let sizeL = l.unbox.size
      let sizeR = r.unbox.size
      return CGSizeMake(max(sizeL.width, sizeR.width),
        sizeL.height+sizeR.height)
    case .Align(_, let r):
      return r.unbox.size
    }
  }
}


/*---------------------------------------------------------/
//  fit - Sizing and placing diagrams
/---------------------------------------------------------*/
func fit(alignment: Vector2D,
  inputSize: CGSize, rect: CGRect) -> CGRect {
    
    let scaleSize = rect.size / inputSize
    let scale = min(scaleSize.width, scaleSize.height)
    let size = scale * inputSize
    let space = alignment.size * (size - rect.size)
    return CGRect(origin: rect.origin - space.point, size: size)
}


fit(Vector2D(x: 0.5, y: 0.5), CGSizeMake(1, 1),
  CGRectMake(0, 0, 200, 100))

fit(Vector2D(x: 0, y: 0.5), CGSizeMake(1, 1),
  CGRectMake(0, 0, 200, 100))


/*---------------------------------------------------------/
//  fit - Sizing and placing diagrams
/---------------------------------------------------------*/
func draw(context: CGContextRef, bounds: CGRect, diagram: Diagram) {
  switch diagram {
  case .Prim(let size, .Ellipse):
    let frame = fit(Vector2D(x: 0.5, y: 0.5), size, bounds)
    CGContextFillEllipseInRect(context, frame)
  case .Prim(let size, .Rectangle):
    let frame = fit(Vector2D(x: 0.5, y: 0.5), size, bounds)
    CGContextFillRect(context, frame)
  case .Prim(let size, .Text(let text)):
    let frame = fit(Vector2D(x: 0.5, y: 0.5), size, bounds)
    let font = NSFont.systemFontOfSize(12)
    let attributes = [NSFontAttributeName: font]
    let attributedText = NSAttributedString(
      string: text, attributes: attributes)
    attributedText.drawInRect(frame)
  case .Attributed(.FillColor(let color), let d):
    CGContextSaveGState(context)
    color.set()
    draw(context, bounds, d.unbox)
    CGContextRestoreGState(context)
  case .Beside(let left, let right):
    let l = left.unbox
    let r = right.unbox
    let (lFrame, rFrame) = splitHorizontal(
      bounds, l.size/diagram.size)
    draw(context, lFrame, l)
    draw(context, rFrame, r)
  case .Below(let top, let bottom):
    let t = top.unbox
    let b = bottom.unbox
    let (lFrame, rFrame) = splitVertical(
      bounds, b.size/diagram.size)
    draw(context, lFrame, b)
    draw(context, rFrame, t)
  case .Align(let vec, let d):
    let diagram = d.unbox
    let frame = fit(vec, diagram.size, bounds)
    draw(context, frame, diagram)
  }
}


/*---------------------------------------------------------/
//  Drawing PDFs
/---------------------------------------------------------*/
class Draw: NSView {
  let diagram: Diagram
  
  init(frame frameRect: NSRect, diagram: Diagram) {
    self.diagram = diagram
    super.init(frame:frameRect)
  }
  
  required init(coder: NSCoder) {
    fatalError("NSCoding not supported")
  }
  
  override func drawRect(dirtyRect: NSRect) {
    if let context = NSGraphicsContext.currentContext() {
      draw(context.cgContext, self.bounds, diagram)
    }
  }
}


func pdf(diagram: Diagram, width: CGFloat) -> NSData {
  let unitSize = diagram.size
  let height = width * (unitSize.height/unitSize.width)
  let v: Draw = Draw(frame: NSMakeRect(0, 0, width, height),
    diagram: diagram)
  return v.dataWithPDFInsideRect(v.bounds)
}


/*---------------------------------------------------------/
//  Helpers Functions
/---------------------------------------------------------*/
func rect(#width: CGFloat, #height: CGFloat) -> Diagram {
  return Diagram.Prim(CGSizeMake(width, height), .Rectangle)
}

func circle(#diameter: CGFloat) -> Diagram {
  return Diagram.Prim(CGSizeMake(diameter, diameter), .Ellipse)
}

func text(#width: CGFloat,
  #height: CGFloat, text theText: String) -> Diagram {
    
    return Diagram.Prim(CGSizeMake(width, height), .Text(theText))
}

func square(#side: CGFloat) -> Diagram {
  return rect(width: side, height: side)
}


/*---------------------------------------------------------/
//  Helpers Operators
/---------------------------------------------------------*/
infix operator ||| { associativity left }
func ||| (l: Diagram, r: Diagram) -> Diagram {
  return Diagram.Beside(Box(l), Box(r))
}

infix operator --- { associativity left }
func --- (l: Diagram, r: Diagram) -> Diagram {
  return Diagram.Below(Box(l), Box(r))
}


/*---------------------------------------------------------/
//  Extensions for Filling and Alignment
/---------------------------------------------------------*/
extension Diagram {
  func fill(color: NSColor) -> Diagram {
    return Diagram.Attributed(Attribute.FillColor(color),
      Box(self))
  }
  
  func alignTop() -> Diagram {
    return Diagram.Align(Vector2D(x: 0.5, y: 1), Box(self))
  }
  
  func alignBottom() -> Diagram {
    return Diagram.Align(Vector2D(x:0.5, y: 0), Box(self))
  }
}


/*---------------------------------------------------------/
//  Helper for Horizontal Concatenation of Diagrams
/---------------------------------------------------------*/
let empty: Diagram = rect(width: 0, height: 0)

func hcat(diagrams: [Diagram]) -> Diagram {
  return diagrams.reduce(empty, combine: |||)
}


/*---------------------------------------------------------/
//  Examples: Shapes
/---------------------------------------------------------*/
let blueSquare = square(side: 1).fill(NSColor.blueColor())
let redSquare = square(side: 2).fill(NSColor.redColor())
let greenCircle = circle(diameter: 1).fill(NSColor.greenColor())
let example1 = blueSquare ||| redSquare ||| greenCircle
let cyanCircle = circle(diameter: 1).fill(NSColor.cyanColor())
let example2 = blueSquare ||| cyanCircle |||
  redSquare ||| greenCircle

func docDirURL() -> NSURL {
  return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
}

func docDirURLString() -> String {
  return "\(docDirURL())"
}

enum PDFResult {
  case Success
  case Error(String)
}

func writepdf(name: String, diagram: Diagram) -> PDFResult {
  let data = pdf(diagram, 300)
  var error: NSError? = nil
  
  // get URL to the the documents directory in the sandbox
  let documentsUrl = docDirURL()
  
  // add a filename
  let fileUrl = documentsUrl.URLByAppendingPathComponent("\(name).pdf")
//  println("PDF written to: \(fileUrl)")
  data.writeToURL(fileUrl, options: NSDataWritingOptions.AtomicWrite, error: &error)
  if let e = error {
    return PDFResult.Error(e.description)
  } else {
    return PDFResult.Success
  }
}

func verifyPDFWrite(name: String, diagram: Diagram) -> String {
  switch writepdf(name, diagram) {
  case PDFResult.Success:
    return "successfully written to \(docDirURLString())"
  case let PDFResult.Error(error):
    return error
  }
}

// PDF files are written to:
//docDirURLString()

//verifyPDFWrite("example1", example1)
//verifyPDFWrite("example2", example2)


/*---------------------------------------------------------/
//  Examples: Bar Graph
/---------------------------------------------------------*/
func barGraph(input: [(String, Double)]) -> Diagram {
  let values: [CGFloat] = input.map { CGFloat($0.1) }
  let nValues = normalize(values)
  let bars = hcat(nValues.map { (x: CGFloat) -> Diagram in
    return rect(width: 1, height: 3 * x)
      .fill(NSColor.blackColor()).alignBottom()
    })
  let labels = hcat(input.map { x in
    return text(width: 1, height: 0.3, text: x.0).alignTop()
    })
  return bars --- labels
}
let cities = ["Shanghai": 14.01, "Istanbul": 13.3,
  "Moscow": 10.56, "New York": 8.33, "Berlin": 3.43]
let example3 = barGraph(cities.keysAndValues)

//verifyPDFWrite("example3", example3)


/*---------------------------------------------------------/
//  More Examples
/---------------------------------------------------------*/
//verifyPDFWrite("example4", blueSquare ||| redSquare)
//verifyPDFWrite("example5", Diagram.Align(Vector2D(x: 0.5, y: 1), Box(blueSquare)) ||| redSquare)

