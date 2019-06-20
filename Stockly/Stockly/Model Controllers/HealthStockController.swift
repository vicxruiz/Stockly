//
//  HealthStockController.swift
//  Stockly
//
//  Created by Victor  on 6/19/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation

class HealthStockController {
    //passing data
    let dataGetter = DataGetter()
    let baseURL = URL(string: "https://cloud.iexapis.com")!
    var healthStocks: [Batch] = []
    var celgStock: Batch?
    var tevaStock: Batch?
    var alxnStock: Batch?
    var algnStock: Batch?
    var antmStock: Batch?
    var healthStock: Batch?
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    func fetchHealthStocks(completion: @escaping (Error?) -> Void) {
        //forms url
        var components = URLComponents()
        components.scheme = "https"
        components.host = "cloud.iexapis.com"
        components.path = "/stable/stock/market/batch"
        
        //adds query items
        let queryTokenQuery = URLQueryItem(name: "token", value: "pk_751dcb0db9b34c09a037eaf739af02cb")
        let querySymbolQuery = URLQueryItem(name: "symbols", value: "celg,teva,alxn,algn,antm")
        let queryTypesQuery = URLQueryItem(name: "types", value: "quote,news,chart")
        let queryRangeQuery = URLQueryItem(name: "range", value: "1m")
        let queryLastQuery = URLQueryItem(name: "last", value: "5")
        components.queryItems = [queryTokenQuery, querySymbolQuery, queryTypesQuery, queryRangeQuery, queryLastQuery]
        
        print(components.url ?? "no url")
        
        guard let url = components.url else {return}
        
        //Makes request
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            //error handling
            if let error = error {
                completion(error)
            }
            guard let data = data else { return }
            
            //decoding
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode(HealthRoot.self, from: data)
                self.algnStock = data.ALGN
                self.tevaStock = data.TEVA
                self.alxnStock = data.ALXN
                self.celgStock = data.CELG
                self.antmStock = data.ANTM
                completion(nil)
            } catch {
                print("error decoding data: \(error)")
                completion(error)
            }
        }
    }
}
