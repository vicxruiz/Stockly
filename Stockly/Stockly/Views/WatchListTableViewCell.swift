//
//  WatchListTableViewCell.swift
//  Stockly
//
//  Created by Victor  on 6/20/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit

class WatchListTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var latestPriceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!

    //MARK: - Properties
    
    var stock: UserStock? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Helpers
    
    func updateViews() {
        percentLabel.layer.masksToBounds = true
        percentLabel.layer.cornerRadius = 5
        guard let stock = stock else {
            print("no stock")
            return
        }
        nameLabel.text = stock.stockName
        let roundedPercent = Double(round(1000 * stock.stockPerenctage)/1000)
        percentLabel.text = "\(roundedPercent)%"
        symbolLabel.text = stock.stockSymbol
        latestPriceLabel.text = "$\(stock.stockLatestPrice)"
        if "\(stock.stockPerenctage)".contains("-") {
            percentLabel.textColor = UIColor.red
        } else {
            percentLabel.textColor = UIColor.green
        }
    }
    
}
