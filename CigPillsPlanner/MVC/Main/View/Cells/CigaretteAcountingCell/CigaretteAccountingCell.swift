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
        
    @IBOutlet weak var firstStack: UIStackView!
    @IBOutlet weak var secondStack: UIStackView!
    
    @IBOutlet weak var firstMarkLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var todayCountLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var lastBreakTimeLabel: UILabel!
    @IBOutlet weak var lastBreakLabel: UILabel!
    
    private var timer: Timer?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayer()
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
        todayCountLabel.text = "\(dayliCount)"
        let totalCount = DataManager.shared.getTotalCountBeforeCurrent(date: schedule.currentStringDate)
        totalCountLabel.text = "\(totalCount)"
    }
    
    
    private func lastTime(_ schedule: CigaretteScheduleModel) {
        timer?.invalidate()
//        removeAndHideLabel(schedule.isToday)
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
    
//    func removeAndHideLabel(_ today: Bool) {
//        if firstStack.arrangedSubviews.count >= 4 && !today {
//            firstStack.removeArrangedSubview(firstMarkLabel)
//            secondStack.removeArrangedSubview(markLabel)
//            firstMarkLabel.isHidden = !today
//            markLabel.isHidden = !today
//        } else if today && firstStack.arrangedSubviews.count == 4 {
//            firstStack.insertArrangedSubview(firstMarkLabel, at: 0)
//            secondStack.insertArrangedSubview(markLabel, at: 0)
//            firstMarkLabel.isHidden = !today
//            markLabel.isHidden = !today
//        }
//    }
    
    private func setLastSmokeTimeDifference(_ date: Date) {
        let lastTimeString = DateManager.shared.getStringDifferenceBetween(components: [.hour, .minute, .second], date, and: Date()) { "HH:mm:ss" }
        lastBreakTimeLabel.text = lastTimeString
    }
    
}
