//
//  PackCollectionViewCell.swift
//  CigPillsPlanner
//
//  Created by Artsiom Habruseu on 5/5/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

class PackCollectionViewCell: UICollectionViewCell {
  
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
      label.layer.cornerRadius = 10
      label.layer.borderColor = UIColor.black.cgColor
      label.layer.borderWidth = 1
      label.backgroundColor = .white
      labels.append(label)
    }
    return labels
  }()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupCell()
    setupStacks()
    setupCommonStack()
    setupNumberLabel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //  func setCigaretteCount(_ count: Int) {
  //    for index in 0..<count {
  //      labels[index].alpha = 1
  //    }
  //  }
  //
  func setPackNumber(number: Int) {
    numberLabel.attributedText = "\(number)".getAttrWithStroke(fontSize: 45)
  }
  
  // MARK: - Setup private func
  
  
  private func setupNumberLabel() {
    numberLabel = UILabel()
    numberLabel.translatesAutoresizingMaskIntoConstraints = false
    numberLabel.textColor = .black
    numberLabel.alpha = 0.55
    numberLabel.textAlignment = .center
    contentView.addSubview(numberLabel)
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
    contentView.addSubview(commonStack)
    setupConstraints(to: commonStack)
  }
  
  private func setupConstraints(to view: UIView) {
    view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
    view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2).isActive = true
    view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2).isActive = true
    view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2).isActive = true
  }
  
  private func setupCell() {
    self.clipsToBounds = true
    self.layer.borderWidth = 2
    self.layer.borderColor = UIColor.darkGray.cgColor
    contentView.backgroundColor = .lightGray
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
