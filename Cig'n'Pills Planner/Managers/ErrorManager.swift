//
//  ErrorManager.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import Foundation

enum Errors: String, Error {
    case haveNoMark = "Вы не ввели марку сигарет"
    case wrongPrice = "Неправильно введена сумма"
    case haveNoPackSize = "Не введен размер пачки"
}

extension Errors: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString(rawValue, comment: "")
    }
}
