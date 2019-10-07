//
//  SearchTableViewCell.swift
//  Stockly
//
//  Created by Victor  on 10/7/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var exchangeLabel: UILabel!
    
    
    var stock: SearchStock? {
        didSet {
            updateViews()
        }
    }
    
    
    func updateViews() {
        guard let stock = stock else {return}
        nameLabel.text = stock.securityName
        symbolLabel.text = stock.symbol
        exchangeLabel.text = "Exchange: \(stock.exchange)"
    }
}
