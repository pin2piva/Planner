//
//  String+attributeWithStroke.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 5/6/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation
import UIKit

extension String {
  
  func getAttrWithStroke(fontSize: CGFloat) -> NSAttributedString {
    let font = UIFont.boldSystemFont(ofSize: fontSize)
    let shadow = NSShadow()
    shadow.shadowBlurRadius = 5
    shadow.shadowColor = UIColor.black
    let attributes: [NSAttributedString.Key: Any] = [
      .font: font,
      .foregroundColor: UIColor.white,
      .strokeWidth: -3,
      .strokeColor: UIColor.black,
      .shadow: shadow
    ]
    return NSAttributedString(string: self, attributes: attributes)
  }
  
}
