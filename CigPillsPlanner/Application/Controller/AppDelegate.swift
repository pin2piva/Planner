//
//  AppDelegate.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  // MARK: - Properties
  
  var window: UIWindow?
  private let center = UNUserNotificationCenter.current()
  
  // MARK: - Internal func
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    setupRoot()
    requestAutorization()
    
    center.delegate = self
    
    return true
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    UIApplication.shared.applicationIconBadgeNumber = 0
  }
  
  // MARK: - Private func
  
  
  private func setupRoot() {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = RootViewController()
    window?.makeKeyAndVisible()
  }
  
  private func requestAutorization() {
    center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] (granted, error) in
      print("Authorization granded - \(granted)")
      
      guard granted else { return }
      self?.getNotificationSettings()
    }
  }
  
  private func getNotificationSettings() {
    center.getNotificationSettings { (settings) in
      print("Notification settings - \(settings)")
    }
  }
  
}

// MARK: - Extensions

extension AppDelegate {
  
  static var shared: AppDelegate {
    UIApplication.shared.delegate as! AppDelegate
  }
  
  var rootViewController: RootViewController {
    window?.rootViewController as! RootViewController
  }
}

// MARK: - User notification center delegate


extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .sound])
//    if notification.request.identifier == "intervalNotification" {
//      completionHandler([.alert, .sound])
//    }
  }
}

