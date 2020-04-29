//
//  CigaretteAccountingCell.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class CigaretteAccountingCell: UITableViewCell, CellProtocol {
  
  // MARK: - Outlets
  
  
  @IBOutlet private weak var markLabel: UILabel!
  @IBOutlet private weak var priceLabel: UILabel!
  @IBOutlet private weak var todayLabel: UILabel!
  @IBOutlet private weak var totalLabel: UILabel!
  @IBOutlet private weak var lastLabel: UILabel!
  
  // MARK: - Internal func
  
  
  func setValues(_ schedule: CigaretteScheduleModel) {
    let dayliCount = DataManager.shared.getDayliCount(for: schedule.currentStringDate)
    let totalCount = DataManager.shared.getTotalCountBeforeCurrent(date: schedule.currentStringDate)
    markLabel.text = schedule.mark
    priceLabel.text = "\(String(describing: schedule.price))"
    todayLabel.text = "\(dayliCount)"
    totalLabel.text = "\(totalCount)"
    TimerManager.shared.lastTime(schedule) { [weak self] (time) in
      self?.lastLabel.text = time
    }
  }
  
}
