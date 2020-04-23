//
//  AlertManager.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class AlertManager {
  
  enum AlertTitles: String {
    case haveNoMark = "Вы не ввели марку сигарет"
    case wrongPrice = "Неправильно введена сумма"
    case haveNoPackSize = "Не введен размер пачки"
    case naveChanges = "Имеются несохраненные изменения"
  }
  
  enum AlertMessages: String {
    case haveNoMark = "Введите марку или продолжите, тогда название марки будет 'unkwown'"
    case wrongPrice = "Попробуйте ввести целое или дробное число"
    case haveNoPackSize = "Введите количество или продолжите, тогда количество будет равно 20"
    case haveChanges = "Если выйдете, то потеряете их"
  }
  enum AlertActionTitles: String {
    case ok = "OK"
    case enterValue = "Вести"
    case continueWithDefaultValue = "Продолжить!"
  }
  
  static func showAlert(title: AlertTitles, message: AlertMessages, style: UIAlertController.Style, presentIn view: UIViewController, completionHandler: (() -> [UIAlertAction])) {
    
    let alert = UIAlertController(title: title.rawValue, message: message.rawValue, preferredStyle: style)
    completionHandler().forEach({ alert.addAction($0) })
    view.present(alert, animated: true, completion: nil)
  }
  
}
