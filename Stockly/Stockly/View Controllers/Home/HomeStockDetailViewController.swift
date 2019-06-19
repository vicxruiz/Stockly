//
//  HomeStockDetailViewController.swift
//  Stockly
//
//  Created by Victor  on 6/18/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit

class HomeStockDetialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var stock: Stock?
    var stockController: StockController?
    var keyDataTableKeys = [
        "Previous Close", "Open", "Low", "High",
        "52 Week Low", "52 Week High", "Volume",
        "Average Volume", "Market Cap", "PE Ratio"
    ]

    
    @IBOutlet weak var keyDataTableView: UITableView!
    @IBOutlet weak var latestPriceLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyDataTableView.delegate = self
        keyDataTableView.dataSource = self
        
        guard let stockController = stockController else {
            print("no stock controller")
            return
        }
        self.title = stockController.stock?.symbol
        fetch()
        updateViews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyDataTableKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = keyDataTableView.dequeueReusableCell(withIdentifier: "keyDataTableViewCell", for: indexPath) as! KeyDataTableViewCell
        return cell
    }
    
    func fetch() {
        guard let stockController = stockController else {
            print("no controller")
            return}
        stockController.fetchStock(stockController.stock!) { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                }
                print(stockController.quote!)
                print(stockController.news!)
                print(stockController.chart!)
            }
        }
    }
    
    func updateViews() {
        guard let stockController = stockController, let latestPrice = stockController.quote?.latestPrice else {
            print("no stock controller for update Views")
            return
        }
        latestPriceLabel.text = "\(latestPrice)"
    }
    
}
