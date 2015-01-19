//
//  Dictionary.swift
//  FunctionalDiagrams
//
//  Created by Kyle Oba on 1/19/15.
//  Copyright (c) 2015 Pas de Chocolat. All rights reserved.
//

import Foundation


extension Dictionary {
  var keysAndValues: [(Key, Value)] {
    var result: [(Key, Value)] = []
    for item in self {
      result.append(item)
    }
    return result
  }
}