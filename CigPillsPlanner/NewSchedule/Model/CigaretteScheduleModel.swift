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
    
    @objc dynamic var reduceCig: Int = 0
    @objc dynamic var reducePerDay: Int = 0
    
    @objc dynamic var count: Int = 0
    
    @objc dynamic var isToday = true
    @objc dynamic var currentStringDate: String = ""
    
    @objc dynamic var lastTimeSmoke: Date? = nil
    
    
// MARK: - init
    
    func createNewSchedule(mark: String, price: Float, packSize: Int, scenario: String, limit: Int? = nil, interval: TimeInterval? = nil, reduce: (Int, Int) = (0, 0)) {
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
        DataManager.shared.add(schedule)
    }
    

// MARK: - Internal methods
    
    func increaceCount() {
        self.count += 1
        DataManager.shared.add(self)
    }
    
    func isTomorrow() {
        if isToday {
            isToday = false
        }
        DataManager.shared.add(self)
    }
    

// MARK: - Primary Key
    
    override class func primaryKey() -> String? {
        return "currentStringDate"
    }
    
}

