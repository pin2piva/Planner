//
//  CigaretteScheduleModel.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation
import RealmSwift

class CigaretteScheduleModel: Object {
  
  
  // MARK: - Properties
  
  @objc dynamic var mark: String = ""
  @objc dynamic var price: Float = 0
  @objc dynamic var packSize: Int = 0
  
  @objc dynamic var scenario: String = "Accounting only"
  
  var limit = RealmOptional<Int>()
  
  var interval = RealmOptional<Double>()
  @objc dynamic var timerIsActive: Bool = false
  
  var reduceCig = RealmOptional<Int>()
  var reducePerDay = RealmOptional<Int>()
  @objc dynamic var beginReduceDate: Date? = nil
  
  @objc dynamic var isToday: Bool = true
  @objc dynamic var currentStringDate: String = ""
  
  @objc dynamic var lastTimeSmoke: Date? = nil
  
  
  // MARK: - Internal func
  
  func overLimit() -> String? {
    guard isToday else { return nil }
    guard let limit = limit.value else { return nil }
    let dayliCount = DataManager.shared.getDayliCount(for: currentStringDate)
    guard limit < dayliCount else { return nil }
    return "Limit exceeded"
  }
  
  func getTimer(isActive: Bool) {
    DataManager.shared.timer(activate: isActive, for: self)
  }
  
  func getLastTime() {
    DataManager.shared.setLastTime(for: self)
  }
  
  func incrementCount() {
    DataManager.shared.increaceMarkCount(for: self)
    DataManager.shared.increaceDayliCount(for: self)
  }
  
  
  // MARK: - Primary Key
  
  override class func primaryKey() -> String? {
    return "currentStringDate"
  }
  
}

