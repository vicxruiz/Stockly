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
    
    let techStockController = TechStockController()
    let healthStockController = HealthStockController()
    let industrialStockController = IndustrialStockController()
    let stockController = StockController()
    let dataGetter = DataGetter()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTechStocks()
        fetchHealthStocks()
        fetchIndustrialStocks()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return techStockController.techStocks.count
        } else if section == 1 {
            return healthStockController.healthStocks.count
        } else {
            return industrialStockController.industrialStocks.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCollectionCell", for: indexPath)
        let stock = stockFor(indexPath: indexPath)
        guard let stockHomeCell = cell as? HomeTableViewCell else {return cell}
        //passing data
        stockHomeCell.dataGetter = dataGetter
        stockHomeCell.stock = stock
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StockDetail" {
            guard let destinationVC = segue.destination as? HomeStockDetialViewController, let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            destinationVC.techStockController = techStockController
            destinationVC.healthStockController = healthStockController
            destinationVC.industrialStockController = industrialStockController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                destinationVC.stock = stockFor(indexPath: indexPath)
            }
        }
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    func fetchTechStocks() {
        techStockController.fetchTechStocks { (error) in
            guard let appleStock = self.techStockController.appleStock, let teslaStock = self.techStockController.teslaStock, let amazonStock = self.techStockController.amazonStock, let fbStock = self.techStockController.fbStock, let babaStock = self.techStockController.babaStock else {
                return
            }
            self.techStockController.techStocks = [appleStock, teslaStock, amazonStock, fbStock, babaStock]
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                }
                self.tableView.reloadData()
                print("Table reloaded")
            }
        }
    }
    
    func fetchHealthStocks() {
        healthStockController.fetchHealthStocks { (error) in
            guard let celgStock = self.healthStockController.celgStock, let algnStock = self.healthStockController.algnStock, let alxnStock = self.healthStockController.alxnStock, let antmStock = self.healthStockController.antmStock, let tevaStock = self.healthStockController.tevaStock else {
                return
            }
            self.healthStockController.healthStocks = [celgStock, algnStock, alxnStock, antmStock, tevaStock]
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                }
                self.tableView.reloadData()
                print("Table reloaded")
            }

        }
    }
    
    func fetchIndustrialStocks() {
        industrialStockController.fetchIndustrialStocks { (error) in
            guard let heiStock = self.industrialStockController.heiStock, let dhrStock = self.industrialStockController.dhrStock, let tdgStock = self.industrialStockController.tdgStock, let zbraStock = self.industrialStockController.zbraStock, let swkStock = self.industrialStockController.swkStock else {
                return
            }
            self.industrialStockController.industrialStocks = [heiStock, dhrStock, tdgStock, zbraStock, swkStock]
            
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                }
                self.tableView.reloadData()
                print("Table reloaded")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //updates header view ui
        view.tintColor = Service.stocklySecondaryTheme
        guard let header = view as? UITableViewHeaderFooterView else {return}
        
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        header.textLabel?.textColor = Service.stocklyDesignTheme
        header.textLabel?.textAlignment = .left
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //updates header height
        return 44
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //logic for each section
        if (section == 0) {
            return "Technology"
        } else if (section == 1) {
            return "Health Care"
        } else if (section == 2) {
            return "Industrial"
        } else {
            return nil
        }
    }
    
    //logic to get Stock index path
    private func stockFor(indexPath: IndexPath) -> Batch {
        
        if indexPath.section == 0 {
            return techStockController.techStocks[indexPath.row]
        } else if indexPath.section == 1 {
            return healthStockController.healthStocks[indexPath.row]
        } else {
            return industrialStockController.industrialStocks[indexPath.row]
        }
    }
}
