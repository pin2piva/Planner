//
//  String+isValidInt.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 5/1/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation

extension String {
  
  func isValidInt() -> Bool {
    if Int(self) != nil {
      return true
    } else {
      return false
    }
  }
  
}
