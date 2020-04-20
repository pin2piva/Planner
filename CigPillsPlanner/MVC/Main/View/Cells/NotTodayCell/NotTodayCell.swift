//
//  NotTodayCell.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/20/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class NotTodayCell: UITableViewCell, CellProtocol {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var smokedLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setValues(_ schedule: CigaretteScheduleModel) {
        dateLabel.text = schedule.currentStringDate
        smokedLabel.text = "\(getDayliCount(schedule))"
        lastTime(schedule)
    }
    
    func getDayliCount(_ schedule: CigaretteScheduleModel) -> Int {
        DataManager.shared.getDayliCount(for: schedule.currentStringDate)
    }
    
    private func lastTime(_ schedule: CigaretteScheduleModel) {
        guard let date = schedule.lastTimeSmoke else { return }
        lastLabel.text = DateManager.shared.getStringDate(date: date) { "HH:mm" }
    }
    
}
