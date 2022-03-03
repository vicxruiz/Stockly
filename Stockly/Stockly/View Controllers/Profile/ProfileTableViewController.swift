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
	var symbolList: [String] = []
    var ref: DatabaseReference!
    var dataGetter = DataGetter()
	var timer: Timer?
	var profileController = ProfileController()
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		hud.textLabel.text = "Loading Watchlist..."
		hud.show(in: view, animated: true)
		addStockToArray()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		timer?.invalidate()
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

extension ProfileTableViewController {
	func addStockToArray() {
		guard let uid = Auth.auth().currentUser?.uid else {return}
		ref = Database.database().reference().child("users").child(uid).child("WatchList")
		ref.observe(.value) { (snapShot) in
			if snapShot.childrenCount > 0 {
				self.symbolList.removeAll()
				for myStocks in snapShot.children.allObjects as! [DataSnapshot] {
					let stockObject = myStocks.value as? [String: AnyObject]
					guard let stockSymbol = stockObject?["stock symbol"] as? String else {
						print("symbol not returned")
						return
					}
					self.symbolList.append(stockSymbol)
				}
				self.updateStockData()
			} else {
				self.hud.dismiss()
			}
		}
	}
	
	func updateStockData() {
		timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
	}
	
	@objc func fireTimer() {
		self.watchList.removeAll()
		let dispatchGroup = DispatchGroup()
		for symbol in symbolList {
			dispatchGroup.enter()
			profileController.fetchStock(symbol) { error, batch in
				if let error = error {
					DispatchQueue.main.async {
						Service.showAlert(on: self, style: .alert, title: "Error fetching stock", message: error.localizedDescription)
					}
					return
				}
				if let batch = batch {
					let quote = batch.quote
					let myStock = UserStock(id: quote.symbol, stockSymbol: quote.symbol, stockName: quote.companyName, stockPercentage: quote.changePercent ?? 0.0, stockLatestPrice: quote.latestPrice ?? 0.0)
					self.watchList.append(myStock)
				}
				dispatchGroup.leave()
			}
		}
		dispatchGroup.notify(queue: .main) {
			self.watchList.sort { $0.stockName < $1.stockName }
			self.hud.dismiss(animated: true)
			self.tableView.reloadData()
			print("tableView reloaded")
		}
	}
}
