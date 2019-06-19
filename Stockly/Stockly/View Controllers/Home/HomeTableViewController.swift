//
//  HomeViewController.swift
//  Stockly
//
//  Created by Victor  on 6/12/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit

class HomeTableViewController: UITableViewController {
    
    let stockController = StockController()
    let dataGetter = DataGetter()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockController.stocks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCollectionCell", for: indexPath)
        guard let stockHomeCell = cell as? HomeTableViewCell else {return cell}
        //passing data
        stockHomeCell.dataGetter = dataGetter
        let stock = stockController.stocks[indexPath.row]
        stockHomeCell.stock = stock
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StockDetail" {
            guard let destinationVC = segue.destination as? HomeStockDetialViewController, let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            stockController.stock = stockController.stocks[indexPath.row]
            destinationVC.stockController = stockController
        }
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    func fetch() {
        stockController.fetch { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                }
                self.tableView.reloadData()
                print("Table reloaded")
            }
        }
    }
}
