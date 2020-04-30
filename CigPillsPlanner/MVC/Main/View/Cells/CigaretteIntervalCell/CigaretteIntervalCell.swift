//
//  CigaretteIntervalCell.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/17/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class CigaretteIntervalCell: UITableViewCell, CellProtocol {
  
  // MARK: Outlets
  
  
  @IBOutlet private weak var markLabel: UILabel!
  @IBOutlet private weak var priceLabel: UILabel!
  @IBOutlet private weak var todayLabel: UILabel!
  @IBOutlet private weak var totalLabel: UILabel!
  @IBOutlet private weak var lastLabel: UILabel!
  @IBOutlet private weak var nextLabel: UILabel!
  
  // MARK: - Private properties
  
  
  private var intervalTimer: Timer?
  
  // MARK: - Internal func
  
  
  func setValues(_ schedule: CigaretteScheduleModel) {
    let totalCount = DayliDataManager.shared.getTotalCountBeforeCurrent(date: schedule.currentStringDate)
    let dayliCount = DayliDataManager.shared.getDayliCount(for: schedule.currentStringDate)
    markLabel.text = schedule.mark
    priceLabel.text = "\(String(describing: schedule.price))"
    todayLabel.text = "\(dayliCount)"
    totalLabel.text = "\(totalCount)"
    TimerManager.shared.lastTime(schedule) { [weak self] (time) in
      self?.lastLabel.text = time
    }
    TimerManager.shared.makeIntervalTimer(schedule) { [weak self] (time) in
      self?.nextLabel.text = time
    }
  }
  
}
