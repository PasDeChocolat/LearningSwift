//
//  CGRect.swift
//  FunctionalDiagrams
//
//  Created by Kyle Oba on 1/19/15.
//  Copyright (c) 2015 Pas de Chocolat. All rights reserved.
//

import Foundation


extension CGRect {
  public init(center: CGPoint, size: CGSize) {
    let origin = CGPointMake(center.x - size.width/2,
      center.y - size.height/2)
    self.init(origin: origin, size: size)
  }
}