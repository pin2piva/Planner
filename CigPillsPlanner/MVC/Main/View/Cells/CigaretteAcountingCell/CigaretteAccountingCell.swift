//
//  CigaretteAccountingCell.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

protocol CigaretteCellProtocol {
    func setValues(_ schedule: CigaretteScheduleModel)
}

class CigaretteAccountingCell: UITableViewCell, CigaretteCellProtocol {
    
    
    @IBOutlet weak var mark: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var lastTime: UILabel!
    @IBOutlet weak var markCountLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    
    private var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func setValues(_ schedule: CigaretteScheduleModel) { //, markCounter: MarkCounter
        
        mark.text = schedule.mark
        price.text = "\(String(describing: schedule.price))"
        lastTime(lastTime: schedule.lastTimeSmoke, isToday: schedule.isToday)
        
        let dayliCount = DataManager.shared.getDayliCount(for: schedule.currentStringDate)
            markCountLabel.text = "d: \(dayliCount)"
        
        let totalCount = DataManager.shared.getTotalCountBeforeCurrent(date: schedule.currentStringDate)
        totalCountLabel.text = "t: \(totalCount)"
    }
    
    private func lastTime(lastTime: Date?, isToday: Bool) {
        timer?.invalidate()
        if isToday {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
                guard let date = lastTime else {
                    self?.lastTime.text = "Not smoked yet"
                    timer.invalidate()
                    return
                }
                let lastTimeString = DateManager.shared.getStringDifferenceBetween(components: [.hour, .minute, .second], date, and: Date()) { "HH:mm:ss" }
                self?.lastTime.text = "Last time - \(lastTimeString!)"
            })
        } else {
            guard let date = lastTime else {
                self.lastTime.text = "Did not smoke"
                return
            }
            self.lastTime.text = DateManager.shared.getStringDate(date: date) { "EE, MM-dd-yyyy HH:mm:ss" }
        }
    }
    
}