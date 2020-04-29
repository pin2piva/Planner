//
//  DiagramTableViewController.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class DiagramTableViewController: UITableViewController {
  
  var itemName: String
  
  init(itemName: String) {
    self.itemName = itemName
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = .orange
  }
  
}

extension DiagramTableViewController: HaveTabBarItem {}
