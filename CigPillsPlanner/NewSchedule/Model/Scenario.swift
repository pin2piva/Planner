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
    case withLimitAndIntervalAndReduce = "Accounting with limit, interval and reduce"
}
