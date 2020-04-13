//
//  MarkCounter.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation
import RealmSwift


class MarkCounter: Object {
    
    @objc dynamic var mark: String = ""
    let counter = List<Count>()
    
    func createMarkCounter(mark: String, price: Float) {
        let markCounter = MarkCounter()
        markCounter.mark = mark
        let count = Count()
        count.price = String(price)
        markCounter.counter.append(count)
    }
    
    override class func primaryKey() -> String? {
        return "mark"
    }
    
}

class Count: Object {
    
    @objc dynamic var price: String = ""
    @objc dynamic var markCount: Int = 0
    
    override class func primaryKey() -> String? {
        return "price"
    }
    
}


//    @objc dynamic var scenario = ""
//
//    var limit = RealmOptional<Int>()
//    var interval = RealmOptional<Double>()
//
//    @objc dynamic var reduceCig: Int = 0
//    @objc dynamic var reducePerDay: Int = 0
//
//    @objc dynamic var startDate = Date()
//    @objc dynamic var totalCount: Int = 0


