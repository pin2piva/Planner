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
    
    func saveObject(_ cigCounter: CigaretteCounterModel) {
        try! realm.write {
            realm.add(cigCounter)
        }
    }
    
    func insertNewObject(_ cigCounter: CigaretteCounterModel, model: CigaretteScheduleModel) {
        try! realm.write {
            cigCounter.counter.insert(model, at: 0)
        }
    }
    
    func updateCountInObject(cigCounter: CigaretteCounterModel) {
        try! realm.write {
            cigCounter.counter[0].counter += 1
            cigCounter.totalCount += 1
            cigCounter.counter[0].lastReception = Date()
            
        }
    }
    
    func deleteCigSchedule(_ cigCounter: CigaretteCounterModel, indexPath: IndexPath) {
        try! realm.write {
            cigCounter.counter.remove(at: indexPath.row)
        }
    }
    
    func retrieveCigCounterFromDataBase() -> Results<CigaretteCounterModel>? {
        return realm.objects(CigaretteCounterModel.self)
    }
    
}
