//
//  DayliCounter.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/9/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation
import RealmSwift

class DayliCounter: Object {
  
  @objc dynamic var dateString: String = ""
  let mark = List<MarkDateCounter>()
  
  override class func primaryKey() -> String? {
    return "dateString"
  }
  
}

class MarkDateCounter: Object {
  
  @objc dynamic var mark: String = ""
  @objc dynamic var count: Int = 0
  @objc dynamic var price: Double = 0
  @objc dynamic var perPack: Int = 0
  
  func getSpent() -> Double {
    return price / Double(perPack) * Double(count)
  }
  
}
