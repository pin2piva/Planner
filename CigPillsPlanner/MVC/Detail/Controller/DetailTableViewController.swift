//
//  DetailTableViewController.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

// TODO: - Попробовать сделать сегментед как отделный файл

class DetailTableViewController: UITableViewController {
  
  // MARK: - Custom segment outlets
  
  @IBOutlet weak var commonView: UIView!
  @IBOutlet var staticViews: [UIView]!
  @IBOutlet var dynamicViews: [UIView]!
  @IBOutlet var buttons: [UIButton]!
  @IBOutlet var leftConstraints: [NSLayoutConstraint]!
  @IBOutlet var rightConstraints: [NSLayoutConstraint]!
  
  // MARK: - From date outlets
  
  
  @IBOutlet var fromLabels: [UILabel]!
  @IBOutlet weak var fromCell: UITableViewCell!
  @IBOutlet weak var fromDatePicker: UIDatePicker! {
    didSet {
      fromDatePicker.setDate(getMinDate()!, animated: false)
      fromDatePicker.minimumDate = getMinDate()
      fromDatePicker.addTarget(self, action: #selector(getDateFromDatePicker(sender:)), for: .valueChanged)
    }
  }
  
  // MARK: - To date outlets
  
  
  @IBOutlet var toLabels: [UILabel]!
  @IBOutlet weak var toCell: UITableViewCell!
  @IBOutlet weak var toDatePicker: UIDatePicker! {
    didSet {
      toDatePicker.setDate(Date(), animated: false)
      toDatePicker.minimumDate = getMinDate()
      toDatePicker.addTarget(self, action: #selector(getDateFromDatePicker(sender:)), for: .valueChanged)
    }
  }
  
  // MARK: - Mark outlets
  
  
  @IBOutlet var markLabels: [UILabel]!
  @IBOutlet weak var markCell: UITableViewCell!
  @IBOutlet weak var markPicker: UIPickerView! {
    didSet {
      markPicker.delegate = self
      markPicker.dataSource = self
    }
  }
  
  // MARK: - Price outlets
  
  
  @IBOutlet var priceLabels: [UILabel]!
  @IBOutlet weak var priceCell: UITableViewCell!
  @IBOutlet weak var pricePicker: UIPickerView! {
    didSet {
      pricePicker.delegate = self
      pricePicker.dataSource = self
    }
  }
  
  // MARK: - Detail labels
  
  
  @IBOutlet weak var countLabel: UILabel!
  @IBOutlet weak var spentLabel: UILabel!
  
  // MARK: - Private properties
  
  private var dayliCounters = [DayliCounter]() {
    didSet {
      markPicker.reloadAllComponents()
      print("dayliCounters change")
    }
  }
  
//  private var marks = [String]() {
//    didSet {
//      markPicker.reloadAllComponents()
//      setValues(to: markPicker, andTo: markLabels[1], from: marks)
//      if let mark = markLabels[1].text, marks.contains(mark) {
//        if let row = marks.enumerated().filter({ $0.element == mark }).first?.offset {
//          markPicker.selectRow(row, inComponent: 0, animated: true)
//        }
//      } else if marks.count > 0 {
//        markPicker.selectRow(0, inComponent: 0, animated: true)
//        markLabels[1].text = marks[markPicker.selectedRow(inComponent: 0)]
//      } else {
//        markLabels[1].text = "-"
//      }
//    }
//  }
//  private var prices = [String]() {
//    didSet {
//      pricePicker.reloadAllComponents()
//      setValues(to: pricePicker, andTo: priceLabels[1], from: prices)
//      if let price = priceLabels[1].text, prices.contains(price) {
//        if let row = prices.enumerated().filter({ $0.element == price }).first?.offset {
//          pricePicker.selectRow(row, inComponent: 0, animated: true)
//        }
//      } else if prices.count > 0 {
//        pricePicker.selectRow(0, inComponent: 0, animated: true)
//        priceLabels[1].text = prices[markPicker.selectedRow(inComponent: 0)]
//      } else {
//        priceLabels[1].text = "-"
//      }
//    }
//  }
//
//  private func setValues(to picker: UIPickerView, andTo label: UILabel, from array: [String]) {
//    if let price = label.text, array.contains(price) {
//      if let row = array.enumerated().filter({ $0.element == price }).first?.offset {
//        picker.selectRow(row, inComponent: 0, animated: true)
//      }
//    } else if array.count > 0 {
//      picker.selectRow(0, inComponent: 0, animated: true)
//      label.text = array[picker.selectedRow(inComponent: 0)]
//    } else {
//      label.text = "-"
//    }
//  }
  
  // MARK: - Internal properties
  
  
  let itemName = "Detail"
  
  // MARK: - Custom segment private properties
  
  
  private var totalSelection = true {
    willSet {
      buttonTapAnimation(newValue, tag: 0)
    }
  }
  private var dateSelection = false {
    willSet {
      buttonTapAnimation(newValue, tag: 1)
      setColorToLabels(selection: &fromCellIsSelected, labels: &fromLabels)
      setColorToLabels(selection: &toCellIsSelected, labels: &toLabels)
      newValue ? getDayliCountersFromDate() : getAllDayliCounters()
    }
  }
  private var markSelection = false {
    willSet {
      buttonTapAnimation(newValue, tag: 2)
      setColorToLabels(selection: &markCellIsSelected, labels: &markLabels)
      
    }
  }
  private var priceSelection = false {
    willSet {
      buttonTapAnimation(newValue, tag: 3)
      setColorToLabels(selection: &priceCellIsSelected, labels: &priceLabels)
    }
  }
  private var segmentSelection: [Bool] {
    [totalSelection, dateSelection, markSelection, priceSelection]
  }
  private var cellSelection: [Bool] {
    [fromCellIsSelected, toCellIsSelected, markCellIsSelected, priceCellIsSelected]
  }
  
  // MARK: - Cell selection private properties
  
  
  private var fromCellIsSelected = false {
    didSet {
      tableUpdates()
    }
  }
  private var toCellIsSelected = false {
    didSet {
      tableUpdates()
    }
  }
  private var markCellIsSelected = false {
    didSet {
      tableUpdates()
    }
  }
  private var priceCellIsSelected = false {
    didSet {
      tableUpdates()
    }
  }
  
  // MARK: - Private properties
  
  
  private var timer: Timer?
  
  // MARK: - Life cycle
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setInitialValuesToFilterLabels()
    setTotalValuesToLabels()
    checkDatePickerMaximumDate()
    getAllDayliCounters()
  }
  
  // MARK: - Deinit
  
  
  deinit {
    timer?.invalidate()
  }
  
  // MARK: - Table private func
  

  private func tableUpdates() {
    tableView.beginUpdates()
    tableView.endUpdates()
  }
  
  private func scrollToUnhidePicker(indexPath: IndexPath) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [unowned self] in
      self.tableView.scrollToRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section), at: .middle, animated: true)
    }
  }
  
  private func getHeightForRow(withSelected segments: [Bool], andSelected cells: [Bool], row: Int) -> CGFloat {
    switch row {
    case 0:
      return 50
    case 2, 5:
      return segments[1] ? 50 : 0
    case 3:
      return cells[0] ? 200 : 0
    case 6:
      return cells[1] ? 200 : 0
    case 8:
      return segments[2] ? 50 : 0
    case 9:
      return cells[2] ? 200 : 0
    case 11:
      return segments[3] ? 50 : 0
    case 12:
      return cells[3] ? 200 : 0
    default:
      return 0
    }
  }
  
  private func setSelectionStyle(to cell: UITableViewCell, style: UITableViewCell.SelectionStyle) {
    if cell == fromCell {
      fromCell.selectionStyle = style
    } else if cell == toCell {
      toCell.selectionStyle = style
    } else if cell == markCell {
      markCell.selectionStyle = style
    } else if cell == priceCell {
      priceCell.selectionStyle = style
    }
  }
  
  private func setColorToLabels(selection: inout Bool, labels: inout [UILabel]!) {
    selection = false
    StaticTableManager.shared.setColorToTextIn(labels, selection)
  }
  
  // MARK: - Segmented private func
  
  
  private func getCornerRadius(view: UIView) -> CGFloat {
    let height = view.bounds.height
    return height / 5
  }
  
  private func setupViews() {
    commonView.layer.cornerRadius = getCornerRadius(view: commonView)
    staticViews.forEach({ $0.layer.cornerRadius = getCornerRadius(view: $0) })
    dynamicViews.forEach({ $0.layer.cornerRadius = getCornerRadius(view: $0) })
    buttons.forEach({ $0.layer.cornerRadius = getCornerRadius(view: $0) })
    tableView.tableFooterView = UIView()
  }
  
  private func buttonTapped(_ tag: Int) {
    switch tag {
    case 0:
      setTotalSelectionFor(other: [markSelection, priceSelection, dateSelection])
    case 1:
      setSelectionFor(other: [priceSelection, markSelection], with: &dateSelection)
    case 2:
      setSelectionFor(other: [priceSelection, dateSelection], with: &markSelection)
    case 3:
      setSelectionFor(other: [markSelection, dateSelection], with: &priceSelection)
    default:
      break
    }
    tableUpdates()
  }
  
  private func setSelectionFor(other segments: [Bool], with taped: inout Bool) {
    if !segments.contains(true) && taped {
      totalSelection = true
    } else if !segments.contains(true) && !taped {
      totalSelection = false
    }
    taped.toggle()
  }
  
  private func setTotalSelectionFor(other segments: [Bool]) {
    if segments.contains(true) && !totalSelection {
      markSelection = false
      priceSelection = false
      dateSelection = false
    } else if !segments.contains(true) && totalSelection {
      return
    }
    totalSelection.toggle()
  }
  
  private func buttonTapAnimation(_ selection: Bool, tag: Int) {
    if selection {
      set(priority: 750, forConstraintWith: tag)
    } else {
      set(priority: 950, forConstraintWith: tag)
    }
    setAnimationWhenConstraintChange()
  }
  
  private func setAnimationWhenConstraintChange() {
    UIView.animate(withDuration: 0.25) { [weak self] in
      self?.tableView.layoutIfNeeded()
    }
  }
  
  private func set(priority: Float, forConstraintWith tag: Int) {
    leftConstraints[tag].priority = UILayoutPriority(priority)
    rightConstraints[tag].priority = UILayoutPriority(priority)
  }
  
  // MARK: - Date picker private func
  
  private func checkDatePickerMaximumDate() {
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] (timer) in
      self.toDatePicker.maximumDate = Date()
      self.fromDatePicker.maximumDate = Date()
    }
  }
  
  private func setValueToDateLabel(with tag: Int, date: Date) {
    let stringDate = DateManager.shared.getStringDate(date: date) { DateManager.dateStringFormat }
    switch tag {
    case 0:
      fromLabels[1].text = stringDate
    case 1:
      toLabels[1].text = stringDate
    default:
      break
    }
  }
  
  private func set(date: Date, toDatePicketWith tag: Int) {
    switch tag {
    case 0:
      if date > toDatePicker.date {
        toDatePicker.setDate(date, animated: true)
      }
    case 1:
      if date < fromDatePicker.date {
        fromDatePicker.setDate(date, animated: true)
      }
    default:
      break
    }
  }
  
  private func getMinDate() -> Date? {
    let dayliCounter = DayliDataManager.shared.getFirstDayliCounter()
    let date = DateManager.shared.getDate(from: dayliCounter.dateString) { DateManager.dateStringFormat }
    return date
  }
  
  private func setInitialValuesToFilterLabels() {
    fromLabels[1].text = DayliDataManager.shared.getFirstDayliCounter().dateString
    toLabels[1].text = DateManager.shared.getStringDate(date: Date()) { DateManager.dateStringFormat }
    markLabels[1].text = DayliDataManager.shared.getLastDayliCounter().mark.last?.mark
    if let text = DayliDataManager.shared.getLastDayliCounter().mark.last?.price {
      priceLabels[1].text = "\(text)"
    }
  }
  
  private func setTotalValuesToLabels() {
    countLabel.text = "\(DayliDataManager.shared.getTotalCount())"
    spentLabel.text = "\(DayliDataManager.shared.getTotalPrice().twoDecimalPlaces)"
  }
  
  // MARK: - Pickers private func

  
  private func getAllDayliCounters() {
    dayliCounters = DayliDataManager.shared.dayliCounters
  }
  
  private func getDayliCountersFromDate() {
    dayliCounters = DayliDataManager.shared.getDayliCounters(fromDate: fromDatePicker.date, toDate: toDatePicker.date)
  }
  
  // MARK: - Objc private func
  
  
  @objc private func getDateFromDatePicker(sender: UIDatePicker) {
    let date = sender.date
    let tag = sender.tag
    set(date: date, toDatePicketWith: tag)
    setValueToDateLabel(with: tag, date: date)
    getDayliCountersFromDate()
  }
  
  // MARK: - @IBActions
  
  
  @IBAction func buttonsAction(_ sender: UIButton) {
    buttonTapped(sender.tag)
  }
  
}

// MARK: - Extensions



// MARK: - Table view delegate


extension DetailTableViewController {
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return getHeightForRow(withSelected: segmentSelection, andSelected: cellSelection, row: indexPath.row)
    default:
      return 50
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 2:
        StaticTableManager.shared.setHideTo(cell: fromCell, when: &fromCellIsSelected, colorFor: fromLabels)
      case 5:
        StaticTableManager.shared.setHideTo(cell: toCell, when: &toCellIsSelected, colorFor: toLabels)
      case 8:
        StaticTableManager.shared.setHideTo(cell: markCell, when: &markCellIsSelected, colorFor: markLabels)
        scrollToUnhidePicker(indexPath: indexPath)
      case 11:
        StaticTableManager.shared.setHideTo(cell: priceCell, when: &priceCellIsSelected, colorFor: priceLabels)
        scrollToUnhidePicker(indexPath: indexPath)
      default:
        break
      }
    default:
      break
    }
  }
  
  override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    setSelectionStyle(to: cell, style: .none)
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    setSelectionStyle(to: cell, style: .gray)
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0
  }
  
}

// MARK: - Picker view data source


extension DetailTableViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch pickerView.tag {
    case 0:
      return marks.count
    case 1:
      return prices.count
    default:
      return 0
    }
  }
  
}

extension DetailTableViewController: UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch pickerView.tag {
    case 0:
      return marks[row]
    case 1:
      return prices[row]
    default:
      return nil
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch pickerView.tag {
    case 0:
      markLabels[1].text = marks[row]
    case 1:
      priceLabels[1].text = prices[row]
    default:
      break
    }
  }
  
  
}

extension DetailTableViewController: HaveTabBarItem {}
