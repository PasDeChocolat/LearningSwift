//
//  Draw.swift
//  FunctionalDiagrams
//
//  Created by Kyle Oba on 1/19/15.
//  Copyright (c) 2015 Pas de Chocolat. All rights reserved.
//

import Foundation


/*---------------------------------------------------------/
//  Drawing
/---------------------------------------------------------*/


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

public func splitVertical(rect: CGRect,
  ratio: CGSize) -> (CGRect, CGRect) {
    
    return splitRect(rect, ratio, CGRectEdge.MinYEdge)
}


func normalize(input: [CGFloat]) -> [CGFloat] {
  let maxVal = input.reduce(0) { max($0, $1) }
  return input.map { $0 / maxVal }
}




/*---------------------------------------------------------/
//  fit - Sizing and placing diagrams
/---------------------------------------------------------*/
public func fit(alignment: Vector2D,
  inputSize: CGSize, rect: CGRect) -> CGRect {
    
    let scaleSize = rect.size / inputSize
    let scale = min(scaleSize.width, scaleSize.height)
    let size = scale * inputSize
    let space = alignment.size * (size - rect.size)
    return CGRect(origin: rect.origin - space.point, size: size)
}


/*---------------------------------------------------------/
//  fit - Sizing and placing diagrams
/---------------------------------------------------------*/
public func draw(context: CGContextRef, bounds: CGRect, diagram: Diagram) {
  switch diagram {
  case .Prim(let size, .Ellipse):
    let frame = fit(Vector2D(x: 0.5, y: 0.5), size, bounds)
    CGContextFillEllipseInRect(context, frame)
  case .Prim(let size, .Rectangle):
    let frame = fit(Vector2D(x: 0.5, y: 0.5), size, bounds)
    CGContextFillRect(context, frame)
  case .Prim(let size, .Text(let text)):
    let frame = fit(Vector2D(x: 0.5, y: 0.5), size, bounds)
    //    let font = NSFont.systemFontOfSize(12)
    let font = UIFont.systemFontOfSize(12)
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
//  Helper for Horizontal Concatenation of Diagrams
/---------------------------------------------------------*/
let empty: Diagram = rect(width: 0, height: 0)

func hcat(diagrams: [Diagram]) -> Diagram {
  return diagrams.reduce(empty, combine: |||)
}

