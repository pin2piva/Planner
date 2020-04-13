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
    
    
    func updateDayliCounter() {
        
    }
    
    func updateMarkCounter() {
        
    }

    
    func add(_ schedule: CigaretteScheduleModel) {
        try! realm.write {
            realm.add(schedule, update: .modified)
        }
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
    
    func getDescendingSortedSchedules() -> Results<CigaretteScheduleModel> {
        return realm.objects(CigaretteScheduleModel.self).sorted(byKeyPath: "currentStringDate", ascending: false)
    }
    
}
