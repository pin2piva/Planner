//
//  PackModel.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation
import RealmSwift

class PackModel: Object {
    @objc dynamic var mark: String = ""
    @objc dynamic var price: Float = 0
    @objc dynamic var piecesInPack: Int = 0
    
    convenience init(mark: String, price: Float, perPack: Int) {
        self.init()
        self.mark = mark
        self.price = price
        self.piecesInPack = perPack
    }
    
}
