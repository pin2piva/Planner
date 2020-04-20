//
//  Scenario.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation

enum Scenario: String {
    case accountingOnly = "Accounting only" // только учет
    case withLimitAndReduce = "Accounting with limit and reduce" // фиксированное количество
    case withInterval = "Accounting with interval" // через заданные промежутки времени
    case withLimit = "Accounting with limit"
    case withLimitAndInterval = "Accounting with limit and interval"
    case withLimitAndIntervalAndReduce = "Accounting with limit, interval and reduce"
    
    static func getScenarioCase(from stringScenario: String) -> Scenario {
        switch stringScenario {
        case Scenario.accountingOnly.rawValue:
            return Scenario.accountingOnly
        case Scenario.withLimitAndReduce.rawValue:
            return Scenario.withLimitAndReduce
        case Scenario.withLimit.rawValue:
            return Scenario.withLimitAndReduce
        case Scenario.withLimitAndInterval.rawValue:
            return Scenario.withLimitAndInterval
        case Scenario.withInterval.rawValue:
            return Scenario.withInterval
        default:
            return Scenario.withLimitAndIntervalAndReduce
        }
    }
    
    static func getCurrentSelection(_ rawValue: String) -> (Bool, Bool, Bool) {
        switch rawValue {
        case self.accountingOnly.rawValue:
            return (false, false, false)
        case self.withLimitAndReduce.rawValue:
            return (true, false, true)
        case self.withInterval.rawValue:
            return (false, true, false)
        case self.withLimit.rawValue:
            return (true, false, false)
        case self.withLimitAndInterval.rawValue:
            return (true, true, false)
        case self.withLimitAndIntervalAndReduce.rawValue:
            return (true, true, true)
        default:
            return (false, false, false)
        }
    }
    
    static func getScenario(_ limitIsOn: Bool, _ intervalIsOn: Bool, _ reduceIsOn: Bool) -> String {
        if !limitIsOn && !intervalIsOn && !reduceIsOn {
            return Scenario.accountingOnly.rawValue
        } else if limitIsOn && reduceIsOn && !intervalIsOn {
            return Scenario.withLimitAndReduce.rawValue
        } else if !limitIsOn && !reduceIsOn && intervalIsOn {
            return Scenario.withInterval.rawValue
        } else if limitIsOn && !reduceIsOn && !intervalIsOn {
            return Scenario.withLimit.rawValue
        } else if limitIsOn && !reduceIsOn && intervalIsOn {
            return Scenario.withLimitAndInterval.rawValue
        } else {
            return Scenario.withLimitAndIntervalAndReduce.rawValue
        }
    }
    
    
}
