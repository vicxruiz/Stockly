//
//  Singleton.swift
//  Stockly
//
//  Created by Victor  on 5/23/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation


final class Singleton {
    
    static let shared = Singleton()
    
    var quoteArray = [Quote]()
    var quoteNewsArray = [[News]]()
    var quoteChartArray = [[Chart]]()
    //    var messagesArray = [[Messages]]()
    var statsArray = [Stats]()
    
}
