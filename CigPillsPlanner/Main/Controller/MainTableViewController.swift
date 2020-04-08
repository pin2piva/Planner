//
//  MainTableViewController.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    private var breakingButton: UIButton!
    
    var storage = CigaretteSheduleStorageModel()
        
// MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CigAccountingCell", bundle: nil), forCellReuseIdentifier: "Cell")
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
        if storage.counter.isEmpty {
            breakingButton.isEnabled = false
        } else {
            breakingButton.isEnabled = true
        }
    }
    
    @objc private func increaceCount() {
        storage.counter[0].lastReception = Date()
        storage.counter[0].counter += 1
        tableView.reloadData()
    }
    
// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.counter.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CigaretteCellProtocol
        cell.setValues(storage, indexPath: indexPath)
        return cell as! UITableViewCell
    }
    
// MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppDelegate.shared.rootViewController.showTabBarViewController()
    }
    
// MARK: - @obcj private methods
    
    @objc private func showAddNew() {
        AppDelegate.shared.rootViewController.showAddNewSheduleController()
    }

}
