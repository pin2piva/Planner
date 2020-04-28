//
//  StaticTableManager.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 4/28/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class StaticTableManager {
  
  static let shared = StaticTableManager()
  
  func setHideTo(cell: UITableViewCell!, when select: inout Bool, colorFor labels: [UILabel]!) {
     select.toggle()
     cell.setSelected(false, animated: true)
     setColorToTextIn(labels, select)
   }
   
   func setColorToTextIn(_ labels: [UILabel]!, _ when: Bool) {
     if when {
       labels.forEach({ $0.textColor = .systemBlue })
     } else {
       labels.forEach({ $0.textColor = .label })
     }
   }
  
}
