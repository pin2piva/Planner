//
//  NewScheduleTableViewController.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

protocol NewScheduleDelegate: class {
    func addDidFinish()
    func addDidCancel()
}

class NewScheduleTableViewController: UITableViewController {
    
    
    // MARK: - Text field section
    
    @IBOutlet private var textFields: [UITextField]! {
        didSet {
            textFields.forEach({ $0.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged) })
        }
    }
    
    // MARK: - Limit section
    
    @IBOutlet private weak var limitSwitch: UISwitch!
    @IBOutlet private weak var limitCell: UITableViewCell!
    @IBOutlet private var limitLabels: [UILabel]!
    @IBOutlet private weak var limitPicker: UIPickerView! {
        didSet {
            limitPicker.dataSource = self
            limitPicker.delegate = self
        }
    }
    
    
    // MARK: - Interval section
    
    @IBOutlet private weak var intervalSwitch: UISwitch!
    @IBOutlet private weak var intervalCell: UITableViewCell!
    @IBOutlet private var intervalLabels: [UILabel]!
    @IBOutlet private weak var intervalPicker: UIDatePicker! {
        didSet {
            intervalPicker.addTarget(self, action: #selector(timerInputAction(sender:)), for: .allEvents)
        }
    }
    
    
    // MARK: - Reduce section
    
    @IBOutlet private weak var reduceSwitch: UISwitch!
    @IBOutlet private weak var reduceCell: UITableViewCell!
    @IBOutlet private var reduceLabels: [UILabel]!
    @IBOutlet private weak var reducePicker: UIPickerView! {
        didSet {
            reducePicker.delegate = self
            reducePicker.dataSource = self
        }
    }
    
    
    // MARK: - Private properties
    
    private var saveButton: UIBarButtonItem!
    private var lastTimeSmoke: Date?
    private var scenario: String {
        Scenario.getScenario(limitSwitch.isOn, intervalSwitch.isOn, reduceSwitch.isOn)
    }
    
    // MARK: - Bool private properties
    
    
    private var limitIsOn = false {
        willSet {
            if !newValue && viewIfLoaded != nil {
                limitCellIsSelect = newValue
            }
        }
    }
    private var intervalIsOn = false {
        willSet {
            if !newValue && viewIfLoaded != nil {
                intervalCellIsSelect = newValue
            }
        }
    }
    private var reduceIsOn = false {
        willSet {
            if !newValue && viewIfLoaded != nil {
                reduceCellIsSelect = newValue
            }
        }
    }
    private var limitCellIsSelect = false {
        willSet {
            setValueToPicker(row: limitLabels[1].text)
        }
    }
    private var intervalCellIsSelect = false {
        willSet {
            setIntervalToIntervalPicker()
        }
    }
    private var reduceCellIsSelect = false {
        willSet {
            setValueToPicker(row: reduceLabels[0].text, second: reduceLabels[3].text)
        }
    }
    private var hasChanges: Bool {
        return fieldsHaveChanges()
    }
    
    
    // MARK: - Original private properties
    
    private var originalMark = "" {
        didSet {
            editedMark = originalMark
        }
    }
    private var originalPrice: Float = 0.0 {
        didSet {
            editedPrice = originalPrice
        }
    }
    private var originalPackSize: Int = 0 {
        didSet {
            editedPackSize = originalPackSize
        }
    }
    private var originalLimit: Int? {
        didSet {
            editedLimit = originalLimit
        }
    }
    private var originalInterval: TimeInterval? {
        didSet {
            editedInterval = originalInterval
        }
    }
    private var originalReduceCig: Int? {
        didSet {
            editedReduceCig = originalReduceCig
        }
    }
    private var originalReducePerDay: Int? {
        didSet {
            editedReducePerDay = originalReducePerDay
        }
    }
    
    
    // MARK: - Edited private properties
    
    private var editedMark = "" {
        didSet {
            viewIfLoaded?.layoutIfNeeded()
        }
    }
    private var editedPrice: Float = 0.0 {
        didSet {
            viewIfLoaded?.layoutIfNeeded()
        }
    }
    private var editedPackSize: Int = 0 {
        didSet {
            viewIfLoaded?.layoutIfNeeded()
        }
    }
    private var editedLimit: Int? {
        didSet {
            checkChangesInPickerValue()
        }
    }
    private var editedInterval: TimeInterval? {
        didSet {
            checkChangesInPickerValue()
        }
    }
    private var editedReduceCig: Int? {
        didSet {
            checkChangesInPickerValue()
        }
    }
    private var editedReducePerDay: Int? {
        didSet {
            checkChangesInPickerValue()
        }
    }
    

    // MARK: - Delegate
    
    weak var delegate: NewScheduleDelegate?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSelectionToSwitches()
        setupBarButtonItems()
        setValuesToFields()
        
        
        
        title = "Add New Shedule"
    }
    
    
    override func viewWillLayoutSubviews() {
        isModalInPresentation = hasChanges
        saveButton.isEnabled = hasChanges
    }
    
    
    // MARK: - IBActions
    
    @IBAction func switchesAction(_ sender: UISwitch) {
        switchAction(with: sender)
    }
    
    
    // MARK: - Static methods
    
    static func stodyboardInstance() -> NewScheduleTableViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(identifier: String(describing: self)) as? NewScheduleTableViewController
    }
    
    
    // MARK: - Internal methods
    
    func setVaulesToOriginalProperties(from schedule: CigaretteScheduleModel) {
        originalMark            = schedule.mark
        originalPrice           = schedule.price
        originalPackSize        = schedule.packSize
        originalInterval        = schedule.interval.value
        originalLimit           = schedule.limit.value
        originalReduceCig       = schedule.reduceCig.value
        originalReducePerDay    = schedule.reducePerDay.value
        lastTimeSmoke           = schedule.lastTimeSmoke
        let selection = Scenario.getCurrentSelection(schedule.scenario)
        setSelection(selection)
    }

    
    // MARK: - Private methods
    
    private func setValuesToFields() {
        textFields[0].text = originalMark
        if originalPrice != 0 {
            textFields[1].text = String(originalPrice)
        } else {
            textFields[1].text = ""
        }
        if originalPackSize != 0 {
            textFields[2].text = String(originalPackSize)
        } else {
            textFields[2].text = ""
        }
        if let limit = originalLimit {
            limitLabels[1].text = String(limit)
        }
        if let interval = originalInterval {
            intervalLabels[1].text = getTimeFrom(interval)
        }
        if let reduceCig = originalReduceCig {
            reduceLabels[0].text = String(reduceCig)
        }
        if let reducePerDay = originalReducePerDay {
            reduceLabels[3].text = String(reducePerDay)
        }
    }
    
    private func getTimeFrom(_ timeInterval: Double) -> String? {
        let currentDate = Date()
        let dateWithInterval = Date(timeIntervalSinceNow: timeInterval)
        let stringInterval = DateManager.shared.getStringDifferenceBetween(components: [.hour, .minute], currentDate, and: dateWithInterval) {"HH:mm"}
        return stringInterval
    }
    
    private func checkChangesInPickerValue() {
        if (viewIfLoaded != nil) {
            saveButton.isEnabled = hasChanges
        }
    }
    
    private func setSelection(_ selection: (Bool, Bool, Bool)) {
        self.limitIsOn = selection.0
        self.intervalIsOn = selection.1
        self.reduceIsOn = selection.2
    }
    
    private func setSelectionToSwitches() {
        limitSwitch.setOn(limitIsOn, animated: true)
        intervalSwitch.setOn(intervalIsOn, animated: true)
        reduceSwitch.setOn(reduceIsOn, animated: true)
    }
    
    private func switchAction(with sender: UISwitch) {
         switch sender.tag {
         case 0:
             limitCellIsSelect = false
             setColorToTextIn(limitLabels, limitCellIsSelect)
             if !sender.isOn {
                 reduceSwitch.setOn(false, animated: true)
                 reduceCellIsSelect = true
                 setHideTo(cell: reduceCell, when: &reduceCellIsSelect, colorFor: reduceLabels)
             }
         case 1:
             intervalCellIsSelect = false
             setColorToTextIn(intervalLabels, intervalCellIsSelect)
         case 2:
             reduceCellIsSelect = false
             setColorToTextIn(reduceLabels, reduceCellIsSelect)
             if sender.isOn {
                 limitSwitch.setOn(true, animated: true)
             }
         default:
             return
         }
         view.endEditing(true)
         tableUpdates()
     }
    
    private func setupBarButtonItems() {
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        saveButton.isEnabled = false
        navigationItem.setRightBarButton(saveButton, animated: true)
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearAllFields))
        navigationItem.setLeftBarButton(refreshButton, animated: true)
    }
    
    private func scrollToUnhidePicker(indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [unowned self] in
            self.tableView.scrollToRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section), at: .middle, animated: true)
        }
    }
    
    private func setHideTo(cell: UITableViewCell!, when: inout Bool, colorFor labels: [UILabel]!) {
        when.toggle()
        cell.setSelected(false, animated: true)
        setColorToTextIn(labels, when)
    }
    
    private func setColorToTextIn(_ labels: [UILabel]!, _ when: Bool) {
        if when {
            labels.forEach({ $0.textColor = .systemBlue })
        } else {
            labels.forEach({ $0.textColor = .label })
        }
    }
    
    private func getHeightForRow(_ switcher: UISwitch!, cell isSelected: Bool, row: Int) -> CGFloat {
        switch row {
        case 1:
            return 0
        case 2:
            return switcher.isOn ? 50 : 0
        case 3:
            return isSelected ? 200 : 0
        default:
            return 50
        }
    }
    
    private func setSelectionStyle(to cell: UITableViewCell, style: UITableViewCell.SelectionStyle) {
        if cell == limitCell {
            limitCell.selectionStyle = style
        } else if cell == intervalCell {
            intervalCell.selectionStyle = style
        } else if cell == reduceCell {
            reduceCell.selectionStyle = style
        }
    }
    
    private func tableUpdates() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func fieldsHaveChanges() -> Bool {
        if  originalMark            == editedMark &&
            originalPrice           == editedPrice &&
            originalPackSize        == editedPackSize &&
            originalLimit           == editedLimit &&
            originalInterval        == editedInterval &&
            originalReduceCig       == editedReduceCig &&
            originalReducePerDay    == editedReducePerDay &&
            limitIsOn               == limitSwitch.isOn &&
            intervalIsOn            == intervalSwitch.isOn &&
            reduceIsOn              == reduceSwitch.isOn {
            return false
        }
        return true
    }
    
    private func setIntervalToIntervalPicker() {
        guard let dateString = intervalLabels[1].text else { return }
        guard let date = DateManager.shared.getDate(from: dateString, {"HH:mm"}) else { return }
        intervalPicker.setDate(date, animated: false)
        timerInputAction(sender: intervalPicker)
    }
    
    private func setValueToPicker(row first: String?, second: String? = nil) {
        guard let first = first else { return }
        guard let firstRow = Int(first) else { return }
        guard let second = second else {
            limitPicker.selectRow(firstRow - 1, inComponent: 0, animated: false)
            return
        }
        guard let secondRow = Int(second) else { return }
        reducePicker.selectRow(firstRow - 1, inComponent: 0, animated: false)
        reducePicker.selectRow(secondRow - 1, inComponent: 1, animated: false)
        
    }
    
    private func saveNewShedule() {
        getShedule()
    }
    
    // MARK: - objc private methods
    
    @objc private func save() {
        saveNewShedule()
    }
    
    @objc private func clearAllFields() {
        let defaultModel = CigaretteScheduleModel()
        setVaulesToOriginalProperties(from: defaultModel)
        setValuesToFields()
        setSelectionToSwitches()
        tableUpdates()
    }
    
    @objc private func timerInputAction(sender: UIDatePicker) {
        let date = sender.date
        editedInterval = sender.countDownDuration
        intervalLabels[1].text = DateManager.shared.getStringDate(date: date) {"HH:mm"}
    }
    
    @objc private func textDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        switch sender.tag {
        case 0:
            editedMark = text
        case 1:
            guard text != "" || text.first != "." || text.last != "." || text.filter({ $0 == "." }).count <= 1 else {
                editedPrice = 0.0
                return
            }
            guard let price = Float(text) else { return }
            editedPrice = price
        case 2:
            guard text != "" else {
                editedPackSize = 0
                return
            }
            guard let packSize = Int(text) else { return }
            editedPackSize = packSize
        default:
            break
        }
        view.setNeedsLayout()
    }
    
}


// MARK: - extensions



// MARK: - Get model

extension NewScheduleTableViewController {
    private func getShedule() {
        do {
            try checkMark()
            try checkPrice()
            try checkPackSize()
            DataManager.shared.createNewSchedule(mark: editedMark,
                                                 price: editedPrice,
                                                 packSize: editedPackSize,
                                                 scenario: scenario,
                                                 limit: editedLimit,
                                                 interval: editedInterval,
                                                 reduceCig: editedReduceCig,
                                                 reducePerDay: editedReducePerDay,
                                                 lastTimeSmoke: lastTimeSmoke)
            if UserDefaults.standard.bool(forKey: "NOTfirstTime") {
                delegate?.addDidFinish()
            } else {
                UserDefaults.standard.set(true, forKey: "NOTfirstTime")
                AppDelegate.shared.rootViewController.showMainTable()
            }
        } catch Errors.wrongPrice {
            showWrongPriceAlert()
        } catch Errors.haveNoMark {
            showHaveNoMarkAlert()
        } catch Errors.haveNoPackSize {
            showNoPackAlert()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func showWrongPriceAlert() {
        AlertManager.showAlert(title: .wrongPrice, message: .wrongPrice, style: .alert, presentIn: self) { () -> [UIAlertAction] in
            let okAction = UIAlertAction(title: "OK", style: .cancel) { [unowned self] (_) in
                self.textFields[1].text = ""
            }
            return [okAction]
        }
    }
    
    private func showHaveNoMarkAlert() {
        AlertManager.showAlert(title: .haveNoMark, message: .haveNoMark, style: .alert, presentIn: self) { () -> [UIAlertAction] in
            let returnAction = UIAlertAction(title: "Ввести марку", style: .default, handler: nil)
            let continueAction = UIAlertAction(title: "Сохранить", style: .default) { [unowned self] (_) in
                self.editedMark = "unknown"
                self.textFields[0].text = self.editedMark
                self.saveNewShedule()
            }
            return [returnAction, continueAction]
        }
    }
    
    private func showNoPackAlert() {
        AlertManager.showAlert(title: .haveNoPackSize, message: .haveNoPackSize, style: .alert, presentIn: self) { () -> [UIAlertAction] in
            let returnAction = UIAlertAction(title: "Ввести количество", style: .default, handler: nil)
            let continueAction = UIAlertAction(title: "Сохранить", style: .default) { [unowned self] (_) in
                self.editedPackSize = 20
                self.textFields[2].text = "20"
                self.saveNewShedule()
            }
            return [returnAction, continueAction]
        }
    }
    
    private func checkPrice() throws {
        guard editedPrice != 0.0 else {
            throw Errors.wrongPrice
        }
    }
    
    private func checkMark() throws {
        guard editedMark != "" else {
            throw Errors.haveNoMark
        }
    }
    
    private func checkPackSize() throws {
        guard editedPackSize != 0 else {
            throw Errors.haveNoPackSize
        }
    }
    
}


// MARK: - Text Field Delegate

extension NewScheduleTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


// MARK: - Picker view data source

extension NewScheduleTableViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return 40
        case 1:
            switch component {
            case 0:
                return 10
            case 1:
                return 10
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
}


// MARK: - Picker view delegate

extension NewScheduleTableViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            editedLimit = row + 1
            limitLabels[1].text = "\(row + 1)"
            limitLabels[0].text = row == 0 ? "Cigarette per day" : "Cigarettes per day"
            if row < reducePicker.selectedRow(inComponent: 0) && row < 10 {
                reducePicker.selectRow(row, inComponent: 0, animated: true)
                reduceLabels[0].text = "\(row + 1)"
            }
        case 1:
            switch component {
            case 0:
                editedReduceCig = row + 1
                reduceLabels[0].text = "\(row + 1)"
                reduceLabels[1].text = row == 0 ? "cigarette" : "cigarettes"
                if row > limitPicker.selectedRow(inComponent: 0) {
                    limitPicker.selectRow(row, inComponent: 0, animated: true)
                    limitLabels[1].text = "\(row + 1)"
                }
            case 1:
                editedReducePerDay = row + 1
                reduceLabels[3].text = "\(row + 1)"
                reduceLabels[4].text = row == 0 ? "day" : "days"
            default:
                break
            }
        default:
            break
        }
    }
    
}


// MARK: - Adaptive presentation controller delegate

extension NewScheduleTableViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        AlertManager.showAlert(title: .naveChanges, message: .haveChanges, style: .actionSheet, presentIn: self) { () -> [UIAlertAction] in
            let discardAction = UIAlertAction(title: "Выйти", style: .destructive) { [unowned self] (_) in
                self.delegate?.addDidCancel()
            }
            let continueAction = UIAlertAction(title: "Продолжить", style: .cancel, handler: nil)
            return [discardAction, continueAction]
        }
    }
}


// MARK: - Table view delegate

extension NewScheduleTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return getHeightForRow(limitSwitch, cell: limitCellIsSelect, row: indexPath.row)
        case 2:
            return getHeightForRow(intervalSwitch, cell: intervalCellIsSelect, row: indexPath.row)
        case 3:
            return getHeightForRow(reduceSwitch, cell: reduceCellIsSelect, row: indexPath.row)
        default:
            return 50
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 2:
                setHideTo(cell: limitCell, when: &limitCellIsSelect, colorFor: limitLabels)
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 2:
                setHideTo(cell: intervalCell, when: &intervalCellIsSelect, colorFor: intervalLabels)
                scrollToUnhidePicker(indexPath: indexPath)
            default:
                break
            }
        case 3:
            switch indexPath.row {
            case 2:
                reduceCell.selectionStyle = .default
                setHideTo(cell: reduceCell, when: &reduceCellIsSelect, colorFor: reduceLabels)
                scrollToUnhidePicker(indexPath: indexPath)
            default:
                break
            }
        default:
            break
        }
        view.endEditing(true)
        tableUpdates()
    }
}
