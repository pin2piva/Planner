//
//  CigaretteLimitIntervalReduceCell.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/20/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class CigaretteLimitIntervalReduceCell: UITableViewCell, CellProtocol {
    
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var reduceLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    
    private var intervalTimer: Timer?

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
        TimerManager.shared.makeIntervalTimer(schedule) { [weak self] (time) in
            self?.nextLabel.text = time
        }
    }
    
}
