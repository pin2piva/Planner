//
//  CigaretteLimitCell.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/17/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class CigaretteLimitCell: UITableViewCell, CellProtocol {
  
  @IBOutlet weak var markLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var balanceLabel: UILabel!
  @IBOutlet weak var lastLabel: UILabel!
  
  func setValues(_ schedule: CigaretteScheduleModel) {
    let dayliCount = DataManager.shared.getDayliCount(for: schedule.currentStringDate)
    let totalCount = DataManager.shared.getTotalCountBeforeCurrent(date: schedule.currentStringDate)
    markLabel.text = schedule.mark
    priceLabel.text = "\(String(describing: schedule.price))"
    totalLabel.text = "\(totalCount)"
    balanceLabel.text = "\(dayliCount)/\(schedule.limit.value!)"
    TimerManager.shared.lastTime(schedule) { [weak self] (time) in
      self?.lastLabel.text = time
    }
  }
  
}
