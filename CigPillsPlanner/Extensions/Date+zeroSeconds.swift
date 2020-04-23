//
//  Date+zeroSeconds.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/23/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation

extension Date {
  
  var zeroSeconds: Date? {
    get {
      let calendar = Calendar.current
      let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
      return calendar.date(from: dateComponents)
    }
  }
  
}
