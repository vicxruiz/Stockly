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
    
    var enteredSymbol = ""
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 350, height: 20))
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    //Customizing search bar
    func setSearchBar() {
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.barStyle = UIBarStyle.default
        searchBar.placeholder = "Enter Company Ticker"
        navigationItem.titleView = searchBar
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.gray
        textFieldInsideSearchBar?.textAlignment = .center
        hideKeyboardWhenTappedAround()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        enteredSymbol = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //makeBatchRequest()
    }
    
}


extension SearchViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
}
