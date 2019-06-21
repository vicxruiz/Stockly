//
//  UserStock.swift
//  Stockly
//
//  Created by Victor  on 6/20/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation

class UserStock: NSObject {
    var id: String
    var stockSymbol: String
    var stockName: String
    var stockPerenctage: Double
    var stockLatestPrice: Double
    
    init(id: String, stockSymbol: String, stockName: String, stockPercentage: Double, stockLatestPrice: Double) {
        self.id = id
        self.stockSymbol = stockSymbol
        self.stockName = stockName
        self.stockLatestPrice = stockLatestPrice
        self.stockPerenctage = stockPercentage
    }
}
