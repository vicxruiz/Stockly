//
//  ProfileController.swift
//  Stockly
//
//  Created by Victor Ruiz on 3/2/22.
//  Copyright © 2022 com.Victor. All rights reserved.
//

import Foundation

class ProfileController {
	
	let dataGetter = DataGetter()
	let baseURL = URL(string: "https://cloud.iexapis.com")!
	
	func fetchStock(_ stock: String, completion: @escaping (Error?, Batch?) -> Void) {
		//forms url
		var components = URLComponents()
		components.scheme = "https"
		components.host = "cloud.iexapis.com"
		components.path = "/stable/stock/\(stock.lowercased())/batch"
		
		//adds query items
		let queryTokenQuery = URLQueryItem(name: "token", value: "pk_751dcb0db9b34c09a037eaf739af02cb")
		let queryTypesQuery = URLQueryItem(name: "types", value: "quote,news,chart")
		let queryRangeQuery = URLQueryItem(name: "range", value: "1m")
		let queryLastQuery = URLQueryItem(name: "last", value: "5")
		components.queryItems = [queryTokenQuery, queryTypesQuery, queryRangeQuery, queryLastQuery]
		
		print(components.url ?? "no url")
		
		guard let url = components.url else {return}
		
		//Makes request
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		
		dataGetter.fetchData(with: request) { (_, data, error) in
			//error handling
			if let error = error {
				completion(error, nil)
			}
			guard let data = data else { return }
			
			//decoding
			let decoder = JSONDecoder()
			do {
				let data = try decoder.decode(Batch.self, from: data)
				completion(nil, data)
			} catch {
				print("error decoding data: \(error)")
				completion(error, nil)
			}
		}
	}
}
