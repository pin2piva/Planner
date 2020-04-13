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
    
    let dateFormatter = DateFormatter()
    
    func getStringDifferenceBetween(components: Set<Calendar.Component>, _ from: Date, and to: Date, _ completion: () -> String?) -> String? {
        let components = Calendar.current.dateComponents(components, from: from, to: to)
        dateFormatter.dateFormat = completion()
        let date = Calendar(identifier: .gregorian).date(from: components)
        return dateFormatter.string(from: date!)
    }
    
    
    
    func getStringDate(date: Date, _ completion: () -> String?) -> String {
        dateFormatter.dateFormat = completion()
        return dateFormatter.string(from: date)
    }
    
    func getDate(from string: String, _ completion: () -> String?) -> Date? {
        dateFormatter.dateFormat = completion()
        return dateFormatter.date(from: string)
    }
    
    
}
