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
    private var objects: Results<CigaretteCounterModel>!
    private var counterModel: CigaretteCounterModel!
        
// MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkHaveCounterModelInDB()
        tableView.register(UINib(nibName: "CigaretteAccountingCell", bundle: nil), forCellReuseIdentifier: "Cell")
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddNew)), animated: true)
        createButton()
        
    }
    
    override func viewWillLayoutSubviews() {
        breakingButtonEnabling()
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
        if counterModel.counter.isEmpty {
            breakingButton.isEnabled = false
        } else {
            breakingButton.isEnabled = true
        }
    }
    
    private func checkHaveCounterModelInDB() {
        guard let objects = DataManager.shared.retrieveCigCounterFromDataBase() else {
            print("что-то с базой данных. Не сработал мето \(#function)")
            return
        }
        self.objects = objects
        guard objects.count != 0 else {
            counterModel = CigaretteCounterModel()
            DataManager.shared.saveObject(counterModel)
            return
        }
        counterModel = objects.first!
    }
    
    func workWithCigaretteCounter(_ model: CigaretteScheduleModel) {
        DataManager.shared.insertNewObject(counterModel, model: model)
        tableView.reloadData()
    }
    
    @objc private func increaceCount() {
        DataManager.shared.updateCountInObject(cigCounter: counterModel)
        tableView.reloadData()
    }
    
// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counterModel.counter.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CigaretteCellProtocol
        cell.setValues(counterModel, indexPath: indexPath)
        return cell as! UITableViewCell
    }
    
// MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppDelegate.shared.rootViewController.showTabBarViewController()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.shared.deleteCigSchedule(objects[0], indexPath: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
// MARK: - @obcj private methods
    
    @objc private func showAddNew() {
        AppDelegate.shared.rootViewController.showAddNewSheduleController()
    }

}

