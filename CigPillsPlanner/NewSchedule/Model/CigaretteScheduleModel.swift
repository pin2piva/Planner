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
    
    @objc dynamic var todayScheduleCount: Int = 0
    
    @objc dynamic var isToday = true
    @objc dynamic var currentStringDate: String = ""
    
    @objc dynamic var lastTimeSmoke: Date? = nil

// MARK: - Primary Key
    
    override class func primaryKey() -> String? {
        return "currentStringDate"
    }
    
}

