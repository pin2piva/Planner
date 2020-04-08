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
    
    @objc dynamic var pack: PackModel?
    @objc dynamic var scenario: String = "Accounting only"
    
    var limit = RealmOptional<Int>()
    
    var interval = RealmOptional<Double>()
    
    @objc dynamic var reduceCig: Int = 0
    @objc dynamic var reducePerDay: Int = 0
    
    @objc dynamic var counter: Int = 0
    
    @objc dynamic var currentDate = Date()
    
    @objc dynamic var firstReception: Date? = nil
    @objc dynamic var lastReception: Date? = nil
    
    convenience init(pack: PackModel, scenario: Scenario, limit: Int? = nil, interval: TimeInterval? = nil, reduce: (Int, Int) = (0, 0)) {
        self.init()
        self.pack = pack
        self.scenario = scenario.rawValue
        if let limit = limit {
            self.limit = RealmOptional(limit)
        }
        if let interval = interval {
            self.interval = RealmOptional(interval)
        }
        self.reduceCig = reduce.0
        self.reducePerDay = reduce.1
    }
    
    
// MARK: - Func
    

//
//    func getDateString(date: WhatDate) -> String? {
//        switch date {
//        case .current:
//            return getDateFormatter({ "dd.MM.yyyy HH:mm" }).string(from: currentDate)
//        case .reception:
//            guard let reception = firstReception else { return nil }
//            return getDateFormatter({ "HH:mm" }).string(from: reception)
//        case .next:
//            return getDateFormatter({ "HH:mm" }).string(from: getNextTime(after: "02:00"))
//        }
//
//    }
//
//    private func getDateFormatter(_ format: () -> String) -> DateFormatter {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale.current
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.dateFormat = format()
//        return dateFormatter
//    }
//
//    func getNextTime(after interval: String) -> Date {
//        let dateFormatter = getDateFormatter({ "HH:mm" })
//        let intervalDate = dateFormatter.date(from: interval)
//        let components = Calendar.current.dateComponents([.hour, .minute], from: intervalDate!)
//        let newDate = dateFormatter.calendar.date(byAdding: components, to: counter == 1 ? firstReception! : lastReception!)
//        return newDate!
//    }
    
}

