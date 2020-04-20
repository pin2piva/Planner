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
    
    private var timer: Timer?
    private var intervalTimer: Timer?
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setValues(_ schedule: CigaretteScheduleModel) {
        let totalCount = DataManager.shared.getTotalCountBeforeCurrent(date: schedule.currentStringDate)
        let dayliCount = DataManager.shared.getDayliCount(for: schedule.currentStringDate)
        markLabel.text = schedule.mark
        priceLabel.text = "\(String(describing: schedule.price))"
        todayLabel.text = "\(dayliCount)"
        totalLabel.text = "\(totalCount)"
        lastTime(schedule)
        makeIntervalTimer(schedule)
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
    
    private func makeIntervalTimer(_ schedule: CigaretteScheduleModel) {
        guard let timeInterval = schedule.interval.value else { return }
        guard let lastTimeSmoke = schedule.lastTimeSmoke else {
            nextLabel.text = DateManager.shared.getStringTimeFrom(timeInterval: timeInterval)
            return
        }
        intervalTimer?.invalidate()
        let nextTime = DateManager.shared.getDateWithInterval(interval: timeInterval + 1, from: lastTimeSmoke)
        let date = Date()
        nextLabel.text = getTimeDifference(date, nextTime)
        intervalTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            let date = DateManager.shared.getDateWithInterval(interval: 0, from: Date())
            self?.nextLabel.text = self?.getTimeDifference(date, nextTime)
            if date >= nextTime {
                timer.invalidate()
                let next = DateManager.shared.getDateWithInterval(interval: timeInterval, from: Date())
                self?.nextLabel.text = self?.getTimeDifference(date, next)
            }
        }
    }
    
    private func getTimeDifference(_ first: Date, _ second: Date) -> String? {
        let lastTimeString = DateManager.shared.getStringDifferenceBetween(components: [.hour, .minute, .second], first, and: second) { "HH:mm:ss" }
        return lastTimeString
    }
    
}
