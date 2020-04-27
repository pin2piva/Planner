//
//  DetailCell.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/24/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

  @IBOutlet private weak var firstLabel: UILabel!
  @IBOutlet private weak var secondLabel: UILabel!
  
  func setValues(_ first: String, _ second: String) {
    firstLabel.text = first
    secondLabel.text = second
  }
  
}
