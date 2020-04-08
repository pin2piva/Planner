//
//  CigaretteScheduleModel.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation

struct CigaretteSheduleModel {
    
//    enum WhatDate {
//        case current
//        case reception
//        case next
//    }
    
// MARK: - Properties
    
    var pack: PackModel
    var perDay: Int?
    var interval: TimeInterval?
    var reduce: (Int, Int)
    
    let currentDate: Date = Date()
    var counter: Int = 0 {
        didSet {
            guard let perDay = perDay else { return }
            if counter == perDay {
                print("Вы выкурили запланированное количество сигарет")
            } else if counter > perDay {
                print("Вы превысили установленную норму в \(perDay)")
            }
        }
    }
    var firstReception: Date?
    var lastReception: Date?
    let scenario: Scenario
    
// MARK: - Initializators
    
    init(pack: PackModel, perDay: Int? = nil, interval: TimeInterval? = nil, reduce: (Int, Int) = (0, 0), scenario: Scenario) {
        self.pack = pack
        self.perDay = perDay
        self.interval = interval
        self.reduce = reduce
        self.scenario = scenario
    }
    
// MARK: - Func
    
    mutating func increaseCount() {
        setReception()
        counter += 1
    }

    private mutating func setReception() {
        if counter == 0 && firstReception == nil {
            firstReception = Date()
        } else if counter > 0 && firstReception != nil {
            lastReception = Date()
        }
    }
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

