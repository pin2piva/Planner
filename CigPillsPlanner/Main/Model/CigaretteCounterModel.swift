//
//  CigaretteCounterModel.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation
import RealmSwift

class CigaretteCounterModel: Object {
    
    let counter = List<CigaretteScheduleModel>()
    @objc dynamic var startDate = Date()
    @objc dynamic var totalCount: Int = 0
//    @objc dynamic var markCount: Data? = nil
//
}
//
//class MarkCounter: Object {
//    @objc dynamic var mark: String = ""
//    @objc dynamic var count: Int = 0
//}
