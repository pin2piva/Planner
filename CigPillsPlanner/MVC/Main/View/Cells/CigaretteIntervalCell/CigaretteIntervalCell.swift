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
    @IBOutlet weak var todayCountLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var lastBreakTimeLabel: UILabel!
    @IBOutlet weak var lastBreakLabel: UILabel!
    @IBOutlet weak var nextBreakTimeLabel: UILabel!
    
    private var timer: Timer?
    private var intervalTimer: Timer?
        
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
        let totalCount = DataManager.shared.getTotalCountBeforeCurrent(date: schedule.currentStringDate)
        let dayliCount = DataManager.shared.getDayliCount(for: schedule.currentStringDate)
        markLabel.text = schedule.mark
        priceLabel.text = "\(String(describing: schedule.price))"
        lastBreakLabel.text = "Last smoke break"
        todayCountLabel.text = "\(dayliCount)"
        totalCountLabel.text = "\(totalCount)"
        nextBreakTimeLabel.text = getDefaultInterval(schedule)
        lastTime(schedule)
        makeIntervalTimer(schedule)
    }
    
    
    private func lastTime(_ schedule: CigaretteScheduleModel) {
        timer?.invalidate()
        if schedule.isToday {
            guard let date = schedule.lastTimeSmoke else {
                lastBreakTimeLabel.text = "00:00:00"
                timer?.invalidate()
                return
            }
            lastBreakTimeLabel.text = getTimeDifference(date, Date())
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (_) in
                self?.lastBreakTimeLabel.text = self?.getTimeDifference(date, Date())
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
    
    
    private func makeIntervalTimer(_ schedule: CigaretteScheduleModel) {
        guard schedule.isToday else { return }
        guard let lastTimeSmoke = schedule.lastTimeSmoke else { return }
        guard let timeInterval = schedule.interval.value else { return }
        intervalTimer?.invalidate()
        let nextTime = DateManager.shared.getDateWithInterval(interval: timeInterval + 1, from: lastTimeSmoke)
        let date = Date()
        nextBreakTimeLabel.text = getTimeDifference(date, nextTime)
        intervalTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            let date = DateManager.shared.getDateWithInterval(interval: 0, from: Date())
            self?.nextBreakTimeLabel.text = self?.getTimeDifference(date, nextTime)
            if date >= nextTime {
                timer.invalidate()
                let next = DateManager.shared.getDateWithInterval(interval: timeInterval, from: Date())
                self?.nextBreakTimeLabel.text = self?.getTimeDifference(date, next)
            }
        }
    }
    
    private func getTimeDifference(_ first: Date, _ second: Date) -> String? {
        let lastTimeString = DateManager.shared.getStringDifferenceBetween(components: [.hour, .minute, .second], first, and: second) { "HH:mm:ss" }
        return lastTimeString
    }
    
    private func getDefaultInterval(_ schedule: CigaretteScheduleModel) -> String? {
        guard let timeInterval = schedule.interval.value else { return nil }
        return DateManager.shared.getStringTimeFrom(timeInterval: timeInterval)
    }
    
}
