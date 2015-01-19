//
//  CGSize.swift
//  FunctionalDiagrams
//
//  Created by Kyle Oba on 1/19/15.
//  Copyright (c) 2015 Pas de Chocolat. All rights reserved.
//

import Foundation


extension CGSize {
  var point : CGPoint {
    return CGPointMake(self.width, self.height)
  }
}