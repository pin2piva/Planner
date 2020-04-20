//
//  CigaretteAccountingCell.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

protocol CellProtocol {
    func setValues(_ schedule: CigaretteScheduleModel)
}

class CigaretteAccountingCell: UITableViewCell, CellProtocol {
    
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    
    private var timer: Timer?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    func setValues(_ schedule: CigaretteScheduleModel) {
        
        markLabel.text = schedule.mark
        priceLabel.text = "\(String(describing: schedule.price))"
        lastTime(schedule)
        let dayliCount = DataManager.shared.getDayliCount(for: schedule.currentStringDate)
        todayLabel.text = "\(dayliCount)"
        let totalCount = DataManager.shared.getTotalCountBeforeCurrent(date: schedule.currentStringDate)
        totalLabel.text = "\(totalCount)"
    }
    
    
    private func lastTime(_ schedule: CigaretteScheduleModel) {
        timer?.invalidate()
        guard let date = schedule.lastTimeSmoke else {
            lastLabel.text = "00:00:00"
            timer?.invalidate()
            return
        }
        setLastSmokeTimeDifference(date)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (_) in
            self?.setLastSmokeTimeDifference(date)
        }
    }
    
    private func setLastSmokeTimeDifference(_ date: Date) {
        let lastTimeString = DateManager.shared.getStringDifferenceBetween(components: [.hour, .minute, .second], date, and: Date()) { "HH:mm:ss" }
        lastLabel.text = lastTimeString
    }
    
}
