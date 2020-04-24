//
//  TimerManager.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/21/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation

class TimerManager {
  
  // MARK: - Static properties
  
  static let shared = TimerManager()
  
  
  // MARK: Private properties
  
  private var timer: Timer?
  private var intervalTimer: Timer?
  
  
  // MARK: - Internal properties
  
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
  
  func makeIntervalTimer(_ schedule: CigaretteScheduleModel, _ completion: @escaping (String?) -> Void) {
    guard let timeInterval = schedule.interval.value else { return }
    guard let lastTimeSmoke = schedule.lastTimeSmoke else {
      completion(DateManager.shared.getStringTimeFrom(timeInterval: timeInterval))
      return
    }
    intervalTimer?.invalidate()
    let nextTime = Date(timeInterval: timeInterval + 1, since: lastTimeSmoke)
    let date = Date()
    let timerIsActive = schedule.timerIsActive
    completion(getTimeDifference(date, nextTime))
    if timerIsActive {
      intervalTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
        let date = Date()
        completion(self?.getTimeDifference(date, nextTime))
        if date >= nextTime {
          let next = Date(timeInterval: timeInterval, since: Date())
          completion(self?.getTimeDifference(date, next))
          self?.deactivateTimer()
          print("дилинь-дилинь")
          timer.invalidate()
        }
      }
    } else {
      let next = Date(timeInterval: timeInterval, since: Date())
      completion(getTimeDifference(date, next))
    }
  }
  
  
  // MARK: - Private properties
  
  private func deactivateTimer() {
    let currentSchedule = DataManager.shared.getDescendingSortedSchedules().first!
    DataManager.shared.timer(activate: false, for: currentSchedule)
  }

  private func getTimeDifference(_ first: Date, _ second: Date) -> String? {
    let lastTimeString = DateManager.shared.getStringDifferenceBetween(components: [.hour, .minute, .second], first, and: second) { "HH:mm:ss" }
    return lastTimeString
  }
  
  private func setLastSmokeTimeDifference(_ date: Date) -> String? {
    let lastTimeString = DateManager.shared.getStringDifferenceBetween(components: [.hour, .minute, .second], date, and: Date()) { "HH:mm:ss" }
    return lastTimeString
  }
  
}
