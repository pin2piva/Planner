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
    
    private var breakingButton: UIButton!
    private var schedules: Results<CigaretteScheduleModel>!
    private var timer: Timer?
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkSchedulesInRealm()
        registerCell()
        setupNavigationItem()
        createButton()
        
    }
    
    override func viewWillLayoutSubviews() {
        breakingButtonEnabling()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CigaretteCellProtocol
        let reve = schedules.sorted(byKeyPath: "currentStringDate", ascending: false)
        cell.setValues(reve[indexPath.row])
        
        return cell as! UITableViewCell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppDelegate.shared.rootViewController.showTabBarViewController()
    }
    
    
    // MARK: - Private methods
    
    private func registerCell() {
        let cell = UINib(nibName: "CigaretteAccountingCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "Cell")
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
    
    private func checkTodaySchedule(_ completion: (() -> Void)? = nil) {
        let currentDateString = DateManager.shared.getStringDate(date: Date()) { "yyyy-MM-dd" }
        if let lastShedule = schedules.first, lastShedule.currentStringDate != currentDateString {
            DataManager.shared.updateToYesterday(schedule: lastShedule)
            createCurrentScheduleWithLastProperties(from: lastShedule)
            schedules = DataManager.shared.getDescendingSortedSchedules()
            completion?()
        }
    }
    
    private func checkTodayScheduleWhenAppRun() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { [unowned self] (timer) in
            self.checkTodaySchedule() { [unowned self] in
                self.tableView.reloadData()
            }
        })
        
    }
    
    
    
    private func createCurrentScheduleWithLastProperties(from lastSchedule: CigaretteScheduleModel) {
        let currentSchedule = CigaretteScheduleModel()
        currentSchedule.createNewSchedule(mark: lastSchedule.mark,
                                          price: lastSchedule.price,
                                          packSize: lastSchedule.packSize,
                                          scenario: lastSchedule.scenario,
                                          limit: lastSchedule.limit.value,
                                          interval: lastSchedule.interval.value,
                                          reduce: (lastSchedule.reduceCig,
                                                   lastSchedule.reducePerDay))
    }
    
    
    // MARK: - @obcj private methods
    
    @objc private func editCurrentSchedule() {
        let currentDate = DateManager.shared.getStringDate(date: Date()) { "yyyy-MM-dd" }
        let currentSchedule = schedules.filter({ $0.currentStringDate == currentDate }).first
        AppDelegate.shared.rootViewController.showAddNewSheduleController(currentSchedule)
    }
    
    @objc private func increaceCount() {
        print("+1")
        tableView.reloadData()
    }
    
}

