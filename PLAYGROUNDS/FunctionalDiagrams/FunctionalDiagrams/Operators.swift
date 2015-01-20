//
//  Operators.swift
//  FunctionalDiagrams
//
//  Created by Kyle Oba on 1/19/15.
//  Copyright (c) 2015 Pas de Chocolat. All rights reserved.
//

import Foundation


/*---------------------------------------------------------/
//  Operators
/---------------------------------------------------------*/
public func *(l: CGPoint, r: CGRect) -> CGPoint {
  return CGPointMake(r.origin.x + l.x*r.size.width,
    r.origin.y + l.y*r.size.height)
}

public func *(l: CGFloat, r: CGPoint) -> CGPoint {
  return CGPointMake(l*r.x, l*r.y)
}
public func *(l: CGFloat, r: CGSize) -> CGSize {
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

public func /(l: CGSize, r: CGSize) -> CGSize {
  return pointWise(/, l, r)
}
public func *(l: CGSize, r: CGSize) -> CGSize {
  return pointWise(*, l, r)
}
public func +(l: CGSize, r: CGSize) -> CGSize {
  return pointWise(+, l, r)
}
public func -(l: CGSize, r: CGSize) -> CGSize {
  return pointWise(-, l, r)
}

public func -(l: CGPoint, r: CGPoint) -> CGPoint {
  return pointWise(-, l, r)
}
public func +(l: CGPoint, r: CGPoint) -> CGPoint {
  return pointWise(+, l, r)
}
public func *(l: CGPoint, r: CGPoint) -> CGPoint {
  return pointWise(*, l, r)
}


/*---------------------------------------------------------/
//  Helpers Operators
/---------------------------------------------------------*/
infix operator ||| { associativity left }
public func ||| (l: Diagram, r: Diagram) -> Diagram {
  return Diagram.Beside(Box(l), Box(r))
}

infix operator --- { associativity left }
public func --- (l: Diagram, r: Diagram) -> Diagram {
  return Diagram.Below(Box(l), Box(r))
}


