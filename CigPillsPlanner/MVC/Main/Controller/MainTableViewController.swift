//
//  MainTableViewController.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {
    
    
    private var schedules: Results<CigaretteScheduleModel>!
    private var markCounter: MarkCounter?
    private var breakingButton: UIButton!
    private var timer: Timer?
    private var count = 0
    private var titleFor: String? {
        didSet {
            if let titleFor = titleFor {
                title = titleFor
            }
        }
    }
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkSchedulesInRealm()
        registerCell()
        setupNavigationItem()
        createButton()
        
        tableView.tableFooterView = UIView()
        self.view.backgroundColor = .systemGray5
    }
    
    override func viewWillLayoutSubviews() {
        breakingButtonEnabling()
        
        checkAndCreateMarkCounterFor(currentSchedule: getCurrentSchedule())
        checkAndCreateDayliCounterFor(currentSchedule: getCurrentSchedule())
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let schedulesSorted = schedules.sorted(byKeyPath: "currentStringDate", ascending: false)
        let schedule = schedules[indexPath.row]
        let scenario = Scenario.getScenarioCase(from: schedule.scenario)
        var cell: CellProtocol
        switch scenario {
        case .accountingOnly:
            cell = tableView.dequeueReusableCell(withIdentifier: "accounting", for: indexPath) as! CigaretteAccountingCell
        case .withInterval:
            cell = tableView.dequeueReusableCell(withIdentifier: "interval", for: indexPath) as! CigaretteIntervalCell
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "limit", for: indexPath) as! CigaretteLimitCell
        }
        cell.setValues(schedule)
        titleFor = schedule.overLimit()
        return cell as! UITableViewCell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppDelegate.shared.rootViewController.showTabBarViewController()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let schedule = schedules[indexPath.row]
            DataManager.shared.deleteYesterdaySchedule(schedule)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    // MARK: - Private methods
    
    
    private func setupViewGradient() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.colors = [UIColor.systemGray6.cgColor,
                           UIColor.systemGray.cgColor]
        
        let backgroundView = UIView(frame: CGRect(x: view.bounds.origin.x,
                                                  y: view.bounds.origin.y,
                                                  width: view.bounds.width,
                                                  height: view.bounds.height + 50))
        gradient.frame = backgroundView.bounds
        backgroundView.layer.addSublayer(gradient)
        self.tableView.backgroundView = backgroundView
    }
    
    private func registerCell() {
        let accountingCell = UINib(nibName: "CigaretteAccountingCell", bundle: nil)
        tableView.register(accountingCell, forCellReuseIdentifier: "accounting")
        let limitCell = UINib(nibName: "CigaretteLimitCell", bundle: nil)
        tableView.register(limitCell, forCellReuseIdentifier: "limit")
        let intervalCell = UINib(nibName: "CigaretteIntervalCell", bundle: nil)
        tableView.register(intervalCell, forCellReuseIdentifier: "interval")
    }
    
    private func setupNavigationItem() {
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editCurrentSchedule)), animated: true)
    }
    
    private func createButton() {
        breakingButton = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width - 100,
                                                                y: self.view.frame.height - 50),
                                                size: CGSize(width: 50, height: 50)))
        
        breakingButton.backgroundColor = .systemGray
        breakingButton.setImage(UIImage(systemName: "plus"), for: .normal)
        breakingButton.clipsToBounds = true
        breakingButton.layer.cornerRadius = 15
        breakingButton.addTarget(self, action: #selector(increaceCount), for: .touchUpInside)
        self.navigationController?.view.addSubview(breakingButton)
    }
    
    private func breakingButtonEnabling() {
        if schedules.isEmpty {
            breakingButton.isEnabled = false
        } else {
            breakingButton.isEnabled = true
        }
    }
    
    private func checkSchedulesInRealm() {
        schedules = DataManager.shared.getDescendingSortedSchedules()
        checkTodaySchedule()
        checkTodayScheduleWhenAppRun()
    }
    
    private func checkTodaySchedule() {
        let currentDateString = DateManager.shared.getStringDate(date: Date()) { "yyyy-MM-dd HH:mm" }
        if let lastShedule = schedules.first, lastShedule.currentStringDate != currentDateString {
            DataManager.shared.updateToYesterday(schedule: lastShedule)
            createCurrentScheduleWithLastProperties(from: lastShedule)
            schedules = DataManager.shared.getDescendingSortedSchedules()
            tableView.reloadData()
        }
    }
    
    private func checkTodayScheduleWhenAppRun() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] (_) in
            self.checkTodaySchedule()
        }
    }
    
    private func createCurrentScheduleWithLastProperties(from lastSchedule: CigaretteScheduleModel) {
        DataManager.shared.createNewSchedule(mark: lastSchedule.mark,
                                          price: lastSchedule.price,
                                          packSize: lastSchedule.packSize,
                                          scenario: lastSchedule.scenario,
                                          limit: lastSchedule.limit.value,
                                          interval: lastSchedule.interval.value,
                                          reduceCig: lastSchedule.reduceCig.value,
                                          reducePerDay: lastSchedule.reducePerDay.value)
    }
    
    private func getCurrentSchedule() -> CigaretteScheduleModel? {
        let currentDate = DateManager.shared.getStringDate(date: Date()) { "yyyy-MM-dd HH:mm" }
        let currentSchedule = schedules.filter({ $0.currentStringDate == currentDate }).first
        return currentSchedule
    }
    
    private func checkAndCreateMarkCounterFor(currentSchedule: CigaretteScheduleModel?) {
        guard let currentSchedule = currentSchedule else { return }
        let mark = currentSchedule.mark
        let price = currentSchedule.price
        if DataManager.shared.getMarkCounter(for: mark) == nil {
            DataManager.shared.createMarkCounter(with: mark, price)
        }
    }
    
    private func checkAndCreateDayliCounterFor(currentSchedule: CigaretteScheduleModel?) {
        guard let currentSchedule = currentSchedule else { return }
        let mark = currentSchedule.mark
        let price = currentSchedule.price
        let dateString = currentSchedule.currentStringDate
        if DataManager.shared.getDayliCounter(for: dateString) == nil {
            DataManager.shared.createDayliCounter(dateString, mark, price)
        }
    }
    
    
    // MARK: - @obcj private methods
    
    @objc private func editCurrentSchedule() {
        let currentSchedule = getCurrentSchedule()
        AppDelegate.shared.rootViewController.showAddNewSheduleController(currentSchedule)
    }
    
    @objc private func increaceCount() {
        let current = getCurrentSchedule()
        guard let currentSchedule = current else { return }
        DataManager.shared.setLastTime(for: currentSchedule)
        DataManager.shared.increaceMarkCount(for: currentSchedule)
        DataManager.shared.increaceDayliCount(for: currentSchedule)
        tableView.reloadData()
    }
    
}

