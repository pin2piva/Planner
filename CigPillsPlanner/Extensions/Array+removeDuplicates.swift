//
//  Array+removeDuplicates.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 5/2/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
  
  var removeDuplicates: [Element] {
    return Array(Set(self))
  }

}
