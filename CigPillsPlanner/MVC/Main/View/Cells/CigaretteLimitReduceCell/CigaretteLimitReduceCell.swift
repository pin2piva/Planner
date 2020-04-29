//
//  CigaretteLimitReduceCell.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/20/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class CigaretteLimitReduceCell: UITableViewCell, CellProtocol {
  
  // MARK: - Outlets
  
  
  @IBOutlet private weak var markLabel: UILabel!
  @IBOutlet private weak var priceLabel: UILabel!
  @IBOutlet private weak var balanceLabel: UILabel!
  @IBOutlet private weak var totalLabel: UILabel!
  @IBOutlet private weak var reduceLabel: UILabel!
  @IBOutlet private weak var lastLabel: UILabel!
  
  // MARK: - Internal func
  
  
  func setValues(_ schedule: CigaretteScheduleModel) {
    let dayliCount = DataManager.shared.getDayliCount(for: schedule.currentStringDate)
    let totalCount = DataManager.shared.getTotalCountBeforeCurrent(date: schedule.currentStringDate)
    markLabel.text = schedule.mark
    priceLabel.text = "\(String(describing: schedule.price))"
    totalLabel.text = "\(totalCount)"
    balanceLabel.text = "\(dayliCount)/\(schedule.limit.value!)"
    reduceLabel.text = "\(schedule.reduceCig.value!)/\(schedule.reducePerDay.value!)"
    TimerManager.shared.lastTime(schedule) { [weak self] (time) in
      self?.lastLabel.text = time
    }
  }
  
}
