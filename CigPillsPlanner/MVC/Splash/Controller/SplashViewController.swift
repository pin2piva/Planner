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
  
  
  private var circle: CAShapeLayer! {
    didSet {
      circle.lineWidth = 6
      circle.fillColor = nil
      circle.strokeEnd = 0
      circle.lineCap = .round
      if view.traitCollection.userInterfaceStyle == .dark {
        circle.strokeColor = UIColor.lightGray.cgColor
      } else {
        circle.strokeColor = UIColor.black.cgColor
      }
    }
  }
  private let animation = CABasicAnimation(keyPath: "strokeEnd")
  private var imageView: UIImageView!
  //  private var actitvityIndicator: UIActivityIndicatorView!
  
  // MARK: - Life cycle
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupImageView()
    makeServiceCall()
    setupCircle()
    animationConfiguration()
    //    activityIndicatorSetup()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    circle.strokeEnd = 0
    circle.add(animation, forKey: nil)
  }
  
  
  
  // MARK: - Private func
  
  private func animationConfiguration() {
    animation.toValue = 1
    animation.duration = 2.5
    animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
    animation.fillMode = .both
    animation.isRemovedOnCompletion = false
  }
  
  private func setupCircle() {
    circle = CAShapeLayer()
    view.layer.addSublayer(circle)
    circleConfiguration()
  }
  
  private func circleConfiguration() {
    circle.frame = view.bounds
    let path = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: view.bounds.origin.x + view.bounds.width / 2 - view.bounds.width / 3, y: view.bounds.origin.x + view.bounds.height / 2 - view.bounds.width / 3), size: CGSize(width: view.bounds.width * 2 / 3, height: view.bounds.width * 2 / 3)))
    circle.path = path.cgPath
  }
  
  private func setupImageView() {
    imageView = UIImageView(frame: CGRect(origin: CGPoint(x: view.bounds.origin.x, y: view.bounds.origin.y), size: CGSize(width: view.bounds.width * 2 / 3, height: view.bounds.width * 2 / 3)))
    if view.traitCollection.userInterfaceStyle == .dark {
      imageView.image = UIImage(named: "Splash-dark")
      view.backgroundColor = .black
    } else {
      imageView.image = UIImage(named: "Splash-white")
      view.backgroundColor = .white
    }
    view.addSubview(imageView)
    imageView.center = view.center
  }
  
  private func makeServiceCall() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
      if UserDefaults.standard.bool(forKey: "NOTfirstTime") {
        AppDelegate.shared.rootViewController.showMainTable()
      } else {
        AppDelegate.shared.rootViewController.addFirstSchedule()
      }
    }
  }
  
  //  private func activityIndicatorSetup() {
  //    actitvityIndicator = UIActivityIndicatorView(style: .medium)
  //    if view.traitCollection.userInterfaceStyle == .dark {
  //      actitvityIndicator.color = .white
  //      view.backgroundColor = .black
  //    } else {
  //      actitvityIndicator.color = .black
  //      view.backgroundColor = .white
  //    }
  //    view.addSubview(actitvityIndicator)
  //    actitvityIndicator.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
  //    actitvityIndicator.center = CGPoint(x: view.center.x, y: view.center.y + view.bounds.height / 5)
  //  }
  
}
