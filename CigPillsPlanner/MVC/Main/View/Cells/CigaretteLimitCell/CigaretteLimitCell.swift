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
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var lastBreakTimeLabel: UILabel!
    @IBOutlet weak var lastBreakLabel: UILabel!
    
    var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupLayer() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.borderWidth = 5
    }
    

    func setValues(_ schedule: CigaretteScheduleModel) {
        
        markLabel.text = schedule.mark
        priceLabel.text = "\(String(describing: schedule.price))"
        lastBreakLabel.text = "Last smoke break"
        lastTime(schedule)
        let dayliCount = DataManager.shared.getDayliCount(for: schedule.currentStringDate)
        let totalCount = DataManager.shared.getTotalCountBeforeCurrent(date: schedule.currentStringDate)
        totalCountLabel.text = "\(totalCount)"
        balanceLabel.text = "\(dayliCount)/\(schedule.limit.value!)"
    }
    
    
    private func lastTime(_ schedule: CigaretteScheduleModel) {
        timer?.invalidate()
        if schedule.isToday {
            guard let date = schedule.lastTimeSmoke else {
                lastBreakTimeLabel.text = "00:00:00"
                timer?.invalidate()
                return
            }
            setLastSmokeTimeDifference(date)
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (_) in
                self?.setLastSmokeTimeDifference(date)
            }
        } else {
            guard let date = schedule.lastTimeSmoke else {
                lastBreakLabel.text = "Did not smoke"
                lastBreakTimeLabel.text = "\(schedule.currentStringDate)"
                return
            }
            lastBreakTimeLabel.text = DateManager.shared.getStringDate(date: date) { "EE, MM-dd-yyyy HH:mm" }
        }
    }
    
    private func setLastSmokeTimeDifference(_ date: Date) {
        let lastTimeString = DateManager.shared.getStringDifferenceBetween(components: [.hour, .minute, .second], date, and: Date()) { "HH:mm:ss" }
        lastBreakTimeLabel.text = lastTimeString
    }
    
    
}
