//
//  RootViewController.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
// MARK: - Private properties
    
    private var current: UIViewController!
    private var navController: UINavigationController!
    private var mainController: MainTableViewController!
    
// MARK: - Initialazators
    
    init() {
        self.current = SplashViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNewChild(current)
    }
    
// MARK: - Methods
    
    func showMainTable() {
        mainController = MainTableViewController()
        navController = UINavigationController(rootViewController: mainController)
        addNewChild(navController)
        removeOldChild(navController)
    }
    
    func addFirstSchedule() {
        let storyboard = UIStoryboard(name: "NewSchedule", bundle: nil)
        let addNewShedule = storyboard.instantiateViewController(identifier: "NewScheduleTableViewController") as! NewScheduleTableViewController
        navController = UINavigationController(rootViewController: addNewShedule)
        addNewChild(navController)
        removeOldChild(navController)
    }
    
    func showTabBarViewController() {
        
        let detail = DetailTableViewController(itemName: "Detail")
        let diagram = DiagramTableViewController(itemName: "Diagram")
        let visualization = VisualizationTableViewController(itemName: "Visual")
        let tabBarController = TabBarViewController(viewControllers: [detail, diagram, visualization])
        navController.pushViewController(tabBarController, animated: true)
    }
    
    func showAddNewSheduleController(_ currentSchedule: CigaretteScheduleModel?) {
        let storyboard = UIStoryboard(name: "NewSchedule", bundle: nil)
        let addNewShedule = storyboard.instantiateViewController(identifier: "NewScheduleTableViewController") as! NewScheduleTableViewController
        let new = UINavigationController(rootViewController: addNewShedule)
        new.presentationController?.delegate = (addNewShedule as UIAdaptivePresentationControllerDelegate)
        addNewShedule.delegate = self
        if let currentSchedule = currentSchedule {
            addNewShedule.setVaulesToOriginalProperties(from: currentSchedule)
        }
        navController.modalPresentationStyle = .automatic
        navController.present(new, animated: true, completion: nil)
    }
    
// MARK: Private methods
    
    private func addNewChild(_ controller: UIViewController) {
        addChild(controller)
        controller.view.frame = view.bounds
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    private func removeOldChild(_ controller: UIViewController) {
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = controller
    }

}


extension RootViewController: NewScheduleDelegate {
    
    func addDidFinish() {
        mainController.tableView.reloadData()
        navController.dismiss(animated: true)
    }
    
    func addDidCancel() {
        navController.dismiss(animated: true)
    }
    
    
}

