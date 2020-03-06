//
//  MainTabBarViewController.swift
//  Stockly
//
//  Created by Victor  on 5/22/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.layer.borderWidth = 0
        self.tabBar.clipsToBounds = true
        setupViewControllers()
    }
    
    //MARK: - Helpers
    
    fileprivate func setupViewControllers() {
        tabBar.unselectedItemTintColor = Service.designGrayColor
        tabBar.tintColor = Service.stocklyDesignTheme
    }
    
}
