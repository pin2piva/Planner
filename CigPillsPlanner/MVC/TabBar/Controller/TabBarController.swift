//
//  TabBarController.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
  
  init(viewControllers: [HaveTabBarItem]) {
    let controllers = viewControllers.enumerated().map { (item) -> UIViewController in
      let controller = item.element as! UIViewController
      controller.tabBarItem = UITabBarItem(title: item.element.itemName, image: UIImage(named: item.element.itemName), tag: item.offset)
      return controller
    }
    super.init(nibName: nil, bundle: nil)
    self.viewControllers = controllers
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}
