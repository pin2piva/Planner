//
//  DayliDataManager.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/8/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation
import RealmSwift

class DayliDataManager {
  
  // MARK: - Static properties
  
  
  static let shared = DayliDataManager()
  
  // MARK: - Private Properties
  
  
  private let realm = try! Realm()
  var dayliCounters: Results<DayliCounter> {
    return realm.objects(DayliCounter.self)
  }
  
  // MARK: - Private func
  
  
  private func create(_ object: DayliCounter) {
    try! realm.write {
//      realm.add(object, update: .modified)
      realm.create(DayliCounter.self, value: object, update: .modified)
    }
  }

  // MARK: - Create/Delete
  
  
  private func createMarkDateCounterWith(mark: String, price: Double, perPack: Int) -> MarkDateCounter {
    let markDateCounter = MarkDateCounter()
    markDateCounter.mark = mark
    markDateCounter.price = price
    markDateCounter.perPack = perPack
    return markDateCounter
  }
  
  func createDayliCounter(date: String, mark: String, price: Double, perPack: Int) {
    let dayliCounter = DayliCounter()
    dayliCounter.dateString = date
    if ScheduleDataManager.shared.getDescendingSortedSchedules().count <= 1 &&
      dayliCounter.mark.count == 0 {
      let firstMarkDateCounter = createMarkDateCounterWith(mark: mark, price: price, perPack: perPack)
      dayliCounter.mark.append(firstMarkDateCounter)
    }
    create(dayliCounter)
  }
  
  func deleteEmptyMarkDateCountersFromCurrent() {
    try! realm.write {
      let current = ScheduleDataManager.shared.getMarkAndPriceForCurrentDate()
      guard let stringDate = current.stringDate, let mark = current.mark, let price = current.price else { return }
      guard let dayliCounter = getDayliCounter(for: stringDate) else { return }
      let markDateCounters = dayliCounter.mark.enumerated().filter({ $0.element.count == 0 && $0.element.mark != mark && $0.element.price != price })
      markDateCounters.forEach({ dayliCounter.mark.remove(at: $0.offset) })
    }
  }

  func deleteDayliCounter(_ counter: DayliCounter) {
    try! realm.write {
      realm.delete(counter)
    }
  }
  
  // MARK: - Increment
  
  
  func increaceDayliCount(for schedule: CigaretteScheduleModel) {
    try! realm.write {
      guard let dayliCounter = getDayliCounter(for: schedule.currentStringDate) else { return }
      let markDateCounter: [MarkDateCounter] = dayliCounter.mark.filter({ $0.mark == schedule.mark })
      guard let markDateCounerWithPrice = markDateCounter.filter({ $0.price == schedule.price }).first else {
        let newMarkDateCounter = createMarkDateCounterWith(mark: schedule.mark, price: schedule.price, perPack: schedule.packSize)
        newMarkDateCounter.mark = schedule.mark
        newMarkDateCounter.price = schedule.price
        newMarkDateCounter.count += 1
        dayliCounter.mark.append(newMarkDateCounter)
        return
      }
      markDateCounerWithPrice.count += 1
    }
  }
  
  // MARK: - Get DayliCounter
  
  func getFirstDayliCounter() -> DayliCounter {
    return dayliCounters.first!
  }
  
  func getLastPrice() -> String? {
    guard let lastPrice = dayliCounters.reduce([Double](), { $0 + $1.mark.map({ $0.price }) }).last else { return nil }
    return String(lastPrice)
  }
  
  func getLastMark() -> String? {
    let lastMark = dayliCounters.reduce([String](), { $0 + $1.mark.map({ $0.mark }) }).last
    return lastMark
  }
  
  func getDayliCounter(for date: String) -> DayliCounter? {
    let dayliCounter = realm.object(ofType: DayliCounter.self, forPrimaryKey: date)
    return dayliCounter
  }
  
  func getDayliCounters(fromDate: Date, toDate: Date) -> [DayliCounter] {
    let fromDateString = DateManager.shared.getStringDate(date: fromDate) { DateManager.dateStringFormat }
    let toDateString = DateManager.shared.getStringDate(date: toDate) { DateManager.dateStringFormat }
    let counters: [DayliCounter] = dayliCounters.filter({ $0.dateString >= fromDateString && $0.dateString <= toDateString })
    return counters
  }
  
  // MARK: - Get values
  
  func getDayliCount(for date: String) -> Int {
    guard let dayliCounter = getDayliCounter(for: date) else { return 0 }
    let count = dayliCounter.mark.reduce(0, { $0 + $1.count })
    return count
  }
  
  func isQuit() -> Bool {
    guard dayliCounters.count > 10 else { return false }
    let count = dayliCounters.count
    let countInterval = count - 11...(count - 2)
    let counters: [DayliCounter] = dayliCounters[countInterval].map({ $0 })
    print(counters.map({ $0.mark.reduce(0, { $0 + $1.count }) }))
    guard counters.map({ $0.mark.reduce(0, { $0 + $1.count }) }) == Array(repeating: 1, count: 10) else { return false }
    return true
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

}
