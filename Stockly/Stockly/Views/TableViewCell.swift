//
//  TableViewCell.swift
//  Stockly
//
//  Created by Victor  on 5/23/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit

class KeyDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var keyDataKeyLabel: UILabel!
    @IBOutlet weak var keyDataValueLabel: UILabel!
}

class StatsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statsKeyLabel: UILabel!
    @IBOutlet weak var statsValueLabel: UILabel!
}


class DividendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dividendKeyLabel: UILabel!
    @IBOutlet weak var dividendValueLabel: UILabel!
}



class TradeDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tradeDataKeyLabel: UILabel!
    @IBOutlet weak var tradeDataValueLabel: UILabel!
    
}


class FinancialsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var financialsKeyLabel: UILabel!
    @IBOutlet weak var financialsValueLabel: UILabel!
}
