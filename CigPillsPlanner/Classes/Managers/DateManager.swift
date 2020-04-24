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
  
  func getStringTimeFrom(timeInterval: Double) -> String? {
    let currentDate = Date()
    let dateWithInterval = Date(timeIntervalSinceNow: timeInterval)
    let stringInterval = getStringDifferenceBetween(components: [.hour, .minute, .second], currentDate, and: dateWithInterval) { "HH:mm:ss" }
    return stringInterval
  }
  
}

