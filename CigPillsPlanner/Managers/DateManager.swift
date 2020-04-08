//
//  DateManager.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation

class DateManager {
    
    static let shared = DateManager()
    
//    let dateFormatter = DateFormatter()
//    let dateComponents = DateComponents()
//
//    func getDateFormatter(_ format: () -> String) -> DateFormatter {
//        dateFormatter.locale = Locale.current
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.dateFormat = format()
//        return dateFormatter
//    }
    
    func differenceBetweenNow(and last: Date) -> String? {
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: last, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = Calendar(identifier: .gregorian).date(from: components)
        return dateFormatter.string(from: date!)
    }
    
    
}
