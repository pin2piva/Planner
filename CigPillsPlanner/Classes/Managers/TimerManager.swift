//
//  TimerManager.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/21/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation

class TimerManager {
  
  static let shared = TimerManager()
  
  private var timer: Timer?
  private var intervalTimer: Timer?
  
  func lastTime(_ schedule: CigaretteScheduleModel, _ completion: @escaping (String?) -> Void) {
    timer?.invalidate()
    guard let date = schedule.lastTimeSmoke else {
      completion("00:00:00")
      timer?.invalidate()
      return
    }
    completion(setLastSmokeTimeDifference(date))
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (_) in
      completion(self?.setLastSmokeTimeDifference(date))
    }
  }
  
  private func setLastSmokeTimeDifference(_ date: Date) -> String? {
    let lastTimeString = DateManager.shared.getStringDifferenceBetween(components: [.hour, .minute, .second], date, and: Date()) { "HH:mm:ss" }
    return lastTimeString
  }
  
  func makeIntervalTimer(_ schedule: CigaretteScheduleModel, _ completion: @escaping (String?) -> Void) {
    guard let timeInterval = schedule.interval.value else { return }
    guard let lastTimeSmoke = schedule.lastTimeSmoke else {
      completion(DateManager.shared.getStringTimeFrom(timeInterval: timeInterval))
      return
    }
    intervalTimer?.invalidate()
    let nextTime = DateManager.shared.getDateWithInterval(interval: timeInterval + 1, from: lastTimeSmoke)
    let date = Date()
    completion(getTimeDifference(date, nextTime))
    intervalTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
      let date = DateManager.shared.getDateWithInterval(interval: 0, from: Date())
      completion(self?.getTimeDifference(date, nextTime))
      if date >= nextTime {
        let next = DateManager.shared.getDateWithInterval(interval: timeInterval, from: Date())
        completion(self?.getTimeDifference(date, next))
        timer.invalidate()
      }
    }
  }
  
  private func getTimeDifference(_ first: Date, _ second: Date) -> String? {
    let lastTimeString = DateManager.shared.getStringDifferenceBetween(components: [.hour, .minute, .second], first, and: second) { "HH:mm:ss" }
    return lastTimeString
  }
  
  
  
}
