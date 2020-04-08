//
//  CigaretteAccountingCell.swift
//  Cig'n'Pills Planner
//
//  Created by Artsiom Habruseu on 4/7/20.
//  Copyright © 2020 Artsiom Habruseu. All rights reserved.
//

import UIKit

protocol CigaretteCellProtocol {
    func setValues(_ storage: CigaretteCounterModel, indexPath: IndexPath)
}

class CigaretteAccountingCell: UITableViewCell, CigaretteCellProtocol {
    
    @IBOutlet weak var mark: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var lastTime: UILabel!
    @IBOutlet weak var markCount: UILabel!
    @IBOutlet weak var totalCount: UILabel!
    
    private var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValues(_ storage: CigaretteCounterModel, indexPath: IndexPath) {
        let element = storage.counter[indexPath.row]
        let currentMark = element.pack!.mark
        mark.text = currentMark
        price.text = "\(element.pack!.price)"

        lastTimeDynamicDelta(lastTime: element.lastReception)
        
        
        let markCountInt = storage.counter.enumerated().filter({ $0.offset >= indexPath.row && $0.element.pack?.mark == currentMark }).reduce(0, { $0 + $1.element.counter })
        
        markCount.text = String(markCountInt)
        totalCount.text = String(storage.totalCount)
    }
    
    private func lastTimeDynamicDelta(lastTime: Date?) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            guard let lastTime = lastTime else {
                timer.invalidate()
                return
            }
            self?.lastTime.text = DateManager.shared.differenceBetweenNow(and: lastTime)
        })
    }
    
}
