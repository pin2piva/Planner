//
//  ScheduleDataManager.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/30/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation
import RealmSwift

class ScheduleDataManager {
  
  // MARK: - Static properties
  
  static let shared = ScheduleDataManager()
  
  // MARK: - Private properties
  
  
  private let realm = try! Realm()
  
  // MARK: - Schedule internal func
  
  
  func createNewSchedule(mark: String,
                         price: Double,
                         packSize: Int,
                         scenario: String,
                         limit: Int?,
                         interval: TimeInterval?,
                         reduceCig: Int?,
                         reducePerDay: Int?,
                         beginReduceDate: Date? = nil,
                         lastTimeSmoke: Date? = nil) {
    let schedule = CigaretteScheduleModel()
    schedule.mark = mark.uppercased()
    schedule.price = price.twoDecimalPlaces
    schedule.packSize = packSize
    schedule.scenario = scenario
    schedule.lastTimeSmoke = lastTimeSmoke
    schedule.currentStringDate = DateManager.shared.getStringDate(date: Date()) { DateManager.dateStringFormat }
    schedule.beginReduceDate = beginReduceDate
    if var limit = limit {
      if let reduceCig = reduceCig, let reducePerDay = reducePerDay  {
        schedule.reduceCig = RealmOptional(reduceCig)
        schedule.reducePerDay = RealmOptional(reducePerDay)
        if  schedule.beginReduceDate != nil {
          let newLimit = getReduce(from: beginReduceDate, with: reduceCig, reducePerDay, limit: limit)
          if let newLimit = newLimit {
            limit = newLimit
            schedule.beginReduceDate = Date().zeroSeconds
          }
        } else {
          schedule.beginReduceDate = Date().zeroSeconds
        }
      } else {
        schedule.beginReduceDate = nil
      }
      schedule.limit = RealmOptional(limit)
    }
    if let interval = interval {
      schedule.interval = RealmOptional(interval)
      if let lastTime = lastTimeSmoke {
        if Date() <= Date(timeInterval: interval, since: lastTime) {
          schedule.timerIsActive = true
        } else {
          schedule.timerIsActive = false
        }
      }
    }
    add(schedule)
  }
  
  func timer(activate: Bool, for schedule: CigaretteScheduleModel) {
    try! realm.write {
      schedule.timerIsActive = activate
    }
  }
  
  func setLastTime(for schedule: CigaretteScheduleModel) {
    try! realm.write {
      schedule.lastTimeSmoke = Date()
    }
  }
  
  func getMarkAndPriceForCurrentDate() -> (stringDate: String, mark: String, price: Double) {
    let currentDate = Date()
    let currentStringDate = DateManager.shared.getStringDate(date: currentDate) { DateManager.dateStringFormat }
    let currentSchedule = realm.object(ofType: CigaretteScheduleModel.self, forPrimaryKey: currentStringDate)
    return (currentSchedule!.currentStringDate, currentSchedule!.mark, currentSchedule!.price)
  }
  
  func deleteSchedule(_ schedule: CigaretteScheduleModel) {
    try! realm.write {
      realm.delete(schedule)
    }
  }
  
  func updateToYesterday(schedule: CigaretteScheduleModel) {
    try! realm.write {
      schedule.isToday = false
      schedule.timerIsActive = false
    }
  }
  
  func getDescendingSortedSchedules() -> Results<CigaretteScheduleModel> {
    return realm.objects(CigaretteScheduleModel.self).sorted(byKeyPath: "currentStringDate", ascending: false)
  }
  
  // MARK: - Schedule private func
  
  
  private func add(_ object: CigaretteScheduleModel) {
    try! realm.write {
      realm.add(object, update: .modified)
    }
  }
  
  private func get(limit: Int, after reduce: Int) -> Int {
    var newLimit = limit
    for _ in 0..<reduce {
      if newLimit > 1 {
        newLimit -= 1
      } else {
        break
      }
    }
    return newLimit
  }
  
  private func getReduce(from begin: Date?, with reduceCig: Int, _ reducePerDay: Int, limit: Int) -> Int? {
    let quotientReduce = DateManager.shared.checkReduce(from: begin, reducePerDay: reducePerDay, limit: limit)
    guard let quotient = quotientReduce else { return nil }
    var newLimit = limit
    for _ in 0..<quotient {
      newLimit = get(limit: newLimit, after: reduceCig)
    }
    return newLimit
  }
}
