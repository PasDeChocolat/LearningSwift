//
//  Box.swift
//  FunctionalDiagrams
//
//  Created by Kyle Oba on 1/19/15.
//  Copyright (c) 2015 Pas de Chocolat. All rights reserved.
//

import Foundation


/*---------------------------------------------------------/
//  Box, used to wrap types when recursive definitions
//  are required. Deprecate when Swift supports enums
//  which have a recursive enum `case`.
/---------------------------------------------------------*/
public class Box<T> {
  public let unbox: T
  public init(_ value: T) { self.unbox = value }
}