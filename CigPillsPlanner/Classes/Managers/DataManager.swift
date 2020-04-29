//
//  DataManager.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/8/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation
import RealmSwift

class DataManager {
  
  // MARK: - Static properties
  
  
  static let shared = DataManager()
  
  // MARK: - Private Properties
  
  
  private let realm = try! Realm()
  private var dayliCounters: Results<DayliCounter> {
    realm.objects(DayliCounter.self)
  }
  
  // MARK: - Common private func
  
  
  private func add<T: Object>(_ object: T) {
    try! realm.write {
      realm.add(object, update: .modified)
    }
  }
  
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
    schedule.mark = mark
    schedule.price = price
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
  
  // MARK: - MarkCounter internal func
  
  
  func createMarkCounter(with mark: String,
                         _ price: Double) {
    let markCounter = MarkCounter()
    markCounter.mark = mark.lowercased()
    let counter = PriceMarkCounter()
    counter.price = String(price)
    markCounter.counter.append(counter)
    
    add(markCounter)
  }
  
  func increaceMarkCount(for schedule: CigaretteScheduleModel) {
    try! realm.write {
      guard let markCounter = getMarkCounter(for: schedule.mark) else { return }
      let priceMarkCounters: [PriceMarkCounter] = markCounter.counter.filter({ $0.price == String(schedule.price) })
      guard let priceMarkCounter = priceMarkCounters.first else {
        let newPriceMarkCounter = PriceMarkCounter()
        newPriceMarkCounter.price = String(schedule.price)
        newPriceMarkCounter.markCount += 1
        markCounter.counter.append(newPriceMarkCounter)
        return
      }
      priceMarkCounter.markCount += 1
    }
  }
  
  func getMarkCounter(for mark: String) -> MarkCounter? {
    let markCounter = realm.object(ofType: MarkCounter.self, forPrimaryKey: mark.lowercased())
    return markCounter
  }
  
  func getTotalCigCount() -> Int {
    let markCounters = realm.objects(MarkCounter.self)
    
    let totalCount = markCounters.reduce([Int](), { $0 + $1.counter.map({ $0.markCount }) }).reduce(0, { $0 + $1 })
    return totalCount
  }
  
  // MARK: - DayliCouner internal func
  
  
  private func createMarkDateCounterWith(mark: String, price: Double, perPack: Int) -> MarkDateCounter {
    let markDateCounter = MarkDateCounter()
    markDateCounter.mark = mark.lowercased()
    markDateCounter.price = price
    markDateCounter.perPack = perPack
    return markDateCounter
  }
  
  func createDayliCounter(date: String, mark: String, price: Double, perPack: Int) {
    let dayliCounter = DayliCounter()
    dayliCounter.dateString = date
    
    let markDateCounter = createMarkDateCounterWith(mark: mark, price: price, perPack: perPack)
    
    dayliCounter.mark.append(markDateCounter)
    
    add(dayliCounter)
  }
  
  func increaceDayliCount(for schedule: CigaretteScheduleModel) {
    try! realm.write {
      guard let dayliCounter = getDayliCounter(for: schedule.currentStringDate) else { return }
      let markDateCounter: [MarkDateCounter] = dayliCounter.mark.filter({ $0.mark == schedule.mark.lowercased() })
      guard let markDateCounerWithPrice = markDateCounter.filter({ $0.price == schedule.price }).first else {
        let newMarkDateCounter = createMarkDateCounterWith(mark: schedule.mark, price: schedule.price, perPack: schedule.packSize)
        newMarkDateCounter.mark = schedule.mark.lowercased()
        newMarkDateCounter.price = schedule.price
        newMarkDateCounter.count += 1
        dayliCounter.mark.append(newMarkDateCounter)
        return
      }
      markDateCounerWithPrice.count += 1
    }
  }
  
  func getDayliCounter(for date: String) -> DayliCounter? {
    let dayliCounter = realm.object(ofType: DayliCounter.self, forPrimaryKey: date)
    return dayliCounter
  }
  
  func getDayliCount(for date: String) -> Int {
    guard let dayliCounter = getDayliCounter(for: date) else { return 0 }
    let count = dayliCounter.mark.reduce(0, { $0 + $1.count })
    return count
  }
  
  func getTotalCountBeforeCurrent(date: String) -> Int {
    let countersBeforeCurrentDate: [DayliCounter] = dayliCounters.filter({ $0.dateString <= date })
    let totalCount = countersBeforeCurrentDate.reduce(0, { $0 + $1.mark.reduce(0, { $0 + $1.count }) })
    return totalCount
  }
  
  func getTotalCount() -> Int {
    let totalCount = dayliCounters.reduce(0, { $0 + $1.mark.reduce(0, { $0 + $1.count }) })
    return totalCount
  }
  
  func getTotalPrice() -> Double {
    let totalPrice = dayliCounters.reduce(0, { $0 + $1.mark.reduce(0, { $0 + ($1.price / Double($1.perPack) * Double($1.count)) }) })
    return totalPrice
  }
  
  func getTotalPriceFor(mark: String) -> Double {
    let totalPriceForMark = dayliCounters.reduce(0, { $0 + $1.mark.filter({ $0.mark == mark.lowercased() }).reduce(0, { $0 + ($1.price / Double($1.perPack) * Double($1.count)) }) })
    return totalPriceForMark
  }
  
  func getTotalCountFor(mark: String) -> Int {
    let totalCountForMark = dayliCounters.reduce(0, { $0 + $1.mark.filter({ $0.mark == mark.lowercased() }).reduce(0, { $0 + $1.count }) })
    return totalCountForMark
  }
  
}
