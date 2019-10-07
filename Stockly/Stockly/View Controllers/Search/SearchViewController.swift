//
//  SearchViewController.swift
//  Stockly
//
//  Created by Victor  on 5/23/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    //MARK: Properties
    let stockController = StockController()
    var searchResults: [SearchStock] = []
    @IBOutlet weak var tableView: UITableView!
    var enteredText = ""
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 350, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
        setTableView()
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    //Customizing search bar
    func setSearchBar() {
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.barStyle = UIBarStyle.default
        searchBar.placeholder = "Enter Company Name or Ticker"
        navigationItem.titleView = searchBar
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.gray
        textFieldInsideSearchBar?.textAlignment = .center
        hideKeyboardWhenTapped()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func hideKeyboardWhenTapped() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard1))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard1() {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(makeSearchRequest), object: nil)
        guard let searchText = searchBar.text else {
            Service.showAlert(on: self, style: .alert, title: "Search Error", message: "Please enter valid company name or ticker.")
            return
        }
        enteredText = searchText
        self.perform(#selector(makeSearchRequest), with: nil, afterDelay: 0.5)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    @objc func makeSearchRequest() {
        if enteredText == "" {
            return
        }
        stockController.searchStock(with: enteredText) { (results, error) in
            if let error = error {
                DispatchQueue.main.async {
                    Service.showAlert(on: self, style: .alert, title: "Search Error", message: error.localizedDescription)
                }
            }
            if let results = results {
                self.searchResults = results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
//    func makeBatchRequest() {
//        stockController.fetchStock(enteredSymbol) { (error) in
//
//            var noValidStock = false
//            if self.stockController.quote?.companyName == nil {
//                noValidStock = true
//            }
//            DispatchQueue.main.async {
//                if let error = error {
//                    print(error)
//                }
//                if noValidStock {
//                    Service.showAlert(on: self, style: .alert, title: "Search Error", message: "Please Provide Valid Symbol")
//                    return
//                }
//                self.performSegue(withIdentifier: "SearchStock", sender: self)
//                print("done")
//            }
//
//        }
//    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        
        let stock = searchResults[indexPath.row]
        cell.textLabel?.text = stock.securityName
        cell.detailTextLabel?.text = stock.symbol
        
        return cell
    }
    
}


extension SearchViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchStock" {
            let destinationVC = segue.destination as! ResultsViewController
            destinationVC.stockController = stockController
        }
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
}


