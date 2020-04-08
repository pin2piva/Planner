//
//  SplashViewController.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
// MARK: - Private properties
    
    private let actitvityIndicator = UIActivityIndicatorView(style: .large)
    
// MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        makeServiceCall()
    }
    
// MARK: - Private Methods
    
    private func initialSetup() {
        actitvityIndicator.color = .white
        view.backgroundColor = .black
        view.addSubview(actitvityIndicator)
        actitvityIndicator.center = view.center
    }
    
    private func makeServiceCall() {
        actitvityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            self.actitvityIndicator.stopAnimating()
            AppDelegate.shared.rootViewController.showMainTable()
        }
    }

}
