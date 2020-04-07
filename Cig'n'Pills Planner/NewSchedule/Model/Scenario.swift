//
//  Scenario.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation

enum Scenario {
    case accountingOnly // только учет
    case withLimitAndReduce // фиксированное количество
    case withInterval // через заданные промежутки времени
    case withLimitAndIntervalAndReduce
}
