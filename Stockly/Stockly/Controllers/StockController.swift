//
//  StockController.swift
//  Stockly
//
//  Created by Victor  on 5/22/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation

class StockController {
    
    let dataGetter = DataGetter()
    
    var stocks: [Stock] = []

    let baseURL = URL(string: "https://www.alphavantage.co")!
    //https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=BA&apikey=demo
    let apiKey = "SXG08DL4S2EW8SKC"
    
    private enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    func fetchStock(for name: String, completion: @escaping (Error?) -> Void) {
        
        let searchURL = baseURL.appendingPathComponent("query/?function=SYMBOL_SEARCH&keywords=\(name)&apikey=\(apiKey)")
        
        var request = URLRequest(url: searchURL)
        request.httpMethod = HTTPMethod.get.rawValue
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            //error handling for fetched data
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                //logic to decode and store data
                let data = try jsonDecoder.decode(Stock.self, from: data)
                self.stocks = [data]
                completion(nil)
            } catch {
                NSLog("Error while decoding pokemon: \(error)")
                completion(error)
                return
            }
            }.resume()
    }
    
    
    
}
