import UIKit


/*
//  Drawing Polygons
//
//  Suggested Reading:
//  http://sketchytech.blogspot.com/2014/11/swift-stars-in-our-paths-cgpath.html
/===================================*/


/*---------------------------------------------------------/
//  Read the blog post above, but briefly we're going
//  to draw a some stars. The method used is to imagine
//  two concentric circles centered on the same point.
//  The the radius of the outer circle is equal to the
//  distance of the point tips from the center of the star.
//  The radius of the inner circle represents where points
//  of the star meet on converging between points.
//
//  The outer circle contains the points of an outer
//  polygon. The inner circle contains the points of an
//  inner polygon. The points on these polygons are 
//  connected in alternation, to for the path of the star.
/---------------------------------------------------------*/

func degree2radian(a:CGFloat)->CGFloat {
  let b = CGFloat(M_PI) * a/180
  return b
}

// Points of a regular polygon
func polygonPointArray(sides: Int, x: CGFloat, y: CGFloat, radius: CGFloat, adjustmentDegrees: CGFloat = 0) -> [CGPoint] {
  let angle = degree2radian(360 / CGFloat(sides))
  let cx = x // x origin
  let cy = y // y origin
  let r  = radius // radius of circle
  let delta = degree2radian(adjustmentDegrees)
  
  var points = [CGPoint]()
  for var i=sides; i>=0; i-- {
    let xpo = cx - r * cos(angle * CGFloat(i) + delta)
    let ypo = cy - r * sin(angle * CGFloat(i) + delta)
    points.append(CGPoint(x: xpo, y: ypo))
  }
  return points
}
polygonPointArray(4, 10, 10, 10)


// Create CGPath for star, by connecting points of inner and outer polygons,
// in alternation
func starPath(#x: CGFloat, #y: CGFloat, #outerRadius: CGFloat, #sides: Int, pointedness: CGFloat) -> CGPathRef {
  let adjustment = 360/sides/2
  let path = CGPathCreateMutable()
  let innerRadius = outerRadius / pointedness
  let innerPoints = polygonPointArray(sides,x,y,innerRadius)
  var cpg = innerPoints[0]
  let outerPoints = polygonPointArray(sides, x, y, outerRadius, adjustmentDegrees: CGFloat(adjustment))
  var i = 0
  CGPathMoveToPoint(path, nil, cpg.x, cpg.y)
  for var i=0; i<innerPoints.count; i++ {
    CGPathAddLineToPoint(path, nil, outerPoints[i].x, outerPoints[i].y)
    CGPathAddLineToPoint(path, nil, innerPoints[i].x, innerPoints[i].y)
  }
  CGPathCloseSubpath(path)
  return path
}


// Create BezierPath for star, via CGPath
func drawStarBezier(#x: CGFloat, #y: CGFloat, #outerRadius: CGFloat, #sides: Int, #pointedness:CGFloat) -> UIBezierPath {
  let path = starPath(x: x, y: y, outerRadius: outerRadius, sides: sides, pointedness)
  let bez = UIBezierPath(CGPath: path)
  return bez
}


// Display a star
func drawExampleStars() {
  for i in 5...10 {
    drawStarBezier(x: 0, y: 0, outerRadius: 30, sides: i,  pointedness:2)
  }
}
drawExampleStars()


