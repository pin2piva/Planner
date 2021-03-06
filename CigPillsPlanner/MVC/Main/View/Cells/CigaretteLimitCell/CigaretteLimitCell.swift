//
//  CigaretteLimitCell.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/17/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class CigaretteLimitCell: UITableViewCell, CellProtocol {
  
  // MARK: - Outlets
  
  
  @IBOutlet private weak var markLabel: UILabel!
  @IBOutlet private weak var priceLabel: UILabel!
  @IBOutlet private weak var totalLabel: UILabel!
  @IBOutlet private weak var balanceLabel: UILabel!
  @IBOutlet private weak var lastLabel: UILabel!
  
  // MARK: - Internal func
  
  
  func setValues(_ schedule: CigaretteScheduleModel) {
    let dayliCount = DayliDataManager.shared.getDayliCount(for: schedule.currentStringDate)
    let totalCount = DayliDataManager.shared.getTotalCountBeforeCurrent(date: schedule.currentStringDate)
    markLabel.text = schedule.mark
    priceLabel.text = "\(String(describing: schedule.price))"
    totalLabel.text = "\(totalCount)"
    if let limit = schedule.limit.value {
      balanceLabel.text = "\(dayliCount)/\(limit)"
    }
    TimerManager.shared.lastTime(schedule) { [weak self] (time) in
      self?.lastLabel.text = time
    }
  }
  
}
