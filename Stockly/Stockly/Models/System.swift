//
//  System.swift
//  Stockly
//
//  Created by Victor Ruiz on 3/5/20.
//  Copyright © 2020 com.Victor. All rights reserved.
//

import Foundation
import UIKit

struct System {
    static func clearNavigationBar(forBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
}
