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
  
  // MARK: - Private properties
  
  
  private var schedules: Results<CigaretteScheduleModel>!
  private var breakingButton: UIButton!
  private var timer: Timer?
  private var count = 0
  private var titleFor: String? {
    didSet {
      title = titleFor
    }
  }
  private let notifications = UserNotificationManager()
  
  private var composeButton: UIBarButtonItem!
  private var editButton: UIBarButtonItem!
  private var doneButton: UIBarButtonItem!
  private var deleteButton: UIBarButtonItem!
  
  // MARK: - Life cycle
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    checkSchedulesInRealm()
    registerCell()
    setupBarButtonItems()
    setupNavigationItem()
    createButton()
    setupViewGradient()
    tableView.tableFooterView = UIView()
    
    tableView.allowsMultipleSelectionDuringEditing = true
  }
  
  override func viewWillLayoutSubviews() {
    breakingButtonEnabling()
    checkAndCreateCountersFor(currentSchedule: schedules.first)
    DayliDataManager.shared.deleteEmptyMarkDateCountersFromCurrent()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    breakingButton.isHidden = true
    title = nil
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    breakingButton.isHidden = false
    titleFor = schedules.first?.overLimit()
  }

  
  // MARK: - Table view data source
  
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return schedules.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let schedule = schedules[indexPath.row]
    let scenario = Scenario.getScenarioCase(from: schedule.scenario)
    var cell: CellProtocol
    if schedule.isToday {
      switch scenario {
      case .accountingOnly:
        cell = tableView.dequeueReusableCell(withIdentifier: "accounting", for: indexPath) as! CigaretteAccountingCell
      case .withInterval:
        cell = tableView.dequeueReusableCell(withIdentifier: "interval", for: indexPath) as! CigaretteIntervalCell
      case .withLimit:
        cell = tableView.dequeueReusableCell(withIdentifier: "limit", for: indexPath) as! CigaretteLimitCell
      case .withLimitAndInterval:
        cell = tableView.dequeueReusableCell(withIdentifier: "limitInterval", for: indexPath) as! CigaretteLimitIntervalCell
      case .withLimitAndReduce:
        cell = tableView.dequeueReusableCell(withIdentifier: "limitReduce", for: indexPath) as! CigaretteLimitReduceCell
      case .withLimitAndIntervalAndReduce:
        cell = tableView.dequeueReusableCell(withIdentifier: "limitIntervalReduce", for: indexPath) as! CigaretteLimitIntervalReduceCell
      }
      titleFor = schedule.overLimit()
    } else {
      cell = tableView.dequeueReusableCell(withIdentifier: "notToday", for: indexPath) as! NotTodayCell
    }
    cell.setValues(schedule)
    return cell as! UITableViewCell
  }
  
  // MARK: - Table view delegate
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if !tableView.isEditing {
      AppDelegate.shared.rootViewController.showTabBarViewController()
    }
  }
  
  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
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
      ScheduleDataManager.shared.deleteSchedule(schedule)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  // MARK: - Private func
  
  
  private func setupViewGradient() {
    tableView.separatorColor = .gray
    
  }
  
  private func registerCell() {
    let notTodayCell = UINib(nibName: "NotTodayCell", bundle: nil)
    tableView.register(notTodayCell, forCellReuseIdentifier: "notToday")
    let accountingCell = UINib(nibName: "CigaretteAccountingCell", bundle: nil)
    tableView.register(accountingCell, forCellReuseIdentifier: "accounting")
    let limitCell = UINib(nibName: "CigaretteLimitCell", bundle: nil)
    tableView.register(limitCell, forCellReuseIdentifier: "limit")
    let intervalCell = UINib(nibName: "CigaretteIntervalCell", bundle: nil)
    tableView.register(intervalCell, forCellReuseIdentifier: "interval")
    let limitIntervalCell = UINib(nibName: "CigaretteLimitIntervalCell", bundle: nil)
    tableView.register(limitIntervalCell, forCellReuseIdentifier: "limitInterval")
    let limitReduceCell = UINib(nibName: "CigaretteLimitReduceCell", bundle: nil)
    tableView.register(limitReduceCell, forCellReuseIdentifier: "limitReduce")
    let limitIntervalReduceCell = UINib(nibName: "CigaretteLimitIntervalReduceCell", bundle: nil)
    tableView.register(limitIntervalReduceCell, forCellReuseIdentifier: "limitIntervalReduce")
  }
  
  private func setupNavigationItem() {
    if tableView.isEditing {
      navigationItem.setRightBarButton(deleteButton, animated: true)
      navigationItem.setLeftBarButton(doneButton, animated: true)
    } else {
      navigationItem.setRightBarButton(composeButton, animated: true)
      navigationItem.setLeftBarButton(editButton, animated: true)
    }
  }
  
  private func setupBarButtonItems() {
    composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeCurrentSchedule))
    editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editingTable))
    doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editingTable))
    deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteRows))
    deleteButton.isEnabled = false
  }
  
  
  private func createButton() {
    let frame = self.view.frame
    let side = frame.height / 10
    let xPoint = (frame.width / 2) - (side / 2)
    let yPoint = frame.height - frame.height / 8
    breakingButton = UIButton(frame: CGRect(origin: CGPoint(x: xPoint,
                                                            y: yPoint),
                                            size: CGSize(width: side, height: side)))
    
    breakingButton.backgroundColor = .clear
    if view.traitCollection.userInterfaceStyle == .dark {
      breakingButton.setImage(UIImage(named: "Button-dark"), for: .normal)
      breakingButton.layer.borderColor = UIColor.lightGray.cgColor
    } else {
      breakingButton.setImage(UIImage(named: "Button-white"), for: .normal)
      breakingButton.layer.borderColor = UIColor.black.cgColor
    }
    breakingButton.clipsToBounds = true
    breakingButton.layer.cornerRadius = side / 2
    breakingButton.layer.borderWidth = 1.5
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
    schedules = ScheduleDataManager.shared.getDescendingSortedSchedules()
    checkTodayScheduleWhenAppRun()
  }
    
  private func checkTodaySchedule() {
    let currentDateString = DateManager.shared.getStringDate(date: Date()) { DateManager.dateStringFormat }
    guard let lastShedule = schedules.first, lastShedule.currentStringDate != currentDateString else { return }
    createCurrentScheduleWithLastProperties(from: lastShedule)
    ScheduleDataManager.shared.updateToYesterday(schedule: schedules[1])
    checkLastDayliCount()
    schedules = ScheduleDataManager.shared.getDescendingSortedSchedules()
    titleFor = schedules[0].overLimit()
    tableView.reloadData()
  }
  
  private func checkLastDayliCount() {
    let schedules = ScheduleDataManager.shared.getDescendingSortedSchedules()
    let preLastSchedule = schedules[1]
    guard DayliDataManager.shared.getDayliCount(for: preLastSchedule.currentStringDate) == 0 else { return }
    if let lastDayliCounter = DayliDataManager.shared.getDayliCounter(for: preLastSchedule.currentStringDate) {
      DayliDataManager.shared.deleteDayliCounter(lastDayliCounter)
    }
    ScheduleDataManager.shared.deleteSchedule(preLastSchedule)
  }
  
  private func checkTodayScheduleWhenAppRun() {
    checkTodaySchedule()
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] (_) in
      self.checkTodaySchedule()
    }
  }
  
  private func createCurrentScheduleWithLastProperties(from lastSchedule: CigaretteScheduleModel) {
    ScheduleDataManager.shared.createNewSchedule(mark: lastSchedule.mark,
                                         price: lastSchedule.price,
                                         packSize: lastSchedule.packSize,
                                         scenario: lastSchedule.scenario,
                                         limit: lastSchedule.limit.value,
                                         interval: lastSchedule.interval.value,
                                         reduceCig: lastSchedule.reduceCig.value,
                                         reducePerDay: lastSchedule.reducePerDay.value,
                                         beginReduceDate: lastSchedule.beginReduceDate,
                                         lastTimeSmoke: lastSchedule.lastTimeSmoke)
  }
  
  private func checkAndCreateCountersFor(currentSchedule: CigaretteScheduleModel?) {
    guard let currentSchedule = currentSchedule else { return }
    let mark = currentSchedule.mark
    let price = currentSchedule.price
    let packSize = currentSchedule.packSize
    let dateString = currentSchedule.currentStringDate
    if DayliDataManager.shared.getDayliCounter(for: dateString) == nil {
      DayliDataManager.shared.createDayliCounter(date: dateString, mark: mark, price: price, perPack: packSize)
    }
  }
  
  // MARK: - @obcj private func
  
  
  @objc private func composeCurrentSchedule() {
    let currentSchedule = schedules.first
    AppDelegate.shared.rootViewController.showAddNewSheduleController(currentSchedule)
  }
  
  @objc private func editingTable() {
      tableView.setEditing(!tableView.isEditing, animated: true)
      setupNavigationItem()
  }
  // TODO: DeleteRows!!!
  @objc private func deleteRows() {
    
  }
  
  @objc private func increaceCount() {
    let current = schedules.first
    guard let currentSchedule = current else { return }
    currentSchedule.getLastTime()
    currentSchedule.getTimer(isActive: true)
    currentSchedule.incrementCount()
    setNotification(schedule: current)
    tableView.reloadData()
  }
  
  private func setNotification(schedule: CigaretteScheduleModel?) {
    guard let schedule = schedule else { return }
    if let interval = schedule.interval.value {
      notifications.intervalNotification(timeInterval: interval)
    }
    if schedule.isOverLimit() && schedule.overLimitDifference() == 1 {
      notifications.overLimitNotification(limit: schedule.limit.value!)
    }
    if let limit = schedule.limit.value, limit == 1, schedule.reduceCig.value != nil {
      if DayliDataManager.shared.isQuit() {
        notifications.reduceIsDoneNotification()
      }
    }
  }
}
