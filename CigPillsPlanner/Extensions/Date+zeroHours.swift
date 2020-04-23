//
//  Date+zeroHours.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/23/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation

extension Date {
  
  var zeroHours: Date? {
    get {
      let calendar = Calendar.current
      let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
      return calendar.date(from: dateComponents)
    }
  }
  
}
