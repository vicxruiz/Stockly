//
//  ProfileTableViewController.swift
//  Stockly
//
//  Created by Victor  on 6/20/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import JGProgressHUD

class ProfileTableViewController: UITableViewController {
    
    var watchList: [UserStock] = []
    var ref: DatabaseReference!
    var dataGetter = DataGetter()
    
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud.textLabel.text = "Loading Watchlist..."
        hud.show(in: view, animated: true)
        addStockToArray()
    }
    
    func addStockToArray() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        ref = Database.database().reference().child("users").child(uid).child("WatchList")
        ref.observe(.value) { (snapShot) in
            if snapShot.childrenCount > 0 {
                self.watchList.removeAll()
                for myStocks in snapShot.children.allObjects as! [DataSnapshot] {
                    let stockObject = myStocks.value as? [String: AnyObject]
                    guard let stockName = stockObject?["stock name"] as? String else {
                        print("name not returned")
                        return
                    }
                    guard let stockSymbol = stockObject?["stock symbol"] as? String else {
                        print("symbol not returned")
                        return
                    }
                    guard let stockPercentage = stockObject?["stock percent"] as? String else {
                        print("percent not returned")
                        return
                    }
                    guard let stockPrice = stockObject?["stock price"] as? String else {
                        print("price not returned")
                        return
                    }
                    guard let stockID = stockObject?["id"] as? String else {
                        print("id not returned")
                        return
                    }
                    
                    guard let percent = Double(stockPercentage) else {
                        print("no percent")
                        return}
                    guard let price = Double(stockPrice) else {
                        print("no price")
                        return}
                    let myStock = UserStock(id: stockID, stockSymbol: stockSymbol, stockName: stockName, stockPercentage: percent, stockLatestPrice: price)
                    self.watchList.append(myStock)
                    self.hud.dismiss(animated: true)
                    self.tableView.reloadData()
                    print("done reloading with obj")
                }
            } else {
                print("no children")
                self.hud.dismiss()
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
            return "Watch List"
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WatchListCell", for: indexPath)
        guard let watchListCell = cell as? WatchListTableViewCell else {
            print("no cell")
            return cell}
        let stock = watchList[indexPath.row]
        //passing data
        watchListCell.dataGetter = dataGetter
        watchListCell.stock = stock
        print("data passed to cell")
        return cell
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchList.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let databaseRef: DatabaseReference!
            databaseRef = Database.database().reference()
            let stock = watchList[indexPath.row]
            let stockID = stock.id
            databaseRef.child("users").child(uid).child("WatchList").child("\(stockID)").removeValue(completionBlock: { (error, refer) in
                if error != nil {
                    DispatchQueue.main.async {
                        Service.showAlert(on: self, style: .alert, title: "Error deleting stock", message: "Please check your connection and try again")
                    }
                    print("Error: \(String(describing: error))")
                } else {
                    print(refer)
                    print("Child correctly removed")
                }
            })
            watchList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
