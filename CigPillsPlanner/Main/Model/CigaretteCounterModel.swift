//
//  CigaretteCounterModel.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation

class CigaretteSheduleStorageModel {
    
    var counter = [CigaretteSheduleModel]()
    var startDate: Date = Date()
    
    func getTotalCount() -> Int {
        guard counter.count > 0 else { return 0 }
        return counter.reduce(0, { $0 + $1.counter })
    }
    
    func getTotalPrice() -> Float {
        guard counter.count > 0 else { return 0 }
        return counter.reduce(0, { $0 + $1.pack.price * Float($1.counter) / Float($1.pack.piecesInPack) })
    }
    
}
