//
//  CigaretteIntervalCell.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/17/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class CigaretteIntervalCell: UITableViewCell, CellProtocol {
    
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    
    private var intervalTimer: Timer?
    
    func setValues(_ schedule: CigaretteScheduleModel) {
        let totalCount = DataManager.shared.getTotalCountBeforeCurrent(date: schedule.currentStringDate)
        let dayliCount = DataManager.shared.getDayliCount(for: schedule.currentStringDate)
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
