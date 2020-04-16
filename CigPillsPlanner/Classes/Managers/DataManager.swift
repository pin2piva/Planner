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
    
    static let shared = DataManager()
    
    private let realm = try! Realm()

    
    
    private func add<T: Object>(_ object: T) {
        try! realm.write {
            realm.add(object, update: .modified)
        }
    }

    // MARK: - CigaretteScheduleModel
    
    func createNewSchedule(mark: String,
                           price: Float,
                           packSize: Int,
                           scenario: String,
                           limit: Int? = nil,
                           interval: TimeInterval? = nil,
                           reduce: (Int, Int) = (0, 0),
                           lastTimeSmoke: Date? = nil) {
        let schedule = CigaretteScheduleModel()
        schedule.mark = mark
        schedule.price = price
        schedule.packSize = packSize
        schedule.scenario = scenario
        if let limit = limit {
            schedule.limit = RealmOptional(limit)
        }
        if let interval = interval {
            schedule.interval = RealmOptional(interval)
        }
        schedule.reduceCig = reduce.0
        schedule.reducePerDay = reduce.1
        schedule.currentStringDate = DateManager.shared.getStringDate(date: Date()) { "yyyy-MM-dd HH:mm" }
        schedule.lastTimeSmoke = lastTimeSmoke
        add(schedule)
    }
    
    func deleteYesterdaySchedule(_ schedule: CigaretteScheduleModel) {
        try! realm.write {
            realm.delete(schedule)
        }
    }
    
    func retrieveSchedulesFromDataBase() -> Results<CigaretteScheduleModel>? {
        return realm.objects(CigaretteScheduleModel.self)
    }
    
    func updateToYesterday(schedule: CigaretteScheduleModel) {
        try! realm.write {
            schedule.isToday = false
        }
    }
    
    func increaceTodayCount(for schedule: CigaretteScheduleModel) {
        try! realm.write {
            schedule.lastTimeSmoke = Date()
            schedule.todayScheduleCount += 1
        }
    }
    
    func getDescendingSortedSchedules() -> Results<CigaretteScheduleModel> {
        return realm.objects(CigaretteScheduleModel.self).sorted(byKeyPath: "currentStringDate", ascending: false)
    }
    
    
    // MARK: - MarkCounter
    
    func createMarkCounter(with mark: String,
                           _ price: Float) {
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
    
    
    // MARK: - DayliCouner
    
    private func createMarkDateCounter(with mark: String, and price: Float) -> MarkDateCounter {
        let markDateCounter = MarkDateCounter()
        markDateCounter.mark = mark
        markDateCounter.price = price
        return markDateCounter
    }
    
    func createDayliCounter(_ date: String, _ mark: String, _ price: Float) {
        let dayliCounter = DayliCounter()
        dayliCounter.dateString = date
        
        let markDateCounter = createMarkDateCounter(with: mark, and: price)
        
        dayliCounter.mark.append(markDateCounter)
        
        add(dayliCounter)
    }
    
    
    func increaceDayliCount(for schedule: CigaretteScheduleModel) {
        try! realm.write {
            guard let dayliCounter = getDayliCounter(for: schedule.currentStringDate) else { return }
            let markDateCounter: [MarkDateCounter] = dayliCounter.mark.filter({ $0.mark == schedule.mark })
            guard let markDateCounerWithPrice = markDateCounter.filter({ $0.price == schedule.price }).first else {
                let newMarkDateCounter = createMarkDateCounter(with: schedule.mark, and: schedule.price)
                newMarkDateCounter.mark = schedule.mark
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
        let dayliCounters = realm.objects(DayliCounter.self)
        let countersBeforeCurrentDate: [DayliCounter] = dayliCounters.filter({ $0.dateString <= date })
        let totalCount = countersBeforeCurrentDate.reduce(0, { $0 + $1.mark.reduce(0, { $0 + $1.count }) })
        return totalCount
    }
    
    
}
