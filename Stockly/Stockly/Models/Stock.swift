//
//  Stock.swift
//  Stockly
//
//  Created by Victor  on 5/22/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation

struct Root: Codable {
    let feed: Feed
}

struct Feed: Codable {
    let results: [Stock]
}

struct Stock: Codable {
    let id: Int
    let ticker: String
    let data: Thresholds
}

struct Thresholds: Codable {
    let actionThresholds: Feature
}

struct Feature: Codable {
    let TA: Analysis
}

struct Analysis: Codable {
    let sell: Int
    let hold: Int
    let buy: Int
}
