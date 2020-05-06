//
//  VisualizationTableViewController.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class VisualizationCollectionViewController: UIViewController {
  
  let itemName: String
  
  init(itemName: String) {
    self.itemName = itemName
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - View properties
  
  
  private var currentPackView: UIView!
  private var firstStack: UIStackView!
  private var secondStack: UIStackView!
  private var secondStackView: UIView!
  private var thirdStack: UIStackView!
  private var numberLabel: UILabel!
  private let labels: [UILabel] = {
    var labels = [UILabel]()
    for _ in 1...20 {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.clipsToBounds = true
      label.layer.cornerRadius = 20
      label.layer.borderColor = UIColor.black.cgColor
      label.layer.borderWidth = 1
      label.alpha = 0
      label.backgroundColor = .white
      labels.append(label)
    }
    return labels
  }()
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(PackCollectionViewCell.self, forCellWithReuseIdentifier: "customCell")
    return collectionView
  }()
  
  // MARK: - Other properties
  
  
  private var number: Int {
    DayliDataManager.shared.getTotalCount()
  }
  
  private var fullPacksCount: Int {
    number / 20
  }
  private var openPack: Int {
    number % 20
  }
  private var cellSize: CGSize {
    let widht = view.bounds.width / 2 - 15
    let height = widht / 2.4
    return CGSize(width: widht, height: height)
  }
  
  // MARK: - Life cycle
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCurrentView()
    setupCollection()
    setupStacks()
    setupCommonStack()
    setupNumberLabel(fullPacksCount + 1)
    setCigaretteCount(openPack)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    currentPackView.reloadInputViews()
    collectionView.reloadData()
    if view.traitCollection.userInterfaceStyle == .dark {
      view.backgroundColor = .black
    } else {
      view.backgroundColor = .white
    }
  }
  
  // MARK: - Private func
  
  
  private func setupCollection() {
    view.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.topAnchor.constraint(equalTo: currentPackView.bottomAnchor).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
  
  private func setupNumberLabel(_ number: Int) {
    numberLabel = UILabel()
    numberLabel.translatesAutoresizingMaskIntoConstraints = false
    numberLabel.textColor = .black
    numberLabel.alpha = 0.55
    numberLabel.attributedText = "\(number)".getAttrWithStroke(fontSize: 90)
    numberLabel.textAlignment = .center
    currentPackView.addSubview(numberLabel)
    setupConstraints(to: numberLabel)
  }
  
  private func setupStacks() {
    secondStackView = UIView()
    firstStack = getStackView(with: labels[13...19].map({$0}))
    secondStack = getStackView(with: labels[7...12].map({$0}))
    thirdStack = getStackView(with: labels[0...6].map({$0}))
    secondStackView.addSubview(secondStack)
    secondStack.topAnchor.constraint(equalTo: secondStackView.topAnchor).isActive = true
    secondStack.bottomAnchor.constraint(equalTo: secondStackView.bottomAnchor).isActive = true
    secondStack.widthAnchor.constraint(equalTo: secondStackView.widthAnchor, multiplier: 6 / 7).isActive = true
    secondStack.centerXAnchor.constraint(equalTo: secondStackView.centerXAnchor).isActive = true
  }
  
  private func setupCommonStack() {
    let commonStack = UIStackView(arrangedSubviews: [firstStack, secondStackView, thirdStack])
    commonStack.translatesAutoresizingMaskIntoConstraints = false
    commonStack.alignment = .fill
    commonStack.distribution = .fillEqually
    commonStack.axis = .vertical
    commonStack.spacing = 0
    currentPackView.addSubview(commonStack)
    setupConstraints(to: commonStack)
  }
  
  private func setupConstraints(to view: UIView) {
    view.topAnchor.constraint(equalTo: currentPackView.topAnchor, constant: 4).isActive = true
    view.leadingAnchor.constraint(equalTo: currentPackView.leadingAnchor, constant: 4).isActive = true
    view.trailingAnchor.constraint(equalTo: currentPackView.trailingAnchor, constant: -4).isActive = true
    view.bottomAnchor.constraint(equalTo: currentPackView.bottomAnchor, constant: -4).isActive = true
  }
  
  private func setupCurrentView() {
    currentPackView = UIView(frame: .zero)
    currentPackView.translatesAutoresizingMaskIntoConstraints = false
    currentPackView.clipsToBounds = true
    currentPackView.layer.cornerRadius = 15
    currentPackView.layer.borderWidth = 4
    currentPackView.layer.borderColor = UIColor.darkGray.cgColor
    currentPackView.backgroundColor = .lightGray
    view.addSubview(currentPackView)
    currentPackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
    currentPackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
    currentPackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    currentPackView.heightAnchor.constraint(equalToConstant: (view.bounds.width - 20) / 2.4).isActive = true
  }
  
  private func setCigaretteCount(_ count: Int) {
    for index in 0..<count {
      labels[index].alpha = 1
    }
  }
  
  private func getStackView(with labels: [UIView]) -> UIStackView {
    let stack = UIStackView(arrangedSubviews: labels)
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.alignment = .fill
    stack.distribution = .fillEqually
    stack.axis = .horizontal
    stack.spacing = 0
    return stack
  }
  
}

// MARK: - Extension CollectionViewDataSource


extension VisualizationCollectionViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return fullPacksCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! PackCollectionViewCell
    cell.layer.cornerRadius = cell.bounds.height / 10
    cell.setPackNumber(number: fullPacksCount - indexPath.item)
    return cell
  }
  
}

// MARK: - Extension CollectionViewDelegate


extension VisualizationCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return cellSize
  }
}


extension VisualizationCollectionViewController: HaveTabBarItem {}
