//
//  MarkCounter.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation
import RealmSwift

class MarkCounter: Object {
  
  @objc dynamic var mark: String = ""
  let counter = List<PriceMarkCounter>()
  
  override class func primaryKey() -> String? {
    return "mark"
  }
  
}

class PriceMarkCounter: Object {
  
  @objc dynamic var price: String = ""
  @objc dynamic var markCount: Int = 0
  @objc dynamic var perPack: Int = 0
  
}



