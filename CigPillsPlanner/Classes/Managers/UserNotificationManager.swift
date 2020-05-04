//
//  UserNotificationManager.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 5/4/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation
import UserNotifications

class UserNotificationManager {
  
  static let shared = UserNotificationManager()
  
//  private let launchImageName = ""
  
  private var center = UNUserNotificationCenter.current()
  
  func intervalNotification(timeInterval: TimeInterval) {
    let content = UNMutableNotificationContent()
    content.title = "Smoke time!"
    content.body = "Diling-diling, you can smoke!"
    content.sound = .default
    content.badge = 1
    // content.launchImageName = launchImageName
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
    let request = UNNotificationRequest(identifier: "intervalNotification", content: content, trigger: trigger)
    center.add(request) { (error) in
      guard let error = error else { return }
      print(error.localizedDescription)
    }
  }
  
  func overLimitNotification(limit: Int) {
    let content = UNMutableNotificationContent()
    var bodyPart: String {
      limit > 1 ? "\(limit) cigarettes" : "\(limit) cigarette"
    }
    content.title = "Limit exceeded!"
    content.body = "You have exceeded the limit of \(bodyPart)!"
    content.sound = .default
    content.badge = 1
    // content.launchImageName = launchImageName
    let request = UNNotificationRequest(identifier: "overLimitNotification", content: content, trigger: nil)
    center.add(request) { (error) in
      guard let error = error else { return }
      print(error.localizedDescription)
    }
  }
  
  func reduceIsDoneNotification() {
    let content = UNMutableNotificationContent()
    content.title = "Quit smoking!"
    content.body = "Great chance to quit! For a long time you smoke no more than 1 cigarette per day."
    content.sound = .default
    content.badge = 1
    // content.launchImageName = launchImageName
    guard let components = DateManager.shared.getDateComponentsWith(dateComponents: [.minute, .hour], dateString: "12:00", { "HH:mm" }) else { return }
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    let request = UNNotificationRequest(identifier: "reduceNotitfication", content: content, trigger: trigger)
    center.add(request) { (error) in
      guard let error = error else { return }
      print(error.localizedDescription)
    }
  }
  
}
