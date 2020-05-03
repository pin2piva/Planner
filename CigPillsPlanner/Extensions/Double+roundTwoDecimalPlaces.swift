//
//  Double+StringTwoDecimalPlaces.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/30/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation

extension Double {
  
  var roundTwoDecimalPlaces: Double {
    return (self * 100).rounded() / 100
  }
  
}
