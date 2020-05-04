//
//  AppDelegate.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  // MARK: - Properties
  
  var window: UIWindow?
  
  private var notifications = UserNotificationManager()
  
  
  // MARK: - Internal func
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    setupRoot()
    
    notifications.requestAutorization()
    notifications.center.delegate = notifications
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
