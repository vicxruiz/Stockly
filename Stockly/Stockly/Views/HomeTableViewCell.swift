//
//  HomeTableViewCell.swift
//  Stockly
//
//  Created by Victor  on 6/12/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit

class HomeTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var stockNameLabel: UILabel!
    @IBOutlet weak var stockPriceLabel: UILabel!
    @IBOutlet weak var stockSymbolLabel: UILabel!
    @IBOutlet weak var stockChangeLabel: UILabel!
    
    //MARK: - Properties
    
    var stock: Batch? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: Helpers
    
    func updateViews() {
        stockChangeLabel.layer.masksToBounds = true
        stockChangeLabel.layer.cornerRadius = 5
        guard let stock = stock else {
            print("no stock")
            return
        }
        stockNameLabel.text = stock.quote.companyName
        guard let stockLatestPrice = stock.quote.latestPrice else {
            return
        }
        if let stockChangePerecntage = stock.quote.changePercent {
            let roundedPercent = Double(round(1000 * stockChangePerecntage)/1000)
           stockChangeLabel.text = "\(roundedPercent)%"
        }
        stockSymbolLabel.text = stock.quote.symbol
        stockPriceLabel.text = "$\(stockLatestPrice)"
        if "\(stock.quote.change)".contains("-") {
            stockChangeLabel.textColor = UIColor.red
        } else {
            stockChangeLabel.textColor = UIColor.green
        }
    }
    
}
