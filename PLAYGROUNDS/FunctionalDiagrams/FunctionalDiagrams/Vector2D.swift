//
//  Vector2D.swift
//  FunctionalDiagrams
//
//  Created by Kyle Oba on 1/19/15.
//  Copyright (c) 2015 Pas de Chocolat. All rights reserved.
//

import Foundation


// A 2-D Vector
public struct Vector2D {
  let x: CGFloat
  let y: CGFloat
  
  var point : CGPoint { return CGPointMake(x, y) }
  
  var size : CGSize { return CGSizeMake(x, y) }
  
  public init(x: CGFloat, y: CGFloat) {
    self.x = x
    self.y = y
  }
}

public func *(m: CGFloat, v: Vector2D) -> Vector2D {
  return Vector2D(x: m * v.x, y: m * v.y)
}