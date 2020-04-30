//
//  NotTodayCell.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/20/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class NotTodayCell: UITableViewCell, CellProtocol {
  
  // MARK: - Outlets
  
  
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var smokedLabel: UILabel!
  @IBOutlet private weak var lastLabel: UILabel!
 
  // MARK: - Internal func
  
  
  func setValues(_ schedule: CigaretteScheduleModel) {
    dateLabel.text = schedule.currentStringDate
    smokedLabel.text = "\(getDayliCount(schedule))"
    lastTime(schedule)
  }
  
  func getDayliCount(_ schedule: CigaretteScheduleModel) -> Int {
    DayliDataManager.shared.getDayliCount(for: schedule.currentStringDate)
  }
  
  // MARK: - Private func
  
  
  // TODO: - исправить на "HH:mm"
  private func lastTime(_ schedule: CigaretteScheduleModel) {
    if let date = schedule.lastTimeSmoke {
      lastLabel.text = DateManager.shared.getStringDate(date: date) { "HH:mm:ss" } // исправить на HH:mm
    } else {
      lastLabel.text = "00:00"
    }
  }
  
}
