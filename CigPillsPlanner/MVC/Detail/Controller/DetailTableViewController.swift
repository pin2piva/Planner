//
//  DetailTableViewController.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
  
  var itemName: String
  
  private var totalPrice: Double = 0
  private var totalCount: Int = 0
  private var totalLMPrice: Double = 0
  private var totalLMCount: Int = 0
  
  init(itemName: String) {
    self.itemName = itemName
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerCell()
    tableView.backgroundColor = .red
    totalPrice = DataManager.shared.getTotalPrice()
    totalCount = DataManager.shared.getTotalCount()
    totalLMPrice = DataManager.shared.getTotalPriceFor(mark: "LM")
    totalLMCount = DataManager.shared.getTotalCountFor(mark: "LM")
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 4
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
    switch indexPath.row {
    case 0:
      cell.setValues("Total price", "\(totalPrice)")
    case 1:
      cell.setValues("Total count", "\(totalCount)")
    case 2:
      cell.setValues("Total LM price", "\(totalLMPrice)")
    default:
      cell.setValues("Total LM Count", "\(totalLMCount)")
    }
    return cell
  }
  
  
  // MARK: - Private func
  
  private func registerCell() {
    let detailCell = UINib(nibName: "DetailCell", bundle: nil)
    tableView.register(detailCell, forCellReuseIdentifier: "DetailCell")
  }

}

extension DetailTableViewController: HaveTabBarItem {}
