//
//  Collection.swift
//  Stockly
//
//  Created by Victor  on 6/13/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation

struct Stock: Codable {
    let symbol: String
    let companyName: String
    let latestPrice: Double?
    let open: Double?
    let close: Double?
    let high: Double?
}

struct StockCompany: Codable {
    let symbol: String
    let companyName: String
    let exchange: String
    let industry: String
    let description: String
    let CEO: String
    let employees: Int
}

struct Sector: Equatable {
    var name: String
    var isChosen: Bool
    init(name: String) {
        self.name = name
        self.isChosen = false
    }
}

struct TechRoot: Decodable {
    let AAPL: Batch
    let TSLA: Batch
    let FB: Batch
    let AMZN: Batch
    let BABA: Batch
}

struct HealthRoot: Decodable {
    let CELG: Batch
    let TEVA: Batch
    let ALXN: Batch
    let ALGN: Batch
    let ANTM: Batch
}

struct IndustrialRoot: Decodable {
    let HEI: Batch
    let DHR: Batch
    let TDG: Batch
    let ZBRA: Batch
    let SWK: Batch
}

struct Batch: Decodable {
    let quote: Quote
    let news: [News]
    let chart: [Chart]
}

struct Quote : Decodable {
    let symbol: String
    let companyName: String
    let latestPrice: Double?
    let change: Double?
    let changePercent: Double?
    let previousClose: Double?
    let open: Double?
    let iexBidPrice: Double?
    let iexAskPrice: Double?
    let high: Double?
    let low: Double?
    let close: Double?
    let week52Low: Double?
    let week52High: Double?
    let latestVolume: Double?
    let avgTotalVolume: Double?
    let marketCap: Double?
    let peRatio: Double?
}

struct News: Decodable {
    let datetime: Int?
    let headline: String?
    let source: String?
    let url: String?
    let summary: String?
    let related: String?
}

struct Chart: Decodable {
    let date: String?
    let open: Double?
    let high: Double?
    let low: Double?
    let close: Double?
    let volume: Double?
    let unadjustedVolume: Double?
    let change: Double?
    let changePercent: Double?
    let vwap: Double?
    let label: String?
    let changeOverTime: Double?
}

struct Logo: Decodable {
    let url: String
}
