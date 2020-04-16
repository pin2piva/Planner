//
//  CigaretteAccountingCell.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit





class CigaretteAccountingCell: UITableViewCell {
    
    
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totayCountLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var lastBreakTimeLabel: UILabel!
    @IBOutlet weak var lastBreakLabel: UILabel!
    
    private var timer: Timer?
    
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
    

    
    func setValues(_ schedule: CigaretteScheduleModel) { //, markCounter: MarkCounter
        
        markLabel.text = schedule.mark
        priceLabel.text = "\(String(describing: schedule.price))"
        lastBreakLabel.text = "Last smoke break"
        lastTime(schedule)
        let dayliCount = DataManager.shared.getDayliCount(for: schedule.currentStringDate)
            totayCountLabel.text = "\(dayliCount)"
        let totalCount = DataManager.shared.getTotalCountBeforeCurrent(date: schedule.currentStringDate)
        totalCountLabel.text = "\(totalCount)"
    }
    
    func lastTime(_ schedule: CigaretteScheduleModel) {
        timer?.invalidate()
        if schedule.isToday {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
                guard let date = schedule.lastTimeSmoke else {
                    self?.lastBreakTimeLabel.text = "00:00:00"
                    timer.invalidate()
                    return
                }
                let lastTimeString = DateManager.shared.getStringDifferenceBetween(components: [.hour, .minute, .second], date, and: Date()) { "HH:mm:ss" }
                self?.lastBreakTimeLabel.text = "\(lastTimeString!)"
            }
        } else {
            guard let date = schedule.lastTimeSmoke else {
                self.lastBreakLabel.text = "\(schedule.currentStringDate)"
                self.lastBreakTimeLabel.text = "Did not smoke"
                return
            }
            self.lastBreakTimeLabel.text = DateManager.shared.getStringDate(date: date) { "EE, MM-dd-yyyy HH:mm" }
        }
    }
    
}
