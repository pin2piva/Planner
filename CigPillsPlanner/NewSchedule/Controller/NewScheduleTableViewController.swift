//
//  NewScheduleTableViewController.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

protocol AddNewSheduleTableDelegate: class {
    func addDidFinish(_ addNewSheduleTable: NewScheduleTableViewController)
    func addDidCancel(_ addNewSheduleTable: NewScheduleTableViewController)
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
    
    var saveButton: UIBarButtonItem!
    
    private let intervalFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    private var limitCellIsSelect = false {
        willSet {
            limitPicker.isHidden = limitCellIsSelect
            setValueToPicker(row: limitLabels[1].text)
        }
    }
    private var intervalCellIsSelect = false {
        willSet {
            intervalPicker.isHidden = intervalCellIsSelect
            setIntervalToIntervalPicker()
        }
    }
    private var reduceCellIsSelect = false {
        willSet {
            reducePicker.isHidden = reduceCellIsSelect
            setValueToPicker(row: reduceLabels[0].text, second: reduceLabels[3].text)
        }
    }
    
    private var hasChanges: Bool {
        textFields.reduce(0, { $0 + $1.text!.count }) > 0
    }
    
    
// MARK: - Model properties
    private var mark = ""
    private var price: Float?
    private var packSize: Int?
    private var limit: Int? = 1
    private var interval: TimeInterval? = 300
    private var reduce = (1, 1)
    
    var model: CigaretteSheduleModel!
    

// MARK: - Scenario
    lazy private var scenario: Scenario = {
        if !limitSwitch.isOn && !intervalSwitch.isOn && !reduceSwitch.isOn {
            return Scenario.accountingOnly
        } else if limitSwitch.isOn && reduceSwitch.isOn && !intervalSwitch.isOn {
            return Scenario.withLimitAndReduce
        } else if !limitSwitch.isOn && !reduceSwitch.isOn && intervalSwitch.isOn {
            return Scenario.withInterval
        } else {
            return Scenario.withLimitAndIntervalAndReduce
        }
    }()
    
    
// MARK: - Delegate
    
    
    weak var delegate: AddNewSheduleTableDelegate?
        
// MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSaveButton()
        title = "Add New Shedule"
    }
    
    
    override func viewWillLayoutSubviews() {
        isModalInPresentation = hasChanges
        saveButton.isEnabled = hasChanges
    }


// MARK: - Table view delegate
    
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
    
// MARK: - IBActions
    
    @IBAction func switchesAction(_ sender: UISwitch) {
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
    
// MARK: - Private methods
    
    private func addSaveButton() {
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        saveButton.isEnabled = false
        navigationItem.setRightBarButton(saveButton, animated: true)
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
    
    private func setIntervalToIntervalPicker() {
        guard let dateString = intervalLabels[1].text else { return }
        guard let date = intervalFormatter.date(from: dateString) else { return }
        intervalPicker.setDate(date, animated: false)
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
    
    @objc private func timerInputAction(sender: UIDatePicker) {
        let date = sender.date
        interval = sender.countDownDuration
        intervalLabels[1].text = intervalFormatter.string(from: date)
    }
    
    @objc private func textDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        switch sender.tag {
        case 0:
            mark = text
        case 1:
            guard text.first != "." || text.last != "." || text.filter({ $0 == "." }).count <= 1 || text != "" else {
                price = nil
                return
            }
            price = Float(text)
        case 2:
            guard text != "" else {
                packSize = nil
                return
            }
            packSize = Int(text)
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
            let pack = try getPack()
            switch scenario {
            case .accountingOnly:
                model = CigaretteSheduleModel(pack: pack, scenario: scenario)
            case .withInterval:
                model = CigaretteSheduleModel(pack: pack, interval: interval, scenario: scenario)
            case .withLimitAndReduce:
                model = CigaretteSheduleModel(pack: pack, perDay: limit, reduce: reduce, scenario: scenario)
            case .withLimitAndIntervalAndReduce:
                model = CigaretteSheduleModel(pack: pack, perDay: limit, interval: interval, reduce: reduce, scenario: scenario)
            }
            delegate?.addDidFinish(self)
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
                self.mark = "unknown"
                self.textFields[0].text = self.mark
                self.saveNewShedule()
            }
            return [returnAction, continueAction]
        }
    }
    
    private func showNoPackAlert() {
        AlertManager.showAlert(title: .haveNoPackSize, message: .haveNoPackSize, style: .alert, presentIn: self) { () -> [UIAlertAction] in
            let returnAction = UIAlertAction(title: "Ввести количество", style: .default, handler: nil)
            let continueAction = UIAlertAction(title: "Сохранить", style: .default) { [unowned self] (_) in
                self.packSize = 20
                self.textFields[2].text = "20"
                self.saveNewShedule()
            }
            return [returnAction, continueAction]
        }
    }
    
    private func getPack() throws -> PackModel {
        guard let price = price else {
            throw Errors.wrongPrice
        }
        guard mark != "" else {
            throw Errors.haveNoMark
        }
        guard let packSize = packSize else {
            throw Errors.haveNoPackSize
        }
        return PackModel(mark: mark, price: price, piecesInPack: packSize)
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
            limit = row + 1
            limitLabels[1].text = "\(row + 1)"
            limitLabels[0].text = row == 0 ? "Cigarette per day" : "Cigarettes per day"
            if row < reducePicker.selectedRow(inComponent: 0) && row < 10 {
                reducePicker.selectRow(row, inComponent: 0, animated: true)
                reduceLabels[0].text = "\(row + 1)"
            }
        case 1:
            switch component {
            case 0:
                reduce.0 = row + 1
                reduceLabels[0].text = "\(row + 1)"
                reduceLabels[1].text = row == 0 ? "cigarette" : "cigarettes"
                if row > limitPicker.selectedRow(inComponent: 0) {
                    limitPicker.selectRow(row, inComponent: 0, animated: true)
                    limitLabels[1].text = "\(row + 1)"
                }
            case 1:
                reduce.1 = row + 1
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
                self.delegate?.addDidCancel(self)
            }
            let continueAction = UIAlertAction(title: "Продолжить", style: .cancel, handler: nil)
            return [discardAction, continueAction]
        }
    }
}
