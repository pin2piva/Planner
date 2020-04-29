//
//  DateManager.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation

class DateManager {
  
  // MARK: - Static properties
  
  
  static let shared = DateManager()
  
  // TODO: исправить на день!!!
  static let dateStringFormat = "yyyy-MM-dd HH:mm"
  
  // MARK: - Private properties
  
  
  private let dateFormatter = DateFormatter()
  
  // MARK: - Internal func
  
  
  func getStringDifferenceBetween(components: Set<Calendar.Component>, _ from: Date, and to: Date, _ completion: () -> String?) -> String? {
    guard let date = getDateDifferenceBetween(components: components, from, and: to) else { return nil }
    dateFormatter.dateFormat = completion()
    return dateFormatter.string(from: date)
  }
  
  func getDateDifferenceBetween(components: Set<Calendar.Component>, _ from: Date, and to: Date) -> Date? {
    let components = Calendar.current.dateComponents(components, from: from, to: to)
    let date = Calendar(identifier: .gregorian).date(from: components)
    return date
  }
  
  // TODO: - Исправить на день!!!
  func checkReduce(from begin: Date?, reducePerDay: Int, limit: Int) -> Int? {
    guard let begin = begin else { return nil }
    let zeroHourDate = Date().zeroSeconds // исправить на день
    guard let date = zeroHourDate else { return nil }
    let dayComponent = Calendar.current.dateComponents([.minute], from: begin, to: date) // испавить на день
    guard let days = dayComponent.minute else { return nil } // исправить на день
    print("minute difference - \(days)")
    return days / reducePerDay
  }
  
  func getStringDate(date: Date, _ completion: () -> String?) -> String {
    dateFormatter.dateFormat = completion()
    return dateFormatter.string(from: date)
  }
  
  func getDate(from string: String, _ completion: () -> String?) -> Date? {
    dateFormatter.dateFormat = completion()
    return dateFormatter.date(from: string)
  }
  
  func getTimeInterval(from date: Date, to secondDate: Date) -> TimeInterval? {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.second], from: date, to: secondDate)
    let seconds = components.second
    guard let secondInterval = seconds else { return nil }
    let interval = Double(secondInterval)
    return interval
  }
  
  func getDateStringFormat(from interval: TimeInterval?) -> String? {
    guard let timeInterval = interval else { return nil }
    switch timeInterval {
    case 0..<60:
      return "ss"
    case 60..<3600:
      return "mm:ss"
    case 3600..<86400:
      return "HH:mm:ss"
    case 86400..<2592000:
      return "dd HH:mm:ss"
    case 2592000..<31536000:
      return "MM-dd HH:mm:ss"
    default:
      return "yy-MM-dd HH:mm:ss"
    }
  }
  
}

