//
//  AlertManager.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class AlertManager {
  
  // MARK: Enums
  
  
  enum AlertTitles: String {
    case haveNoMark = "You have not entered a brand of cigarettes" // "Вы не ввели марку сигарет"
    case wrongPrice = "Amount entered incorrectly" // "Неправильно введена сумма"
    case haveNoPackSize = "No cigarette pack size entered" // "Не введен размер пачки сигарет"
    case naveChanges = "There are unsaved changes" // "Имеются несохраненные изменения"
  }
  
  enum AlertMessages: String {
    case haveNoMark = "Enter the brand or continue, then the brand name will be 'unknown'" // "Введите марку или продолжите, тогда название марки будет 'unkwown'"
    case wrongPrice = "Try entering an integer or decimal number" // "Попробуйте ввести целое или десятичное число"
    case haveNoPackSize = "Enter the quantity or continue, then the quantity will be 20" // "Введите количество или продолжите, тогда количество будет равно 20"
    case haveChanges = "If you go out, you will lose them" // "Если выйдете, то потеряете их"
  }
  
  enum AlertActionTitles: String {
    case ok = "OK"
    case enterValue = "Enter"
    case continueWithDefaultValue = "Continue"
  }
  
  // MARK: - Static func
  
  
  static func showAlert(title: AlertTitles, message: AlertMessages, style: UIAlertController.Style, presentIn view: UIViewController, completionHandler: (() -> [UIAlertAction])) {
    let alert = UIAlertController(title: title.rawValue, message: message.rawValue, preferredStyle: style)
    completionHandler().forEach({ alert.addAction($0) })
    view.present(alert, animated: true, completion: nil)
  }
  
}
