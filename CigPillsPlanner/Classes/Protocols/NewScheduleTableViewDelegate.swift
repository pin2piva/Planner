//
//  NewScheduleTableViewDelegate.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/24/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation

protocol NewScheduleTableViewDelegate: class {
  func addDidFinish()
  func addDidCancel()
}
