//
//  Diagrams.swift
//  FunctionalDiagrams
//
//  Created by Kyle Oba on 1/19/15.
//  Copyright (c) 2015 Pas de Chocolat. All rights reserved.
//

import Foundation


/*---------------------------------------------------------/
//  Core Data Primitives
/---------------------------------------------------------*/
public enum Primitive {
  case Ellipse
  case Rectangle
  case Text(String)
}


/*---------------------------------------------------------/
//  Diagram
/---------------------------------------------------------*/
public enum Diagram {
  case Prim(CGSize, Primitive)
  case Beside(Box<Diagram>, Box<Diagram>)
  case Below(Box<Diagram>, Box<Diagram>)
  case Attributed(Attribute, Box<Diagram>)
  case Align(Vector2D, Box<Diagram>)
}


/*---------------------------------------------------------/
//  Attribute
/---------------------------------------------------------*/
public enum Attribute {
  //  case FillColor(NSColor)
  case FillColor(UIColor)
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
//  Extensions for Filling and Alignment
/---------------------------------------------------------*/
extension Diagram {
  //  func fill(color: NSColor) -> Diagram {
  public func fill(color: UIColor) -> Diagram {
    return Diagram.Attributed(Attribute.FillColor(color),
      Box(self))
  }
  
  public func alignTop() -> Diagram {
    return Diagram.Align(Vector2D(x: 0.5, y: 0), Box(self))
  }
  
  public func alignBottom() -> Diagram {
    return Diagram.Align(Vector2D(x:0.5, y: 1), Box(self))
  }
}


/*---------------------------------------------------------/
//  Helpers Functions
/---------------------------------------------------------*/
public func rect(#width: CGFloat, #height: CGFloat) -> Diagram {
  return Diagram.Prim(CGSizeMake(width, height), .Rectangle)
}

public func circle(#diameter: CGFloat) -> Diagram {
  return Diagram.Prim(CGSizeMake(diameter, diameter), .Ellipse)
}

public func text(#width: CGFloat,
  #height: CGFloat, text theText: String) -> Diagram {
    
    return Diagram.Prim(CGSizeMake(width, height), .Text(theText))
}

public func square(#side: CGFloat) -> Diagram {
  return rect(width: side, height: side)
}
