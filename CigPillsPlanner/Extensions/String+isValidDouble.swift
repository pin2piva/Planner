//
//  String+isValidDouble.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 5/1/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation

extension String {
  
  func isValidDouble(maxDecimalPlaces: Int) -> Bool {
    let formatter = NumberFormatter()
    formatter.allowsFloats = true
    let decimalSeparator = formatter.decimalSeparator ?? "."
    if formatter.number(from: self) != nil {
      let split = self.components(separatedBy: decimalSeparator)
      let digits = split.count == 2 ? split.last ?? "" : ""
      return digits.count <= maxDecimalPlaces
    }
    return false
  }
  
}
