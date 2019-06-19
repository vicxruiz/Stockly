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
    @IBOutlet weak var stockNameLabel: UILabel!
    @IBOutlet weak var stockPriceLabel: UILabel!
    
    var dataGetter: DataGetter?
    var stock: Stock? {
        didSet {
            updateViews()
        }
    }
    
    
    func updateViews() {
        guard let stock = stock, let stockPrice = stock.latestPrice else {
            stockPriceLabel.text = "0"
            print("No Stock in view cell")
            return
        }
        stockNameLabel.text = stock.companyName
        stockPriceLabel.text = "\(stockPrice)"
    }
    
}
